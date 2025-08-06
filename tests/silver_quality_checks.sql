/**
 Queries to check the data quality of the silver layer
**/


--
-- Checking silver.crm_cust_info
--


-- Check for nulls or duplicates in primary key

SELECT 
	cst_id, 
	COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No results
SELECT 
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data Standardization and Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


SELECT * FROM silver.crm_cust_info;
-- ==============================================
--
-- Checking silver.crm_prd_info
--
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

SELECT DISTINCT prd_line 
FROM silver.crm_prd_info;

SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


SELECT * FROM silver.crm_prd_info;

-- ===============================================
--
-- Checking silver.crm_sales_details
--
SELECT * FROM silver.crm_sales_details;
SELECT * FROM silver.crm_sales_details
WHERE sls_ord != TRIM(sls_ord); -- No unwanted spaces in column

SELECT * FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key); -- No unwanted spaces in column

SELECT * FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info); -- Product keys are consistent across tables

SELECT * FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info); -- Customer ids are consistent across tables

SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


SELECT 
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR
	sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
	sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;

-- =========================================================================
--
-- Checking silver.erp_cust_az12
--
SELECT *
FROM silver.erp_cust_az12
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

SELECT 
	DISTINCT bdate
FROM silver.erp_cust_az12
WHERE  bdate > GETDATE();

SELECT 
	DISTINCT gen 
FROM silver.erp_cust_az12;

-- =========================================================================
--
-- Checking silver.erp_loc_a101
--

SELECT 
	REPLACE(cid,'-','') AS cid,
	cntry
FROM silver.erp_loc_a101
WHERE REPLACE(cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

SELECT DISTINCT cntry FROM silver.erp_loc_a101;

-- =========================================================================
--
-- Checking silver.erp_px_cat_g1v2
--
SELECT 
	id,
	cat,
	subcat,
	maintenance
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

SELECT DISTINCT cat FROM silver.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM silver.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM silver.erp_px_cat_g1v2;

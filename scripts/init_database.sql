/*
================================================
Create Database and Schemas
================================================
Script purpose:
	Creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated.

	Additionally, the script sets up three schemas within the database:
	'bronze', 'silver', and 'gold'

WARNING: 
	This will drop the 'DataWarehouse' database if it exists and permanently 
	delete data stored within it. Ensure backups before proceeding.

*/
USE master;

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO
-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO 
CREATE SCHEMA gold;
GO


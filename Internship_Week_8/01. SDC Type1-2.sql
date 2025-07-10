/*

SCD - SLOWLY CHANGING DIMENSIONS

Slowly Changing Dimensions are techniques to manage and track changes in dimension tables over time in a data warehouse.
Why? Because dimensional data (like customer, product) changes slowly and you often need to decide: should we overwrite old data, or keep history?

SCD Type 1: Overwrite old data (no history).
SCD Type 2: Keep full history by creating multiple records.

*/


IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomer;

CREATE TABLE dbo.DimCustomer
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,  
    CustomerID INT,                            
    CustomerName NVARCHAR(100),
    Address NVARCHAR(200),
    StartDate DATETIME,                        -- SCD Type 2: effective start date
    EndDate DATETIME,                          -- SCD Type 2: effective end date
    IsCurrent BIT                              -- SCD Type 2: flag for current record
);


INSERT INTO dbo.DimCustomer (CustomerID, CustomerName, Address, StartDate, EndDate, IsCurrent)
VALUES
(101, 'Alice', '123 Main Street', GETDATE(), '9999-12-31', 1),
(102, 'Bob', '456 Oak Avenue', GETDATE(), '9999-12-31', 1);


--SCD Type 1 
UPDATE dbo.DimCustomer
SET Address = '789 Pine Road'
WHERE CustomerID = 102 AND IsCurrent = 1;


-- SCD Type 2 
UPDATE dbo.DimCustomer
SET EndDate = GETDATE(), IsCurrent = 0
WHERE CustomerID = 101 AND IsCurrent = 1;


INSERT INTO dbo.DimCustomer (CustomerID, CustomerName, Address, StartDate, EndDate, IsCurrent)
VALUES
(101, 'Alice', '999 New Street', GETDATE(), '9999-12-31', 1);



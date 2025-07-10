/*

SCD Type 3: Track limited history (usually one previous value)
Type 4: Keep history in a separate historical table
Type 6: Combination of Types 1, 2, and 3
Hybrid: Combination of types

*/


IF OBJECT_ID('dbo.DimCustomer_Type3', 'U') IS NOT NULL
    DROP TABLE dbo.DimCustomer_Type3;

CREATE TABLE dbo.DimCustomer_Type3
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CustomerName NVARCHAR(100),
    CurrentAddress NVARCHAR(200),
    PreviousAddress NVARCHAR(200) 
);


INSERT INTO dbo.DimCustomer_Type3 (CustomerID, CustomerName, CurrentAddress, PreviousAddress)
VALUES
(201, 'Charlie', '555 Old Street', NULL);


-- SCD Type 3 
UPDATE dbo.DimCustomer_Type3
SET PreviousAddress = CurrentAddress,
    CurrentAddress = '888 New Street'
WHERE CustomerID = 201;



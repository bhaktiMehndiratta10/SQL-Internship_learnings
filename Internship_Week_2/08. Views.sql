  /*
  " VIEW " =>

  A VIEW is a **virtual table** that is defined by a SELECT query.
  It does **not store data physically** (except for indexed views).
  When queried, it runs the underlying SELECT logic and returns results.

   USE CASES OF VIEWS:
  1. Simplify complex joins and queries
  2. Restrict access to specific columns/rows for security
  3. Reuse logic across multiple queries
  4. Provide a level of abstraction over schema

   TYPES OF VIEWS:

  1. **Basic View**:
     - A simple view created with SELECT
     - Virtual only (no physical data storage)
     - May or may not be updatable

  2. **Indexed View** (Materialized View in other DBMS):
     - Stores the view result physically with a **unique clustered index**
     - Requires strict SET options and SCHEMABINDING
     - Used to improve performance of heavy aggregations

  3. **Updatable View**:
     - Allows DML operations (INSERT, UPDATE, DELETE) on the view
     - Must meet specific rules:
         • Based on a single table
         • No GROUP BY, HAVING, DISTINCT, or aggregate functions
         • All NOT NULL columns must be included
*/


IF OBJECT_ID('vw_ProductsSimple', 'V') IS NOT NULL DROP VIEW vw_ProductsSimple;
IF OBJECT_ID('vw_IndexedProductRevenue', 'V') IS NOT NULL DROP VIEW vw_IndexedProductRevenue;
IF OBJECT_ID('vw_ProductSalesSummary', 'V') IS NOT NULL DROP VIEW vw_ProductSalesSummary;
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ProductRevenue')
    DROP INDEX IX_ProductRevenue ON vw_IndexedProductRevenue;
GO

IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
GO

IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
GO


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);
GO

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantitySold INT,
    SaleDate DATE
);
GO

 --Insert sample data
INSERT INTO Products VALUES
(1, 'Excavator', 'Heavy', 200000.00),
(2, 'Bulldozer', 'Heavy', 150000.00),
(3, 'Drill Machine', 'Tools', 10000.00);
GO

INSERT INTO Sales VALUES
(101, 1, 2, '2024-06-01'),
(102, 2, 1, '2024-06-15'),
(103, 1, 1, '2024-07-01'),
(104, 3, 5, '2024-07-03');
GO



  ========================================
  BASIC VIEW
  ========================================

CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.QuantitySold * p.Price) AS TotalRevenue
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;
GO

SELECT * FROM vw_ProductSalesSummary;
GO



  ========================================
   INDEXED VIEW (Materialized View)
  ========================================

  Required SET options
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
    QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

;   required semicolon before CREATE VIEW WITH SCHEMABINDING
CREATE VIEW vw_IndexedProductRevenue
WITH SCHEMABINDING
AS
SELECT 
    p.ProductID,
    COUNT_BIG(*) AS SaleCount,
    SUM(ISNULL(s.QuantitySold, 0)) AS TotalQuantity,
    SUM(ISNULL(CONVERT(DECIMAL(10,2), s.QuantitySold), 0) * ISNULL(p.Price, 0)) AS TotalRevenue
FROM dbo.Products p
JOIN dbo.Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID;
GO

CREATE UNIQUE CLUSTERED INDEX IX_ProductRevenue
ON vw_IndexedProductRevenue(ProductID);
GO

SELECT * FROM vw_IndexedProductRevenue;
GO



  ========================================
 UPDATABLE VIEW
  ========================================

CREATE VIEW vw_ProductsSimple
AS
SELECT ProductID, ProductName, Price
FROM Products;
GO

  Updating through the updatable view
UPDATE vw_ProductsSimple
SET Price = Price * 1.10
WHERE ProductName = 'Drill Machine';
GO

SELECT * FROM Products;
GO

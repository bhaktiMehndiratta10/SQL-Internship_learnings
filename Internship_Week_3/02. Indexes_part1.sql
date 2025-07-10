 /*
 INDEX
  An index is a database object that improves the speed of data retrieval (SELECT queries).
  Think of it like an index in a book — it helps you jump directly to the needed page.


  WHY USE INDEXES
  Without an index, SQL Server must scan the whole table (called a table scan).
  With an index, SQL Server can jump directly to the rows it needs (called an index seek).


  1. CREATE INDEX → for performance (not enforcing uniqueness).
  2. CREATE UNIQUE INDEX → prevents duplicate values in a column or column combination.
  3. DROP INDEX → used to delete an existing index (Syntax: DROP INDEX index_name ON table_name;)
*/


IF OBJECT_ID('vw_IndexedProductRevenue', 'V') IS NOT NULL
    DROP VIEW vw_IndexedProductRevenue;
GO


DROP TABLE IF EXISTS Products;
GO


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,              -- Creates clustered index by default
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);
GO


 -- normal index
CREATE INDEX IX_Category ON Products(Category);
GO


--  UNIQUE index
CREATE UNIQUE INDEX IX_UQ_ProductName ON Products(ProductName);
GO


 -- View all indexes
EXEC sp_helpindex 'Products';
GO


 -- Drop the indexes
DROP INDEX IX_Category ON Products;
GO

DROP INDEX IX_UQ_ProductName ON Products;
GO

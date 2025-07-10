  /*
  
  SUBQUERY:

  A subquery (also known as an inner query or nested query) is a query 
  embedded inside another query (called the outer query). The subquery 
  returns data used by the outer query to further process results.


  Can appear in:
     1. SELECT clause         -> Scalar subquery (returns single value)
     2. FROM clause           -> Derived table (also called inline view)
     3. WHERE/HAVING clause   -> Used to filter rows (e.g., IN, EXISTS)


  Types of Subqueries:
  1. Scalar Subquery: Returns a single value (1 row, 1 column).
  2. Multi-row Subquery: Returns multiple rows (used with IN, ANY, ALL).
  3. Correlated Subquery: Uses columns from the outer query; runs for each row.
  4. Nested Subquery: A subquery inside another subquery.


  Use Cases:
  - Filtering rows based on results of another query
  - Creating calculated columns
  - Comparing a row’s value to a dataset
  - Building inline views for complex reports


  Rules:
  - A subquery must be enclosed in parentheses ()
  - Scalar subqueries must return only 1 value; else error
  - Correlated subqueries can slow down performance if not indexed
*/


IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;
GO


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);
GO


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);
GO


INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 800),
(2, 'Smartphone', 'Electronics', 600),
(3, 'Desk Chair', 'Furniture', 150),
(4, 'Pen', 'Stationery', 2),
(5, 'Notebook', 'Stationery', 5);
GO


INSERT INTO Sales VALUES
(1, 1, 5, '2024-01-10'),
(2, 2, 10, '2024-01-15'),
(3, 3, 3, '2024-01-20'),
(4, 4, 100, '2024-01-25'),
(5, 5, 50, '2024-01-30');
GO



--  1. Scalar Subquery (returns a single value)
--  Find each product and the price of the most expensive product in its category.
SELECT 
    ProductName,
    Category,
    Price,
     -- Scalar subquery in SELECT clause
    (SELECT MAX(Price) FROM Products p2 WHERE p2.Category = p.Category) AS MaxCategoryPrice
FROM Products p;



--  2. Subquery in WHERE Clause (IN)
--  Find all products that have been sold (exist in Sales)
SELECT ProductName, Category, Price
FROM Products
WHERE ProductID IN (
    SELECT DISTINCT ProductID FROM Sales
);



--  3. Subquery in WHERE Clause (NOT IN)
--  Find all products that have NOT been sold
SELECT ProductName, Category, Price
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM Sales
);



 -- 4. Subquery in WHERE Clause with comparison (=, >, <)
 -- Find products priced higher than the average price of all products
SELECT ProductName, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price) FROM Products
);



--  5. Subquery in FROM Clause (Derived Table)
--  Find total quantity sold per product and join with product info
SELECT p.ProductName, p.Category, SalesSummary.TotalQuantity
FROM 
    (SELECT ProductID, SUM(Quantity) AS TotalQuantity FROM Sales GROUP BY ProductID) AS SalesSummary
JOIN Products p ON p.ProductID = SalesSummary.ProductID;




--  6. EXISTS Subquery
--  Find products that have at least one sale
SELECT ProductName, Category, Price
FROM Products p
WHERE EXISTS (
    SELECT 1 FROM Sales s WHERE s.ProductID = p.ProductID
);



 -- 7. NOT EXISTS Subquery
 -- Find products with no sales
SELECT ProductName, Category, Price
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Sales s WHERE s.ProductID = p.ProductID
);

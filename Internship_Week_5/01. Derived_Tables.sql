  /*DERIVED TABLES :
  A derived table is a *subquery* used in the FROM clause of a SQL statement.
  It's like a temporary inline view that exists only during query execution.



  SYNTAX :

  SELECT columns
  FROM (
      SELECT ...
  ) AS DerivedTableAlias
  WHERE ...



  USE CASES :
  Simplifying nested aggregations.
  Filtering/grouping results before applying further operations.
  Avoiding multiple subqueries or CTEs in moderate complexity scenarios.
*/


IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
GO

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    QuantitySold INT,
    SaleDate DATE
);


INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'),
(2, 'Headphones', 'Electronics'),
(3, 'Coffee Maker', 'Home Appliance'),
(4, 'Desk Chair', 'Furniture');


INSERT INTO Sales VALUES 
(101, 1, 5, '2024-01-10'),
(102, 1, 2, '2024-01-12'),
(103, 2, 10, '2024-02-01'),
(104, 3, 1, '2024-02-15'),
(105, 2, 4, '2024-02-18'),
(106, 4, 6, '2024-03-01'),
(107, 1, 3, '2024-03-10'),
(108, 3, 2, '2024-04-05');
GO


 --Using Derived Table to calculate Total Sales per Product
 --Goal: Show ProductName, Category, and Total Quantity Sold for each product


SELECT 
    p.ProductName,
    p.Category,
    dt.TotalSold
FROM Products p
INNER JOIN (
      --This is the derived table: aggregates QuantitySold for each ProductID
    SELECT 
        ProductID,
        SUM(QuantitySold) AS TotalSold
    FROM Sales
    GROUP BY ProductID
) AS dt
ON p.ProductID = dt.ProductID;

  --Explanation:
  --The derived table "dt" returns ProductID and total quantity sold for each product.
  --Then join this derived table with the Products table to get full product details.



--Goal: Show top-selling product in each category (based on total quantity sold)
SELECT 
    Category,
    ProductName,
    TotalSold
FROM (
    SELECT 
        p.Category,
        p.ProductName,
        SUM(s.QuantitySold) AS TotalSold,
        RANK() OVER (PARTITION BY p.Category ORDER BY SUM(s.QuantitySold) DESC) AS rk
    FROM Products p
    INNER JOIN Sales s ON p.ProductID = s.ProductID
    GROUP BY p.Category, p.ProductName
) AS RankedSales
WHERE rk = 1;

  --Explanation:
  --The inner derived table uses RANK() to rank products within each category by their total sales.
  --The outer query filters only the top-ranked (i.e., top-selling) product per category.
  --This pattern is very common for leaderboard-style logic or category-wise bestsellers.


  


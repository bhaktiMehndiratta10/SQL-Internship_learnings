/*
    Grouping is done using the GROUP BY clause. It allows you to group rows that have the same values in specified columns into summary rows, like:
      - Total sales per region
      - Count of employees per department
      - Average score per student

  CORE CONCEPTS:
    GROUP BY is used with aggregate functions like COUNT(), SUM(), AVG(), MAX(), MIN().
    GROUP BY must come *after* the WHERE clause and *before* ORDER BY.
    Can filter aggregated/grouped results using the HAVING clause (not WHERE).
    ORDER BY can be used to sort grouped results.

    Syntax:
      SELECT column1, AGG_FUNC(column2)
      FROM table
      WHERE condition
      GROUP BY column1
      HAVING condition_on_aggregate
      ORDER BY column1;
*/


IF OBJECT_ID('dbo.SalesData', 'U') IS NOT NULL
    DROP TABLE dbo.SalesData;


CREATE TABLE SalesData (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Region VARCHAR(50),
    Category VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO SalesData (Region, Category, Product, Quantity, UnitPrice, SaleDate)
VALUES 
('North', 'Electronics', 'Mobile', 10, 15000.00, '2025-06-10'),
('South', 'Electronics', 'Laptop', 5, 55000.00, '2025-06-11'),
('North', 'Home Appliance', 'Microwave', 7, 8000.00, '2025-06-12'),
('East', 'Electronics', 'Tablet', 4, 12000.00, '2025-06-12'),
('South', 'Home Appliance', 'Washing Machine', 3, 25000.00, '2025-06-13'),
('North', 'Electronics', 'Mobile', 6, 15000.00, '2025-06-13'),
('East', 'Home Appliance', 'Refrigerator', 2, 30000.00, '2025-06-14'),
('North', 'Electronics', 'Laptop', 4, 55000.00, '2025-06-15');



/*
GROUPING OPERATION
  Explanation:
    - GROUP BY Region and Category
    - Calculate Total Revenue = Quantity * UnitPrice using SUM()
    - Count number of sales entries per group
    - Only include those with more than 1 transaction (using HAVING)
    - Sort the result in descending order of revenue
	*/

SELECT 
    Region,
    Category,
    COUNT(*) AS NumberOfSales,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM SalesData
GROUP BY Region, Category
HAVING COUNT(*) > 1
ORDER BY TotalRevenue DESC;


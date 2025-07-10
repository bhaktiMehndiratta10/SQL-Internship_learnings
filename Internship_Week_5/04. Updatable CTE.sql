/*

** UPDATABLE CTE

    When the CTE directly references an updateable base table 
    (and not an aggregate, join, or computed column), 
    you can perform UPDATE/DELETE on that CTE, which actually updates the underlying table.

    WHY USE AN UPDATABLE CTE?
    - Improves readability of complex update logic
    - Helps avoid repeating subqueries
    - Makes multi-step updates easier to understand and maintain

    SYNTAX:
    WITH cte_name AS (
        SELECT ...
        FROM BaseTable
        WHERE conditions
    )
    UPDATE cte_name
    SET column = new_value
    WHERE conditions;

*/



IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
GO

CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Region NVARCHAR(50),
    SaleAmount DECIMAL(10,2)
);
GO


INSERT INTO Sales (CustomerName, Region, SaleAmount)
VALUES
('Alice', 'North', 500.00),
('Bob', 'South', 1500.00),
('Charlie', 'North', 2500.00),
('David', 'East', 800.00),
('Eve', 'North', 1200.00),
('Frank', 'South', 600.00);
GO


SELECT * FROM Sales;
GO

/*
    Business Rule:
    For all sales in the 'North' region where SaleAmount < 1000,
    increase SaleAmount by 10% (we want to boost small sales in North).
*/


WITH BoostSmallNorthSales AS (
    SELECT *
    FROM Sales
    WHERE Region = 'North' AND SaleAmount < 1000
)
UPDATE BoostSmallNorthSales
SET SaleAmount = SaleAmount * 1.10;   -- Increase by 10%
GO


SELECT * FROM Sales;
GO



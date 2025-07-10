/*

GROUPING SETS allow you to specify multiple groupings in a single GROUP BY clause.
It’s like running multiple GROUP BY queries and UNION-ing the results — but done efficiently by SQL Server.


SYNTAX:
    GROUP BY GROUPING SETS (
        (col1, col2),
        (col1),
        (col2),
        ()
    )

    empty parentheses () = "grand total".
*/



IF OBJECT_ID('tempdb..#Sales') IS NOT NULL DROP TABLE #Sales;

CREATE TABLE #Sales (
    Region NVARCHAR(50),
    Product NVARCHAR(50),
    SalesYear INT,
    Amount DECIMAL(10,2)
);


INSERT INTO #Sales VALUES
('North', 'Laptop', 2023, 1000),
('North', 'Tablet', 2023, 1500),
('South', 'Laptop', 2023, 1200),
('South', 'Tablet', 2023, 800),
('North', 'Laptop', 2024, 1100),
('South', 'Laptop', 2024, 1300),
('North', 'Tablet', 2024, 1600),
('South', 'Tablet', 2024, 900);



SELECT
    Region,
    Product,
    SalesYear,
    SUM(Amount) AS TotalSales
FROM
    #Sales
GROUP BY GROUPING SETS (
    (Region, Product, SalesYear),  -- detailed
    (Region, SalesYear),           -- summary by Region & Year
    (Product, SalesYear),          -- summary by Product & Year
    (Region),                      -- total by Region
    ()                             -- grand total
)
ORDER BY
    Region, Product, SalesYear;

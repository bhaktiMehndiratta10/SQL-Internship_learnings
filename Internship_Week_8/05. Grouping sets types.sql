/*

 3 main types

(1). Explicit GROUPING SETS:

explicitly list each grouping combination you care about.
Most flexible: you choose *exactly* which subtotals appear.

Example:
GROUP BY GROUPING SETS (
(Region, Product),  -- detailed totals
(Region),           -- subtotal by Region
()                  -- grand total
 )



(2️) CUBE
SQL Server auto-generates *all possible* combinations of the columns you list.
For columns A and B, CUBE makes:
(A, B), (A), (B), ()



(3️) ROLLUP
Creates a hierarchy: detailed → subtotals → grand total.
Order matters: it aggregates from left to right.

Example:
 GROUP BY ROLLUP (Region, Product)
 Produces:
(Region, Product), (Region), ()

 good time-based or hierarchical reports (Year → Quarter → Month).

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
('North', 'Tablet', 2024, 1600),
('South', 'Laptop', 2024, 1300),
('South', 'Tablet', 2024, 900);


-- 1. Explicit GROUPING SETS
SELECT
    Region,
    Product,
    SUM(Amount) AS TotalSales,
    GROUPING(Region) AS IsRegionAggregated,  -- 1 = aggregated, 0 = detailed
    GROUPING(Product) AS IsProductAggregated
FROM
    #Sales
GROUP BY GROUPING SETS (
    (Region, Product),  -- detailed totals
    (Region),           -- subtotal by Region
    ()                  -- grand total
)
ORDER BY
    Region, Product;

	
-- 2️. CUBE
SELECT
    Region,
    Product,
    SUM(Amount) AS TotalSales
FROM
    #Sales
GROUP BY CUBE (Region, Product)
ORDER BY
    Region, Product;


-- 3️. ROLLUP
SELECT
    Region,
    Product,
    SUM(Amount) AS TotalSales
FROM
    #Sales
GROUP BY ROLLUP (Region, Product)
ORDER BY
    Region, Product;


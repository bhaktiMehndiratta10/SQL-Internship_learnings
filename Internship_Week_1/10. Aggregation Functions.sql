/*
  Aggregation functions perform calculations on multiple rows and return a single summarizing value.  
  Common T-SQL aggregation functions:  
    COUNT():    counts rows or non-NULL values  
    SUM():      totals numeric values  
    AVG():      computes average of numeric values  
    MIN()/MAX(): finds the smallest/largest value  
    STDEV()/VAR():   computes statistical standard deviation/variance  
   
  Grouping & Filtering:  
    GROUP BY:   groups rows sharing a common value and applies aggregates per group  
    HAVING:     filters groups after aggregation (WHERE filters before aggregation)  
   
  Advanced Grouping (intermediate):  
    ROLLUP:         cumulative subtotals + grand total  
    CUBE:           all combinations of subtotals + grand total  
    GROUPING SETS:  define arbitrary groupings, more flexible  
*/  



IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL
    DROP TABLE dbo.Sales;
GO



CREATE TABLE dbo.Sales (
    OrderID         INT           IDENTITY(1,1) PRIMARY KEY,
    SalesPersonID   INT           NOT NULL,
    Region          VARCHAR(20)   NOT NULL,
    OrderDate       DATE          NOT NULL,
    Amount          DECIMAL(10,2) NOT NULL
);
GO



INSERT INTO dbo.Sales (SalesPersonID, Region, OrderDate, Amount)
VALUES
    (101, 'North', '2025-01-05',  250.00),
    (102, 'South', '2025-01-08',  450.50),
    (101, 'North', '2025-01-10',  125.75),
    (103, 'East',  '2025-02-02',  980.00),
    (102, 'South', '2025-02-05',  310.20),
    (104, 'West',  '2025-02-07',  780.00),
    (101, 'North', '2025-02-10',  650.00),
    (103, 'East',  '2025-02-12',  110.00),
    (104, 'West',  '2025-03-01',  430.30),
    (102, 'South', '2025-03-03',  220.00);
GO


-- Basic aggregation
SELECT
    COUNT(*)      AS TotalOrders,          -- total number of orders
    SUM(Amount)   AS TotalRevenue,         -- total sales amount
    AVG(Amount)   AS AvgOrderValue,        -- average order amount
    MIN(Amount)   AS SmallestOrder,        -- smallest single order
    MAX(Amount)   AS LargestOrder,         -- largest single order
    STDEV(Amount) AS StdDevOrderValue      -- standard deviation of orders
FROM dbo.Sales;
GO


-- Grouped aggregation: by Region
SELECT
    Region,
    COUNT(*)    AS OrdersCount,
    SUM(Amount) AS RegionRevenue,
    AVG(Amount) AS RegionAvgOrder
FROM dbo.Sales
GROUP BY Region
ORDER BY Region;
GO


-- Grouped aggregation with HAVING (filters groups after aggregation)
SELECT
    Region,
    SUM(Amount) AS RegionRevenue
FROM dbo.Sales
GROUP BY Region
HAVING SUM(Amount) > 1000     -- only show regions with > 1000 total revenue
ORDER BY RegionRevenue DESC;
GO


-- Advanced grouping: ROLLUP (subtotals + grand total)
SELECT
    Region,
    SalesPersonID,
    SUM(Amount) AS Revenue
FROM dbo.Sales
GROUP BY ROLLUP (Region, SalesPersonID)
ORDER BY
    GROUPING(Region),          -- ensures NULL (totals) sort last
    Region,
    SalesPersonID;
GO


-- Advanced grouping: CUBE (all combinations)
SELECT
    Region,
    SalesPersonID,
    SUM(Amount) AS Revenue
FROM dbo.Sales
GROUP BY CUBE (Region, SalesPersonID)
ORDER BY
    GROUPING(Region),
    GROUPING(SalesPersonID),
    Region,
    SalesPersonID;
GO


-- Advanced grouping: GROUPING SETS (explicit combinations)
SELECT
    Region,
    SalesPersonID,
    SUM(Amount) AS Revenue
FROM dbo.Sales
GROUP BY GROUPING SETS (
    (Region, SalesPersonID),      -- each person in each region
    (Region),                     -- region totals
    ()                            -- grand total
)
ORDER BY
    Region,
    SalesPersonID;
GO

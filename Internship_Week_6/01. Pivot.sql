/*

PIVOT is used to transform rows into columns, which makes data easier to read and analyze when need to see aggregate values spread across multiple columns instead of multiple rows.

- PIVOT works with an aggregate function (e.g., SUM, COUNT, AVG).
- You specify which column's unique values become new columns.
- Often used in reporting when you want a cross-tabular view.

 SYNTAX-

    SELECT <static columns>, [pivoted columns...]
    FROM
    (
        SELECT <source columns>
        FROM <table>
    ) AS source
    PIVOT
    (
        <aggregate_function>(<value_column>)
        FOR <column_with_values_to_pivot> IN ([new_column1], [new_column2], ...)
    ) AS pivot_table;

  
 Use case:
 Suppose there is data: each row shows sales amount by month for each salesperson.
 need each salesperson’s total sales per month displayed as separate columns.
*/


IF OBJECT_ID('SalesData', 'U') IS NOT NULL DROP TABLE SalesData;

CREATE TABLE SalesData (
    SalesPerson NVARCHAR(50),
    MonthName NVARCHAR(20),
    SalesAmount INT
);

-- Insert demo data
INSERT INTO SalesData VALUES 
('Alice', 'January', 1000),
('Alice', 'February', 1200),
('Alice', 'March', 900),
('Bob', 'January', 1500),
('Bob', 'February', 800),
('Bob', 'March', 950),
('Charlie', 'January', 700),
('Charlie', 'February', 1100),
('Charlie', 'March', 1200);


 -- Goal: See each salesperson's total sales in Jan, Feb, and Mar as separate columns.
SELECT SalesPerson, [January] AS JanSales, [February] AS FebSales, [March] AS MarSales
FROM
(
    SELECT SalesPerson, MonthName, SalesAmount
    FROM SalesData
) AS SourceTable
PIVOT
(
    SUM(SalesAmount)                  -- Aggregate function to apply
    FOR MonthName IN ([January], [February], [March])  -- Unique MonthName values become columns
) AS PivotTable
ORDER BY SalesPerson;

/*
 UNPIVOT is used to transform columns into rows.
 It’s especially useful when you have a denormalized table (e.g., sales figures spread across Q1, Q2, Q3, Q4 columns and need to analyze them as rows (quarter, amount).

 
 USE CASE:
 1. Reporting and analytics tools usually prefer normalized data where repeated attributes (like quarterly sales) are rows, not separate columns.
 2. Makes aggregation, filtering, and joining simpler.

 
 SYNTAX:

    SELECT <columns>, <unpivoted_column>, <unpivoted_value>
    FROM <table>
    UNPIVOT (<unpivoted_value> FOR <unpivoted_column> IN ([col1], [col2], ...)) AS alias;
	
 
 # UNPIVOT can't unpivot multiple sets of columns at once directly. for complex scenarios you might need CROSS APPLY or multiple steps.

*/


IF OBJECT_ID('SalesByQuarter', 'U') IS NOT NULL
    DROP TABLE SalesByQuarter;

CREATE TABLE SalesByQuarter (
    SalesPerson NVARCHAR(50),
    Region NVARCHAR(50),
    Q1 INT,
    Q2 INT,
    Q3 INT,
    Q4 INT
);


INSERT INTO SalesByQuarter (SalesPerson, Region, Q1, Q2, Q3, Q4)
VALUES
('Alice', 'North', 10000, 12000, 11000, 9000),
('Bob', 'South', 8000, 9500, 10200, 9800),
('Charlie', 'East', 7000, 8500, 9000, 8700);


SELECT 
    SalesPerson,
    Region,
    Quarter,           -- This column will hold 'Q1', 'Q2', etc.
    SalesAmount        -- This column will hold the corresponding amount
FROM 
    SalesByQuarter
UNPIVOT
(
    SalesAmount FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotedResult;

/*

1. 'Quarter' becomes the name of the new column holding previous column names (Q1, Q2, etc.)
2. 'SalesAmount' holds the values from these columns.
3.  Now, instead of 1 row per salesperson with multiple sales columns, we have multiple rows per salesperson: one per quarter.
   
*/



/*
  DYNAMIC SQL INSIDE A STORED PROCEDURE
 

  Dynamic SQL refers to SQL statements that are constructed and executed at runtime,
  rather than being hardcoded in the stored procedure.
  This is useful when table names, column names, or conditions are not known in advance.

  Use Cases:
  1. Search/filter based on a column name passed as a parameter
  2. Conditionally build different SELECT/UPDATE/DELETE statements
  3. Execute queries against dynamic table names
  4. Build flexible reporting or admin tools

  Use `sp_executesql` over `EXEC()` because it supports parameterization and is safer.
  */


DROP PROCEDURE IF EXISTS GetOrdersByDynamicFilter;
GO

  --Stored Procedure with Dynamic SQL
CREATE PROCEDURE GetOrdersByDynamicFilter
    @ColumnName NVARCHAR(100),     --Column to filter by (e.g., 'OrderDate' or 'TotalAmount')
    @FilterValue NVARCHAR(100)     --Value to filter on (must be passed as string)
AS
BEGIN
      --Declaring a string to hold the SQL command
    DECLARE @SQL NVARCHAR(MAX);

      --Building the SQL query string
    SET @SQL = '
        SELECT OrderID, CustomerID, OrderDate, TotalAmount
        FROM Orders
        WHERE ' + QUOTENAME(@ColumnName) + ' = @Value';

      --Executing with sp_executesql (supports parameters)
    EXEC sp_executesql 
        @SQL,
        N'@Value NVARCHAR(100)',       -- Declare parameter type inside sp_executesql
        @Value = @FilterValue;         -- Assign actual value
END;
GO



 -- Filter by TotalAmount = 3000.00
EXEC GetOrdersByDynamicFilter 
    @ColumnName = 'TotalAmount',
    @FilterValue = '3000.00';

 -- Filter by OrderDate = '2024-06-01'
EXEC GetOrdersByDynamicFilter 
    @ColumnName = 'OrderDate',
    @FilterValue = '2024-06-01';

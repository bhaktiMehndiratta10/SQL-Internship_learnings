/*

Dynamic SQL = SQL code that is generated and executed at runtime as a string.
Useful when table names, column names, or conditions are only known at runtime.

Types:
1. Immediate execution: using EXEC('string')
2. Parameterized execution: using sp_executesql

*/


DECLARE @TableName NVARCHAR(128) = 'sys.objects';
DECLARE @ColumnName NVARCHAR(128) = 'name';


DECLARE @DynamicSQL NVARCHAR(MAX);

SET @DynamicSQL = 'SELECT TOP 5 ' + QUOTENAME(@ColumnName) +
                  ' FROM ' + @TableName +
                  ' WHERE type = ''U''';  


PRINT @DynamicSQL;
EXEC(@DynamicSQL);



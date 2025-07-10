/*
  View Limitations 


  Views are saved SELECT queries — good for abstraction, reusability, and access control.
  But there are guardrails. These are the main limitations you’ll run into:

  1. Views are usually read-only:
     - If they include JOINs, GROUP BY, DISTINCT, aggregate functions (SUM, AVG, etc.), or UNIONs,
       SQL Server won't let you insert, update, or delete through them.

  2. ORDER BY isn’t allowed in views by default:
     - You can only use ORDER BY if you also add TOP (e.g., TOP 100 PERCENT).
     - Even then, it doesn't guarantee sort order when querying the view — ordering only happens at SELECT time.

  3. SCHEMABINDING makes views stricter:
     - All table and column references must be fully qualified (like dbo.TableName).
     - SELECT * is not allowed — you have to explicitly name every column.
     - Once bound, you can’t DROP or ALTER the underlying tables without first dropping the view.

  4. No parameters allowed:
     - Views aren’t like stored procedures — you can’t pass values to filter inside the view.
     - If you need dynamic input, either wrap it with a stored proc or use inline SQL.

  5. No temporary tables or table variables:
     - You can't use things like #TempTable or @TableVar inside a view — they’re runtime-specific.

  6. Column name conflicts:
     - If multiple tables in a view have the same column name, you must alias them.
       SQL Server won’t guess — it’ll throw "ambiguous column" errors.

  7. Indexing is limited:
     - Only certain views can be indexed (must be SCHEMABINDING, no outer joins, etc.).
     - Most views are just virtual — they don’t store any data or improve performance by default.
*/

IF OBJECT_ID('View_DepartmentSalarySummary', 'V') IS NOT NULL DROP VIEW View_DepartmentSalarySummary;
IF OBJECT_ID('View_OrderedEmployeesBySalary', 'V') IS NOT NULL DROP VIEW View_OrderedEmployeesBySalary;
IF OBJECT_ID('View_SchemaBoundEmployeeDetails', 'V') IS NOT NULL DROP VIEW View_SchemaBoundEmployeeDetails;
IF OBJECT_ID('View_EmployeeDepartmentDetails', 'V') IS NOT NULL DROP VIEW View_EmployeeDepartmentDetails;
GO


IF OBJECT_ID('EmployeeDetails', 'U') IS NOT NULL DROP TABLE EmployeeDetails;
IF OBJECT_ID('DepartmentDetails', 'U') IS NOT NULL DROP TABLE DepartmentDetails;
GO


CREATE TABLE DepartmentDetails (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE EmployeeDetails (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    EmployeeSalary DECIMAL(10, 2),
    DepartmentID INT FOREIGN KEY REFERENCES DepartmentDetails(DepartmentID)
);
GO


INSERT INTO DepartmentDetails (DepartmentName) VALUES 
('Human Resources'), 
('Information Technology'), 
('Finance');


INSERT INTO EmployeeDetails (EmployeeID, EmployeeName, EmployeeSalary, DepartmentID) VALUES 
(101, 'Alice', 55000, 1),
(102, 'Bob', 72000, 2),
(103, 'Charlie', 80000, 2),
(104, 'David', 65000, 3);
GO


 --View with GROUP BY and aggregates = read-only
CREATE VIEW View_DepartmentSalarySummary AS
SELECT 
    D.DepartmentName,
    COUNT(E.EmployeeID) AS TotalEmployees,
    AVG(E.EmployeeSalary) AS AverageSalary
FROM 
    DepartmentDetails D
    JOIN EmployeeDetails E ON D.DepartmentID = E.DepartmentID
GROUP BY 
    D.DepartmentName;
GO



 --ORDER BY in a view requires TOP — just to bypass the SQL rule
 --Still won't guarantee actual sort during SELECT
CREATE VIEW View_OrderedEmployeesBySalary AS
SELECT TOP 100 PERCENT *
FROM EmployeeDetails
ORDER BY EmployeeSalary DESC;
GO



 --View with SCHEMABINDING — stricter rules: needs fully qualified table names, no SELECT *, and locks table structure
CREATE VIEW View_SchemaBoundEmployeeDetails
WITH SCHEMABINDING
AS
SELECT 
    E.EmployeeID,
    E.EmployeeName,
    E.EmployeeSalary,
    E.DepartmentID
FROM dbo.EmployeeDetails AS E;
GO


 --JOIN view → can’t be updated directly
 --also uses column aliasing to avoid name conflicts
CREATE VIEW View_EmployeeDepartmentDetails AS
SELECT 
    E.EmployeeID,
    E.DepartmentID AS EmployeeDepartmentID,
    D.DepartmentID AS DepartmentReferenceID,
    D.DepartmentName
FROM EmployeeDetails E
JOIN DepartmentDetails D ON E.DepartmentID = D.DepartmentID;
GO

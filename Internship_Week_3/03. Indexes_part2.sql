  /*
  ====================================
  Clustered vs Non-Clustered Indexes
  ====================================

  1. CLUSTERED INDEX:

  Sorts and stores the actual data rows in the table.
  Only ONE clustered index allowed per table.
  It's like sorting the entire table physically by that column.
  PRIMARY KEY automatically creates a clustered index (unless overridden).

  SYNTAX:
  CREATE CLUSTERED INDEX index_name
  ON table_name (column_name);



  2. NON-CLUSTERED INDEX:

  Creates a separate structure with pointers to the actual table rows.
  You can have multiple non-clustered indexes on a table.
  Think of it like a library catalog: it points you to the row location.

  SYNTAX:
  CREATE NONCLUSTERED INDEX index_name
  ON table_name (column_name);



  WHEN TO USE WHAT:
  Use CLUSTERED index on columns frequently used for sorting, joining, or filtering ranges (like IDs, Dates).
  Use NON-CLUSTERED index for search-heavy columns like names, cities, categories, etc.
*/

IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
GO


 -- table with an explicit Clustered Index
CREATE TABLE Employees (
    EmpID INT,
    FullName VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);
GO


 -- CLUSTERED INDEX on EmpID
 -- This will sort the table physically by EmpID
CREATE CLUSTERED INDEX IX_Employees_EmpID
ON Employees (EmpID);
GO


 --  NON-CLUSTERED INDEX on Department
 -- This index helps when filtering by Department
CREATE NONCLUSTERED INDEX IX_Employees_Department
ON Employees (Department);
GO

INSERT INTO Employees (EmpID, FullName, Department, Salary)
VALUES 
(101, 'Alice Smith', 'IT', 70000),
(102, 'Bob Johnson', 'HR', 60000),
(103, 'Charlie Brown', 'Finance', 65000),
(104, 'David Lee', 'IT', 72000),
(105, 'Eva Turner', 'HR', 58000);
GO

SELECT * FROM Employees
WHERE Department = 'HR';
GO


 -- View all indexes on the table
EXEC sp_helpindex 'Employees';
GO

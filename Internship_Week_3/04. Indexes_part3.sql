 /*
 INDEXES in SQL are used to speed up retrieval of rows from a table.
  1. UNIQUE INDEX:
      Ensures all values in the indexed column(s) are unique.
      SQL Server will prevent duplicate values from being inserted.
      Can be applied on one or multiple columns.
      Useful for columns like Email, Username, PAN Number, etc.

  2.  NON-UNIQUE INDEX:
      Allows duplicate values in the column(s).
      Still improves SELECT query performance.
      Useful for columns like DepartmentID, City, etc. where duplicates are common.
*/


IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
GO


CREATE TABLE Employees (
    EmpID INT IDENTITY PRIMARY KEY,      --  Primary Key (creates a unique clustered index)
    Name VARCHAR(100),
    Email VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);
GO

  -- UNIQUE INDEX on Email column
 -- Ensures no two employees can have the same email address
CREATE UNIQUE INDEX IX_Employees_Email
ON Employees(Email);
GO


 -- NON-UNIQUE INDEX on Department column
 -- Useful if we frequently filter or GROUP BY Department
CREATE NONCLUSTERED INDEX IX_Employees_Department
ON Employees(Department);
GO


INSERT INTO Employees (Name, Email, Department, Salary)
VALUES 
    ('Alice', 'alice@example.com', 'HR', 50000),
    ('Bob',   'bob@example.com',   'IT', 60000),
    ('Charlie', 'charlie@example.com', 'IT', 65000),
    ('Daisy', 'daisy@example.com', 'HR', 52000);
GO


SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;
GO


SELECT * FROM Employees
WHERE Email = 'bob@example.com';
GO

EXEC sp_helpindex 'Employees';
GO

/*
  Common Table Expressions (CTEs) in SQL Server

  A Common Table Expression (CTE) is a temporary named result set 
  defined within the execution scope of a single SQL statement.

  Purpose:
  1. Improve query readability by breaking complex queries into simpler parts.
  2. Facilitate recursion.
  3. Can be referenced multiple times within the same query.
  4. Help organize complex joins, subqueries, and aggregations.

  Syntax:

  WITH cte_name (optional_column_list) AS (
      -- CTE query definition
      SELECT ...
  )
  SELECT ...
  FROM cte_name
  WHERE ...

  Key points:
  - CTEs exist only for the duration of the query.
  - They cannot be indexed.
  - They can be recursive or non-recursive.
  - Use when you want to avoid repeated subqueries or simplify queries.

  Use case example:
  Suppose you want to find employees who earn more than the average salary.
  Instead of repeating the average salary calculation, use a CTE.
*/

-- ==================================================
-- Example 1: Non-Recursive CTE
-- Find employees with salary above average
-- ==================================================

IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Department NVARCHAR(50),
    Salary INT
);
GO

INSERT INTO Employees (EmployeeID, EmployeeName, Department, Salary) VALUES
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'IT', 70000),
(3, 'Charlie', 'Finance', 60000),
(4, 'David', 'IT', 80000),
(5, 'Eve', 'HR', 55000);
GO

WITH AvgSalaryCTE AS (
    SELECT AVG(Salary) AS AvgSalary
    FROM Employees
)
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    e.Department,
    e.Salary
FROM Employees e
CROSS JOIN AvgSalaryCTE a
WHERE e.Salary > a.AvgSalary;
GO

-- ==================================================
-- Example 2: Recursive CTE
-- Find all subordinates under Manager1 (ID = 2)
-- ==================================================

IF OBJECT_ID('EmployeeHierarchy', 'U') IS NOT NULL DROP TABLE EmployeeHierarchy;
GO

CREATE TABLE EmployeeHierarchy (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    ManagerID INT NULL  -- NULL for top-level manager
);
GO

INSERT INTO EmployeeHierarchy (EmployeeID, EmployeeName, ManagerID) VALUES
(1, 'CEO', NULL),
(2, 'Manager1', 1),
(3, 'Manager2', 1),
(4, 'Employee1', 2),
(5, 'Employee2', 2),
(6, 'Employee3', 3);
GO

WITH SubordinatesCTE AS (
    -- Anchor member: direct reports of Manager1 (ID = 2)
    SELECT EmployeeID, EmployeeName, ManagerID
    FROM EmployeeHierarchy
    WHERE ManagerID = 2

    UNION ALL

    -- Recursive member: find indirect reports
    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID
    FROM EmployeeHierarchy e
    INNER JOIN SubordinatesCTE s ON e.ManagerID = s.EmployeeID
)
SELECT *
FROM SubordinatesCTE;
GO

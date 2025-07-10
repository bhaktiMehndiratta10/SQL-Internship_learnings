/*
  CTE (Common Table Expression)

  A Common Table Expression (CTE) is a temporary result set that we can reference 
  within a SELECT, INSERT, UPDATE, or DELETE statement. It is defined using the WITH keyword.

  Key Features:
  - Improves readability and organization of complex queries
  - Can be recursive (used to handle hierarchical data)
  - Exists only for the duration of the query

  Syntax:
  WITH cte_name (optional_column_list) AS (
      -- CTE Query
      SELECT ...
  )
  -- Main Query using cte_name
*/

-- ========================================
-- CTE for Employee Salary Analysis
-- ========================================

DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    Salary INT,
    ManagerID INT NULL
);
GO

INSERT INTO Employees VALUES
(1, 'Alice', 'HR', 50000, NULL),
(2, 'Bob', 'Finance', 60000, 1),
(3, 'Charlie', 'Finance', 70000, 1),
(4, 'David', 'IT', 80000, 2),
(5, 'Eva', 'IT', 90000, 2),
(6, 'Frank', 'HR', 55000, 1),
(7, 'Grace', 'Finance', 62000, 2),
(8, 'Henry', 'IT', 67000, 3);
GO

-- ========================================
-- Example 1: Average Salary per Department
-- ========================================

-- This CTE computes the average salary by department.
-- We then join it with the Employees table to find employees
-- who earn more than their department's average salary.

WITH DeptAvgSalary AS (
    SELECT Department, AVG(Salary) AS AvgSal
    FROM Employees
    GROUP BY Department
)
SELECT e.EmpName, e.Department, e.Salary, d.AvgSal
FROM Employees e
JOIN DeptAvgSalary d ON e.Department = d.Department
WHERE e.Salary > d.AvgSal;
GO

-- ========================================
-- Example 2: Recursive CTE - Managerial Hierarchy
-- ========================================

-- This recursive CTE displays the reporting hierarchy
-- starting from Alice (the top-level manager).

WITH ManagerCTE AS (
    -- Anchor member: top-level manager
    SELECT EmpID, EmpName, ManagerID, 0 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: employees reporting to those above
    SELECT e.EmpID, e.EmpName, e.ManagerID, m.Level + 1
    FROM Employees e
    INNER JOIN ManagerCTE m ON e.ManagerID = m.EmpID
)
SELECT *
FROM ManagerCTE
ORDER BY Level, EmpName;
GO

-- ========================================
-- Example 3: Updating Records using CTE
-- ========================================

-- Increase salary by 10% for employees earning
-- less than their department's average salary.

WITH DeptAvg AS (
    SELECT Department, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY Department
),
ToBeUpdated AS (
    SELECT e.EmpID, e.Salary, d.AvgSalary
    FROM Employees e
    JOIN DeptAvg d ON e.Department = d.Department
    WHERE e.Salary < d.AvgSalary
)
UPDATE e
SET e.Salary = e.Salary * 1.10  -- 10% increase
FROM Employees e
JOIN ToBeUpdated t ON e.EmpID = t.EmpID;
GO

-- ========================================
-- Example 4: CTE with ROW_NUMBER() for pagination
-- ========================================

-- Use case: Get top 3 highest-paid employees per department.

WITH RankedSalaries AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RN
    FROM Employees
)
SELECT EmpID, EmpName, Department, Salary
FROM RankedSalaries
WHERE RN <= 3;
GO

/*

 Recursive CTE references itself to process hierarchical data such as organizational charts, folder structures, BOM etc.
 helps traverse hierarchical relationships
 Useful for org charts, bill of materials, folder trees etc.
 Level column can show depth; HierarchyPath can show full path


- Starts with an anchor member (base case)
- Followed by recursive member (self-reference)
- Combined using UNION ALL

*/


IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
GO


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    ManagerID INT
);
GO


INSERT INTO Employees VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'Dave', 2),
(5, 'Eve', 3),
(6, 'Frank', 3);
GO


WITH EmployeeHierarchy AS (
    -- Anchor member: start with CEO
    SELECT
        EmployeeID,
        EmployeeName,
        ManagerID,
        CAST(EmployeeName AS NVARCHAR(MAX)) AS HierarchyPath,
        1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: find direct reports of current level
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        e.ManagerID,
        CAST(eh.HierarchyPath + ' -> ' + e.EmployeeName AS NVARCHAR(MAX)),
        eh.Level + 1 AS Level
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)


SELECT
    EmployeeID,
    EmployeeName,
    ManagerID,
    HierarchyPath, 
    Level          
FROM EmployeeHierarchy
ORDER BY HierarchyPath;
GO


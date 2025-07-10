 /*
 CORRELATED SUBQUERY

  A *correlated subquery* is a subquery that references a column from the outer query.
  Unlike a regular subquery (which runs independently), a correlated subquery is 
  executed **once for each row** processed by the outer query.
 it's "dependent" on the outer query to produce its result.


  Syntax :
  SELECT columns
  FROM OuterTable O
  WHERE column OPERATOR (
      SELECT column
      FROM InnerTable I
      WHERE I.related_column = O.related_column
  );


  Key Characteristics:
  1. References a column from the outer query inside the subquery.
  2. Evaluated row-by-row for each row returned by the outer query.
  3. Cannot be run independently — it depends on outer query’s context.
  4. Generally used for row-wise filtering or calculations.


   Use Cases:
  1. Filtering rows based on grouped/aggregated criteria per group
  2. Comparing each row to its group's average/min/max
  3. Identifying records that meet conditional logic against a related set
  4. Validations like "where EXISTS a child row meeting some condition"
*/

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO


CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(100)
);


CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10, 2),
    DeptID INT FOREIGN KEY REFERENCES Departments(DeptID)
);


INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales');


INSERT INTO Employees VALUES
(101, 'Alice', 70000, 1),
(102, 'Bob', 60000, 1),
(103, 'Charlie', 80000, 2),
(104, 'Diana', 90000, 2),
(105, 'Eve', 75000, 3),
(106, 'Frank', 50000, 3);




--  1. Correlated Subquery in WHERE Clause
--  Find employees whose salary is above the average salary of their department

SELECT EmpName, Salary, DeptID
FROM Employees E
WHERE Salary > (
      -- This subquery is CORRELATED because it depends on E.DeptID from the outer query
    SELECT AVG(Salary)
    FROM Employees
    WHERE DeptID = E.DeptID
);



 -- 2. Correlated Subquery in SELECT Clause
 -- Show each employee and the average salary of their department

SELECT 
    EmpName,
    Salary,
    DeptID,
      -- Correlated subquery returns avg salary for each row's department
    (SELECT AVG(Salary) 
     FROM Employees E2 
     WHERE E2.DeptID = E1.DeptID) AS AvgDeptSalary
FROM Employees E1;



 -- 3. Correlated Subquery using EXISTS
 -- Find departments that have at least one employee earning more than 80000

SELECT DeptName
FROM Departments D
WHERE EXISTS (
     -- Correlated subquery depends on D.DeptID from outer query
    SELECT 1
    FROM Employees E
    WHERE E.DeptID = D.DeptID AND E.Salary > 80000
);

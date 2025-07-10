/*
  A User-Defined Function (UDF) is a user-created routine that accepts parameters,
  performs actions (like calculations), and returns a result.
  UDFs help modularize and reuse logic across queries.

   Types of UDFs:
    1. Scalar-Valued Function (returns a single value)
    2. Table-Valued Function (returns a table)
*/


IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;

CREATE TABLE dbo.Employees (
    EmpID INT PRIMARY KEY IDENTITY(1,1),
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    Salary INT
);


INSERT INTO dbo.Employees (EmpName, Department, Salary)
VALUES 
('Alice', 'IT', 60000),
('Bob', 'HR', 45000),
('Charlie', 'Finance', 70000),
('Diana', 'IT', 80000),
('Eve', 'HR', 55000),
('Frank', 'Finance', 40000);




 --CREATE A SCALAR-VALUED FUNCTION
 --Calculates bonus as 10% of salary if salary > 50000, else 5%
 

IF OBJECT_ID('dbo.fn_CalculateBonus', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CalculateBonus;
GO

CREATE FUNCTION dbo.fn_CalculateBonus (
    @salary INT
)
RETURNS INT
AS
BEGIN
    DECLARE @bonus INT;

    IF @salary > 50000
        SET @bonus = @salary * 10 / 100;
    ELSE
        SET @bonus = @salary * 5 / 100;

    RETURN @bonus;
END;
GO



 --CREATE A TABLE-VALUED FUNCTION
 --Returns employees from a specific department (filtered)

IF OBJECT_ID('dbo.fn_GetEmployeesByDept', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fn_GetEmployeesByDept;
GO

CREATE FUNCTION dbo.fn_GetEmployeesByDept (
    @deptName VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT EmpID, EmpName, Salary
    FROM dbo.Employees
    WHERE Department = @deptName
);
GO


  -- Using Scalar Function in SELECT
SELECT 
    EmpName,
    Salary,
    dbo.fn_CalculateBonus(Salary) AS Bonus
FROM dbo.Employees;


   --Using Table-Valued Function in FROM clause
SELECT *
FROM dbo.fn_GetEmployeesByDept('IT');

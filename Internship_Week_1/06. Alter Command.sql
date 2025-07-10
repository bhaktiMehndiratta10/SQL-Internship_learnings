/*
  ALTER TABLE Command in SQL
  Used to modify the structure/schema of an existing table
  Common operations: ADD, DROP, ALTER COLUMN, ADD CONSTRAINT, etc.
  Cannot be rolled back once executed (DDL)
*/



IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
    DROP TABLE dbo.Employee;
GO

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY IDENTITY(1,1),           --Auto-incrementing ID
    FirstName VARCHAR(50) NOT NULL,              
    LastName VARCHAR(50),                        
    Age INT,                                    
    Salary DECIMAL(10, 2)                          --Precision: 10 digits, 2 decimal places
);
GO


  --Add a Department column with default value 'HR'
  --New INSERTs without department will get 'HR'
ALTER TABLE Employee
ADD Department VARCHAR(50) DEFAULT 'HR';
GO

  --Modify existing column
  --Increase the precision of Salary column to allow larger values
ALTER TABLE Employee
ALTER COLUMN Salary DECIMAL(12, 2);  --supports bigger salaries
GO


  --Constrainr ensures salary is always above 1000
ALTER TABLE Employee
ADD CONSTRAINT CHK_MinSalary CHECK (Salary >= 1000.00);


INSERT INTO Employee (FirstName, LastName, Age, Salary, Department)
VALUES 
    ('Alice', 'Williams', 30, 45000.00, 'IT'),
    ('Bob', 'Smith', 45, 60000.00, 'Finance');
GO


EXEC sp_rename 'Employee.FirstName', 'FName', 'COLUMN';
GO

ALTER TABLE Employee
DROP CONSTRAINT CHK_MinSalary;
GO

ALTER TABLE Employee
DROP COLUMN LastName;
GO

SELECT * FROM Employee;
GO

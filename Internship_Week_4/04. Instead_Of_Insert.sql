  /* 
  INSTEAD OF INSERT trigger
  It's a type of trigger that fires **in place of** the actual INSERT operation.
  This means the default insert action will NOT happen automatically.
  Instead, the logic inside the trigger defines what should be done.

  Use Cases:
  To enforce custom business rules before inserting data
  To redirect or log inserts into different tables
  To perform validations or complex logic during insert
  Often used with views (which can't have direct inserts sometimes)

  Syntax:
  CREATE TRIGGER trigger_name
  ON table_name
  INSTEAD OF INSERT
  AS
  BEGIN
        Custom logic goes here
  END
  */



DROP TABLE IF EXISTS EmployeeAudit;
DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    Salary INT CHECK (Salary > 0)   
);
GO


CREATE TABLE EmployeeAudit (
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    Salary INT,
    Reason NVARCHAR(255),
    AuditTime DATETIME DEFAULT GETDATE()
);
GO


  --Step 3: Create INSTEAD OF INSERT Trigger
  --Purpose: Prevent inserting employees with salary < 10000 and log those attempts into EmployeeAudit table instead.

CREATE TRIGGER trg_InsteadOfInsert_Employees
ON Employees
INSTEAD OF INSERT
AS
BEGIN
     -- Allow only rows where Salary >= 10000
    INSERT INTO Employees (EmpID, EmpName, Department, Salary)
    SELECT EmpID, EmpName, Department, Salary
    FROM inserted
    WHERE Salary >= 10000;

     -- Log invalid rows into audit table
    INSERT INTO EmployeeAudit (EmpName, Department, Salary, Reason)
    SELECT EmpName, Department, Salary, 'Salary below allowed threshold'
    FROM inserted
    WHERE Salary < 10000;
END;
GO


 -- Insert Data to Test Trigger
 -- This will insert Alice (valid) and log Bob (invalid salary)
INSERT INTO Employees (EmpID, EmpName, Department, Salary) VALUES
(1, 'Alice', 'IT', 12000),
(2, 'Bob', 'HR', 8000);     --Should be blocked and logged
GO


SELECT * FROM Employees;
SELECT * FROM EmployeeAudit;
GO



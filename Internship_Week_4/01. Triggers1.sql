  /*TRIGEERS :
  A Trigger is a special type of stored procedure that automatically runs
  when an event (INSERT, UPDATE, DELETE) occurs on a specified table or view.


  Types of Triggers in SQL Server:
  1. AFTER Trigger (aka FOR Trigger): Fires after the DML event is executed.
  2. INSTEAD OF Trigger: Replaces the DML event (used mostly on views).
  3. DDL Triggers and Logon Triggers (used for schema/security level operations) — NOT covered here.


  Use Case:
  Let’s say we want to log every update to the 'Employees' table into an 'EmployeeAudit' table.
  This is helpful for auditing and tracking who changed what.
  */




IF OBJECT_ID('EmployeeAudit', 'U') IS NOT NULL DROP TABLE EmployeeAudit;
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
IF OBJECT_ID('trg_AuditEmployeeUpdate', 'TR') IS NOT NULL DROP TRIGGER trg_AuditEmployeeUpdate;
GO


CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    Salary INT
);
GO


INSERT INTO Employees VALUES 
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'IT', 60000),
(3, 'Charlie', 'Finance', 70000);
GO


CREATE TABLE EmployeeAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EmpID INT,
    OldSalary INT,
    NewSalary INT,
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO


/*
AFTER UPDATE trigger


  Syntax:
  CREATE TRIGGER trigger_name
  ON table_name
  AFTER [INSERT/UPDATE/DELETE]
  AS
  BEGIN
        logic using INSERTED and DELETED pseudo-tables
  END
*/

CREATE TRIGGER trg_AuditEmployeeUpdate
ON Employees
AFTER UPDATE
AS
BEGIN
    --  Only log if Salary was actually changed
    INSERT INTO EmployeeAudit (EmpID, OldSalary, NewSalary)
    SELECT 
        d.EmpID,
        d.Salary AS OldSalary,
        i.Salary AS NewSalary
    FROM 
        INSERTED i
    INNER JOIN 
        DELETED d ON i.EmpID = d.EmpID
    WHERE 
        i.Salary <> d.Salary;    --Only track salary changes
END;
GO


 --Test the trigger
 --Update the salary for EmpID 2 and 3
UPDATE Employees
SET Salary = Salary + 5000
WHERE EmpID IN (2, 3);
GO

 --View the audit log
SELECT * FROM EmployeeAudit;

 --View updated employee table
SELECT * FROM Employees;



/*
  - INSERTED table: holds the new values after UPDATE.
  - DELETED table: holds the old values before UPDATE.
  - Triggers are auto-executed, no need to call them manually.
  - This example only logs changes to Salary to avoid noisy logs.
  */

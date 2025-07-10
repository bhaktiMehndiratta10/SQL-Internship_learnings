/*
  An "INSTEAD OF UPDATE" trigger is a special kind of trigger that fires before the actual UPDATE happens. It replaces the normal update behavior.


  Use Cases:
  To prevent certain updates based on custom logic
  To log or transform data before it's updated
  To enforce business rules that can't be enforced using constraints


  Syntax:


  CREATE TRIGGER trigger_name
  ON table_name
  INSTEAD OF UPDATE
  AS
  BEGIN
        custom logic
  END



  The 'inserted' pseudo-table holds the *new values*
  The 'deleted' pseudo-table holds the *old values*
*/


IF OBJECT_ID('Employee', 'U') IS NOT NULL DROP TABLE Employee;
GO

IF OBJECT_ID('trg_InsteadOfUpdate_Employee', 'TR') IS NOT NULL DROP TRIGGER trg_InsteadOfUpdate_Employee;
GO


CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Salary DECIMAL(10, 2),
    Grade CHAR(1)
);
GO


INSERT INTO Employee VALUES
(1, 'Alice', 50000, 'B'),
(2, 'Bob', 40000, 'C'),
(3, 'Charlie', 60000, 'A');
GO


--INSTEAD OF UPDATE trigger
CREATE TRIGGER trg_InsteadOfUpdate_Employee
ON Employee
INSTEAD OF UPDATE
AS
BEGIN

      --Prevent salary from being updated to a value < 30000
      --Automatically adjust grade based on new salary

    SET NOCOUNT ON;

      --Custom business rule enforcement inside the trigger
    UPDATE E
    SET 
        E.EmpName = I.EmpName,
        E.Salary = 
            CASE 
                WHEN I.Salary < 30000 THEN 30000    --Enforce minimum salary
                ELSE I.Salary 
            END,
        E.Grade = 
            CASE 
                WHEN I.Salary >= 60000 THEN 'A'
                WHEN I.Salary >= 45000 THEN 'B'
                ELSE 'C'
            END
    FROM Employee E
    INNER JOIN inserted I ON E.EmpID = I.EmpID;
END;
GO


 --This update tries to set salary to 25000, which is too low
UPDATE Employee
SET Salary = 25000
WHERE EmpID = 2;
GO

 --This update sets salary to a valid value (e.g., 65000)
UPDATE Employee
SET Salary = 65000
WHERE EmpID = 1;
GO


SELECT * FROM Employee;
GO


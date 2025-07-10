/*
  INSTEAD OF DELETE triggers are special types of DML triggers that execute *in place of* the standard DELETE operation.
  DELETE physically removes rows from a table.
  INSTEAD OF DELETE intercepts the delete and lets you run custom logic (like soft delete or logging) without actually deleting the row.
  Why use it? To prevent data loss, enable audit trails, or enforce business rules without blocking user actions.
*/


CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    IsActive BIT DEFAULT 1        
);

CREATE TABLE DeletedRecordsLog (
    EmpID INT,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    DeletedOn DATETIME
);
GO


INSERT INTO Employee (EmpID, EmpName, Department)
VALUES 
(101, 'Alice', 'HR'),
(102, 'Bob', 'IT'),
(103, 'Charlie', 'Finance');
GO


CREATE TRIGGER trg_InsteadOfDelete_Employee
ON Employee
INSTEAD OF DELETE
AS
BEGIN
    -- Log the delete attempt into the audit table
    INSERT INTO DeletedRecordsLog (EmpID, EmpName, Department, DeletedOn)
    SELECT EmpID, EmpName, Department, GETDATE()
    FROM deleted;

     -- Instead of deleting, mark the employee as inactive (soft delete)
    UPDATE e
    SET IsActive = 0
    FROM Employee e
    INNER JOIN deleted d ON e.EmpID = d.EmpID;
END;
GO


 -- Attempt to delete an employee row. This will trigger the INSTEAD OF DELETE logic
DELETE FROM Employee WHERE EmpID = 102;
GO


SELECT * FROM Employee;
SELECT * FROM DeletedRecordsLog;

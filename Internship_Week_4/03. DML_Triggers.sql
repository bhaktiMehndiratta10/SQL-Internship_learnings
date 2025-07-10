 /*
  A DML (Data Manipulation Language) trigger is a special type of stored procedure that is automatically executed in response to INSERT, UPDATE, or DELETE operations on a specified table or view.

  Use Cases:
  Enforce complex business logic rules beyond constraints
  Maintain audit trails (e.g., who changed what and when)
  Automatically propagate or restrict data changes
  Validate data before allowing modification
  Simulate DML support on views using INSTEAD OF triggers



  Types of DML Triggers:

  1. AFTER Trigger:
     - Executes after the triggering DML operation completes.
     - Commonly used for logging, auditing, post-processing.
     - Works only on tables (not on views).
     - Can be used for INSERT, UPDATE, DELETE (or combinations).

  2. INSTEAD OF Trigger:
     - Executes instead of the DML operation.
     - Commonly used to handle INSERT/UPDATE/DELETE on views.
     - Can be used to override or block modifications.



  SYNTAX OF AFTER TRIGGER :

  CREATE TRIGGER trigger_name
  ON table_name
  AFTER INSERT, UPDATE, DELETE     any one or multiple
  AS
  BEGIN
        Trigger logic goes here
  END;




  SYNTAX OF INSTEAD OF TRIGGER:

  CREATE TRIGGER trigger_name
  ON table_name_or_view_name
  INSTEAD OF INSERT, UPDATE, DELETE
  AS
  BEGIN
        Custom implementation of the operation
  END;
*/



IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
GO


CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(100),
    Salary INT,
    Location NVARCHAR(100)
);
GO


INSERT INTO Employees VALUES
(1, 'Alice', 'HR', 50000, 'Delhi'),
(2, 'Bob', 'IT', 60000, 'Mumbai'),
(3, 'Charlie', 'Finance', 70000, 'Bangalore'),
(4, 'David', 'IT', 62000, 'Mumbai');
GO


 --Basic UPDATE Operation (Single Row Update)
 --Scenario: Alice got transferred from Delhi to Chennai
UPDATE Employees
SET Location = 'Chennai'
WHERE EmpID = 1;
GO


  --Conditional UPDATE (Multiple Rows)
  --Scenario: Increase salary of all IT employees by 10%
UPDATE Employees
SET Salary = Salary * 1.10    10% hike
WHERE Department = 'IT';
GO


 -- UPDATE using a JOIN
 -- Table with revised salaries
IF OBJECT_ID('RevisedSalaries', 'U') IS NOT NULL DROP TABLE RevisedSalaries;
GO

CREATE TABLE RevisedSalaries (
    EmpID INT,
    NewSalary INT
);
GO

INSERT INTO RevisedSalaries VALUES
(2, 70000),
(3, 80000);
GO


 -- Update Employees using JOIN with RevisedSalaries
UPDATE E
SET E.Salary = R.NewSalary
FROM Employees E
INNER JOIN RevisedSalaries R ON E.EmpID = R.EmpID;
GO


SELECT * FROM Employees;


 
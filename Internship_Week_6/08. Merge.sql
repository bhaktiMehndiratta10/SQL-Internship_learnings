/*

The MERGE statement allows you to perform INSERT, UPDATE, and DELETE operations in a single statement by comparing a target table with a source table.
Use cases: Data synchronization, slowly changing dimensions, staging table updates, etc.


SYNTAX:

  MERGE target_table AS target
  USING source_table AS source
  ON <matching_condition>
  WHEN MATCHED THEN
      UPDATE SET ...
  WHEN NOT MATCHED BY TARGET THEN
      INSERT ...
  WHEN NOT MATCHED BY SOURCE THEN
      DELETE;  -- optional
*/


IF OBJECT_ID('dbo.EmployeeTarget', 'U') IS NOT NULL DROP TABLE dbo.EmployeeTarget;
IF OBJECT_ID('dbo.EmployeeSource', 'U') IS NOT NULL DROP TABLE dbo.EmployeeSource;

CREATE TABLE dbo.EmployeeTarget
(
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE dbo.EmployeeSource
(
    EmpID INT PRIMARY KEY,
    EmpName NVARCHAR(100),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);


INSERT INTO dbo.EmployeeTarget (EmpID, EmpName, Department, Salary)
VALUES 
(1, 'Alice', 'HR', 50000),
(2, 'Bob', 'IT', 60000),
(3, 'Charlie', 'Finance', 55000);

INSERT INTO dbo.EmployeeSource (EmpID, EmpName, Department, Salary)
VALUES
(2, 'Bob', 'IT', 65000),         
(3, 'Charlie', 'Finance', 55000), 
(4, 'Diana', 'HR', 48000);  

MERGE dbo.EmployeeTarget AS target
USING dbo.EmployeeSource AS source
ON target.EmpID = source.EmpID

WHEN MATCHED AND target.Salary <> source.Salary THEN
    UPDATE SET
        target.EmpName = source.EmpName,
        target.Department = source.Department,
        target.Salary = source.Salary

WHEN NOT MATCHED BY TARGET THEN
    INSERT (EmpID, EmpName, Department, Salary)
    VALUES (source.EmpID, source.EmpName, source.Department, source.Salary)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;  
SELECT * FROM dbo.EmployeeTarget;



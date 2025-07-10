/*
  Stored Procedure

  A stored procedure is a saved collection of one or more SQL statements 
  that you can execute as a single unit. 
  It is stored in the database and can accept input parameters, return output, 
  and be reused multiple times.



  Why Use Stored Procedures?

  1. Code reusability: Define once, use anywhere.
  2. Performance: SQL Server pre-compiles procedures for faster execution.
  3. Security: Permissions can be granted on procedures instead of underlying tables.
  4. Maintainability: Logic is centralized in the database, making changes easier.
  5. Reduces network traffic: Since procedures execute on the server side.



   Basic Syntax:
  CREATE PROCEDURE procedure_name  
      @param1 datatype = default_value,  
      @param2 datatype OUTPUT  
  AS  
  BEGIN  
        SQL statements  
  END  

   EXEC procedure_name @param1 = value, @param2 = value OUTPUT  

*/

IF OBJECT_ID('GetAllEmployees', 'P') IS NOT NULL
    DROP PROCEDURE GetAllEmployees;
GO


IF OBJECT_ID('Employees', 'U') IS NOT NULL
    DROP TABLE Employees;
GO


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(50)
);
GO


INSERT INTO Employees (EmployeeID, Name, Department) VALUES 
(1, 'Alice', 'HR'),
(2, 'Bob', 'IT'),
(3, 'Charlie', 'Finance');
GO


CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;
GO

EXEC GetAllEmployees;

/*
  Key Constraints in SQL Server

  1. PRIMARY KEY     – Uniquely identifies rows.
  2. FOREIGN KEY     – Enforces referential integrity.
  3. UNIQUE KEY      – Ensures uniqueness (allows one NULL in SQL Server).
  4. COMPOSITE KEY   – Key with multiple columns.
  5. CANDIDATE KEY   – Columns eligible to be PRIMARY KEY.
  6. ALTERNATE KEY   – Candidate keys not chosen as PK (usually UNIQUE).
  7. SUPER KEY       – Any column(s) that can uniquely identify rows.
*/


IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
GO

-- Parent Table: Departments
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,                   -- PRIMARY KEY
    DeptName VARCHAR(100) NOT NULL UNIQUE     -- UNIQUE KEY
);
GO

-- Child Table: Employees
CREATE TABLE Employees (
    EmpID INT NOT NULL,                        -- Part of COMPOSITE PRIMARY KEY
    DeptID INT NOT NULL,                       -- FOREIGN KEY to Departments
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100),
    Email VARCHAR(100) UNIQUE,                -- UNIQUE + CANDIDATE KEY
    Aadhar CHAR(12) NOT NULL,                 -- CANDIDATE KEY
    CONSTRAINT PK_Emp PRIMARY KEY (EmpID, DeptID),   -- COMPOSITE PRIMARY KEY
    CONSTRAINT FK_Emp_Dept FOREIGN KEY (DeptID) REFERENCES Departments(DeptID),
    CONSTRAINT UQ_Emp_Aadhar UNIQUE (Aadhar)         -- ALTERNATE KEY using UNIQUE
);
GO


INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Engineering');
GO


INSERT INTO Employees (EmpID, DeptID, FirstName, LastName, Email, Aadhar) VALUES
(101, 1, 'Aisha', 'Sharma', 'aisha@company.com', '123456789012'),
(102, 2, 'Raj', 'Kapoor', 'raj@company.com', '234567890123');
GO


SELECT * FROM Departments;
SELECT * FROM Employees;
GO

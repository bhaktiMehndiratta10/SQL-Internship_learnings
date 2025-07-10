/*
  1. CREATE DATABASE
  - A database is a container for tables, views, procedures, etc.
  - Syntax: CREATE DATABASE database_name;
*/

CREATE DATABASE CompanyDB;
GO

-- Switch to the newly created database
USE CompanyDB;
GO


/*
  2. CREATE TABLE
  - Tables store structured data in rows and columns.
  - Each column has a datatype and optional constraints.
  - Syntax:
    CREATE TABLE table_name (
        column1 datatype [constraints],
        column2 datatype [constraints],
        ...
    );
*/

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,                -- Unique employee ID
    FirstName VARCHAR(50) NOT NULL,       -- First name (required)
    LastName VARCHAR(50) NOT NULL,        -- Last name (required)
    Email VARCHAR(100) UNIQUE,            -- Must be unique
    HireDate DATE DEFAULT GETDATE()       -- Defaults to today's date
);
GO

/*
  3. INSERT INTO TABLE
  - Used to add data to a table.
  - Syntax: INSERT INTO table_name (col1, col2, ...) VALUES (...);
*/
INSERT INTO Employees (EmpID, FirstName, LastName, Email)
VALUES
(1, 'Aisha', 'Sharma', 'aisha@company.com'),
(2, 'Ravi', 'Verma', 'ravi@company.com'),
(3, 'Meena', 'Kumar', 'meena@company.com');
GO

/*
  4. SELECT FROM TABLE
  - Retrieves data from a table.
  - Syntax: SELECT column1, column2 FROM table_name;
*/
SELECT * FROM Employees;
GO

/*
  5. UPDATE TABLE
  - Modifies existing data.
  - Syntax:
    UPDATE table_name
    SET column1 = value1, column2 = value2
    WHERE condition;
*/
UPDATE Employees
SET Email = 'meena.k@company.com'
WHERE EmpID = 3;
GO

/*
  6. ALTER TABLE
  - Modifies the structure of an existing table.
  - Common operations:
      ADD column
      ALTER column
      DROP column
*/

-- Add a new column: Department
ALTER TABLE Employees
ADD Department VARCHAR(50);
GO

-- Update Department for existing rows
UPDATE Employees
SET Department = 'HR'
WHERE EmpID IN (1, 2);

UPDATE Employees
SET Department = 'Finance'
WHERE EmpID = 3;
GO

-- Alter column size (e.g., increase Department length)
ALTER TABLE Employees
ALTER COLUMN Department VARCHAR(100);
GO

/*
  7. DELETE FROM TABLE
  - Removes data from a table.
  - DELETE removes specific rows.
  - TRUNCATE removes all rows (faster but can't be rolled back).
*/

DELETE FROM Employees WHERE EmpID = 2;
GO

/*
  8. DROP TABLE
  - Completely removes a table and its data.
  - Syntax: DROP TABLE table_name;
*/
DROP TABLE Employees;
GO

/*
  9. DROP DATABASE
  - Completely deletes a database.
  - Cannot be undone. Ensure you're not using it.
*/
USE master;  -- Must exit the database before dropping it
GO
DROP DATABASE CompanyDB;
GO

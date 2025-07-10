/*
  SET OPERATIONS: UNION, UNION ALL, INTERSECT, EXCEPT
  Set operations combine results from two or more SELECT queries
  Conditions: Columns count and data types must match

  KEY POINTS:
  1. Column count & data types must match across SELECTs
  2. ORDER BY should be used at the end of the final SELECT
  3. Use UNION to remove duplicates, UNION ALL to keep them
  4. INTERSECT = common data; EXCEPT = difference
*/

IF OBJECT_ID('dbo.Employees_India', 'U') IS NOT NULL
    DROP TABLE dbo.Employees_India;

IF OBJECT_ID('dbo.Employees_USA', 'U') IS NOT NULL
    DROP TABLE dbo.Employees_USA;


CREATE TABLE Employees_India (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50)
);


INSERT INTO Employees_India (EmpID, EmpName, Department) VALUES
(1, 'Amit Singh', 'IT'),
(2, 'Priya Sharma', 'HR'),
(3, 'Karan Mehta', 'Finance'),
(4, 'Neha Gupta', 'IT');


CREATE TABLE Employees_USA (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Department VARCHAR(50)
);


INSERT INTO Employees_USA (EmpID, EmpName, Department) VALUES
(3, 'Karan Mehta', 'Finance'),        
(4, 'Neha Gupta', 'IT'),            
(5, 'John Doe', 'Marketing'),
(6, 'Emma Watson', 'HR');


/*
  UNION (Removes duplicates)
  Returns unique employees from both countries
*/

SELECT EmpName, Department FROM Employees_India
UNION
SELECT EmpName, Department FROM Employees_USA;

 -- Output: Combines both, but no duplicates (Karan, Neha only once)


/*
  UNION ALL (Keeps duplicates)
  Returns all employees including duplicates
*/

SELECT EmpName, Department FROM Employees_India
UNION ALL
SELECT EmpName, Department FROM Employees_USA;

  --Output: Karan and Neha will appear twice (once from each table)


/*
  INTERSECT
  Returns only employees present in BOTH tables
  Based on EmpName & Department combination
*/

SELECT EmpName, Department FROM Employees_India
INTERSECT
SELECT EmpName, Department FROM Employees_USA;

  --Output: Only Karan and Neha (since they exist in both with same data)


/*
  EXCEPT
  Returns employees in India but NOT in USA
*/

SELECT EmpName, Department FROM Employees_India
EXCEPT
SELECT EmpName, Department FROM Employees_USA;

  --Output: Amit and Priya (not present in USA table)



  /*
   REVERSE EXCEPT (USA - India)
  Returns employees in USA but NOT in India
*/

SELECT EmpName, Department FROM Employees_USA
EXCEPT
SELECT EmpName, Department FROM Employees_India;

  --Output: John and Emma (not in India table)

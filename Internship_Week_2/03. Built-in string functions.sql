/*
  String functions are built-in SQL Server functions that allows to manipulate and process string data (VARCHAR, NVARCHAR, etc.).
  These include operations like extracting substrings, changing case,
  replacing parts of a string, trimming spaces, finding positions, etc.

   USE CASES:
  1. Cleaning data (trimming, replacing unwanted characters)
  2. Formatting output (e.g., names, email parsing)
  3. Searching or filtering text content
  4. Extracting parts of strings (like domain from email)
  */


IF OBJECT_ID('dbo.EmployeeInfo', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeeInfo;

CREATE TABLE EmployeeInfo (
    EmpID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Department NVARCHAR(50),
    Bio NVARCHAR(MAX)
);

INSERT INTO EmployeeInfo (EmpID, FullName, Email, Department, Bio)
VALUES 
(1, '  Alice Johnson  ', 'alice.j@company.com', 'Engineering', '   Senior Engineer working on AI.   '),
(2, 'Bob SMITH', 'bob_smith@company.com', 'sales', '  Top performer in Q1.  '),
(3, 'Clara Doe', 'clara.doe@company.com', 'HR', 'Handles hiring & onboarding.'),
(4, 'David Wright', 'david@company.com', 'IT', '  Works on internal tools   ');



 -- (1). BASIC STRING CLEANING ::
--	TRIM(), LTRIM(), RTRIM() => Remove extra spaces

SELECT 
    EmpID,
    FullName AS OriginalName,
    TRIM(FullName) AS CleanedName,
    LTRIM(RTRIM(FullName)) AS ManuallyTrimmedName
FROM EmployeeInfo;


 
 
 -- (2). CASE CONVERSION ::
--  UPPER(), LOWER()

SELECT 
    FullName,
    UPPER(FullName) AS UpperCaseName,
    LOWER(FullName) AS LowerCaseName
FROM EmployeeInfo;

 
 
 
 -- (3). LENGTH AND BYTE LENGTH ::
-- LEN() => Length excluding trailing spaces
-- DATALENGTH() => Returns size in bytes (differs for NVARCHAR vs VARCHAR)

SELECT 
    FullName,
    LEN(FullName) AS CharLength,
    DATALENGTH(FullName) AS ByteLength
FROM EmployeeInfo;




-- (4️). STRING SEARCH ::
-- CHARINDEX() => Find position of a substring (case-insensitive)
 -- PATINDEX() => Pattern matching using wildcard (LIKE patterns)

SELECT 
    Email,
    CHARINDEX('@', Email) AS AtPosition,
    CHARINDEX('.', Email) AS DotPosition,
    PATINDEX('%@company.com%', Email) AS PatternMatchPosition
FROM EmployeeInfo;



-- (5). EXTRACTING PARTS OF STRING::
-- SUBSTRING(), LEFT(), RIGHT()

SELECT 
    FullName,
    SUBSTRING(FullName, 1, 5) AS First5Chars,
    LEFT(FullName, 3) AS First3Chars,
    RIGHT(FullName, 4) AS Last4Chars
FROM EmployeeInfo;

 -- Extract domain from Email 
SELECT 
    Email,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS DomainPart
FROM EmployeeInfo;


  
  
-- (6️). STRING REPLACEMENT AND FORMATTING ::
-- REPLACE() => Replace substring
-- FORMAT() => Format number/dates as strings

SELECT 
    Bio,
    REPLACE(Bio, '  ', '') AS CleanedBio
FROM EmployeeInfo;

SELECT 
    FullName,
    FORMAT(GETDATE(), 'dd-MMM-yyyy') AS FormattedDate
FROM EmployeeInfo;



-- (7). CONCATENATION ::
-- CONCAT(), + operator, SPACE(), REPLICATE()
SELECT 
    FullName,
    CONCAT(FullName, ' works in ', Department) AS Description,
    FullName + SPACE(3) + Department AS DescriptionWithSpace,
    REPLICATE('-', 20) AS Divider
FROM EmployeeInfo;



 -- (8). STRING AGGREGATION ::
-- STRING_AGG() => Combine strings with separator
SELECT 
    STRING_AGG(Department, ', ') AS AllDepartments
FROM EmployeeInfo;

 DROP TABLE EmployeeInfo;

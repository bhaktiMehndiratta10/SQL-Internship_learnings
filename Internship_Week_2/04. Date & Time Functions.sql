/*
  SQL Server provides various built-in Date and Time functions to manipulate, retrieve, and format date/time values. These are especially useful for filtering, calculating age/duration, scheduling reports, and time-based analytics.

  CORE CONCEPTS:
  1. CURRENT SYSTEM DATE/TIME FUNCTIONS:
      - GETDATE()         : Returns current date and time.
      - SYSDATETIME()     : Returns higher precision date and time.
      - CURRENT_TIMESTAMP : ANSI SQL version of GETDATE().
 
  2. DATE PART EXTRACTION:
      - YEAR(), MONTH(), DAY()             : Extract parts of date.
      - DATEPART(part, date)               : Returns specific part like hour, minute etc.
      - DATENAME(part, date)               : Returns name of the part (like 'Monday').
 
  3. DATE/TIME MODIFICATION:
      - DATEADD(part, value, date)         : Adds interval to a date.
      - DATEDIFF(part, startdate, enddate) : Returns difference between dates.
 
  4. DATE FORMATTING AND CONVERSION:
      - FORMAT(date, format_string)        : Returns date in specific string format.
      - CONVERT(data_type, date, style)    : Converts date to a string with format.
 
  5. DATE CREATION / VALIDATION:
      - EOMONTH(date)                      : Returns last day of the month.
      - ISDATE(expression)                 : Validates if expression is a date.
*/


IF OBJECT_ID('dbo.EmployeeAttendance', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeeAttendance;

CREATE TABLE EmployeeAttendance (
    EmpID INT,
    EmpName VARCHAR(50),
    CheckIn DATETIME,
    CheckOut DATETIME
);


INSERT INTO EmployeeAttendance (EmpID, EmpName, CheckIn, CheckOut)
VALUES
(1, 'Aarav', '2025-07-01 08:30:00', '2025-07-01 17:15:00'),
(2, 'Meera', '2025-07-01 09:00:00', '2025-07-01 18:00:00'),
(3, 'Karan', '2025-07-01 07:45:00', '2025-07-01 16:30:00');


  -- Get current system date and time
SELECT 
    GETDATE() AS Current_DateTime,
    SYSDATETIME() AS HighPrecision_DateTime,
    CURRENT_TIMESTAMP AS ANSI_Style_DateTime;


 --  Extract individual parts from CheckIn date
SELECT 
    EmpName,
    YEAR(CheckIn) AS CheckIn_Year,
    MONTH(CheckIn) AS CheckIn_Month,
    DAY(CheckIn) AS CheckIn_Day,
    DATEPART(HOUR, CheckIn) AS CheckIn_Hour,
    DATENAME(WEEKDAY, CheckIn) AS WeekDay_Name
FROM EmployeeAttendance;


 -- Calculate duration worked using DATEDIFF
SELECT 
    EmpName,
    DATEDIFF(MINUTE, CheckIn, CheckOut) AS Minutes_Worked,
    DATEDIFF(HOUR, CheckIn, CheckOut) AS Hours_Worked
FROM EmployeeAttendance;


   -- Add 7 days to CheckIn date using DATEADD (for next review)
SELECT 
    EmpName,
    CheckIn,
    DATEADD(DAY, 7, CheckIn) AS Next_Review_Date
FROM EmployeeAttendance;


 -- Format CheckIn time as string using FORMAT and CONVERT
SELECT 
    EmpName,
    FORMAT(CheckIn, 'dd-MMM-yyyy hh:mm tt') AS Formatted_CheckIn,
    CONVERT(VARCHAR, CheckIn, 113) AS Converted_CheckIn  
FROM EmployeeAttendance;


 --  Use EOMONTH to find end of the CheckIn month
SELECT 
    EmpName,
    CheckIn,
    EOMONTH(CheckIn) AS End_Of_Month
FROM EmployeeAttendance;


 -- Check if a string is a valid date using ISDATE
SELECT 
    '2025-07-05' AS TestValue1, ISDATE('2025-07-05') AS IsValidDate1,
    'Hello World' AS TestValue2, ISDATE('Hello World') AS IsValidDate2;

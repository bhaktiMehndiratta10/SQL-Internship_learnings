/*
PIVOT with COUNT: Counting categorical data


By default, PIVOT requires:
- An aggregate function: SUM, COUNT, AVG, MIN, MAX.
- A column whose values you want to pivot (become new columns).
- A grouping column (e.g., EmployeeName).


Example use cases:
- Counting number of 'Present' vs 'Absent' days per employee.
- Counting number of orders in each status per customer.
- Counting number of products sold in each region.


Working:
- The COUNT aggregate counts the number of rows in each group where the pivot column equals the column name in IN ([...]).
- The pivoted result shows counts per category as separate columns.


Syntax:

    SELECT <columns>, [category1], [category2], ...
    FROM
    (
        SELECT <group_column>, <pivot_column>
        FROM <table>
    ) AS Source
    PIVOT
    (
        COUNT(<pivot_column>)
        FOR <pivot_column> IN ([category1], [category2], ...)
    ) AS PivotTable;

*/

IF OBJECT_ID('Attendance', 'U') IS NOT NULL DROP TABLE Attendance;

CREATE TABLE Attendance (
    EmployeeName NVARCHAR(50),
    Status NVARCHAR(20)
);

-- Insert demo data
INSERT INTO Attendance VALUES
('Alice', 'Present'),
('Alice', 'Absent'),
('Alice', 'Present'),
('Bob', 'Present'),
('Bob', 'Present'),
('Charlie', 'Absent'),
('Charlie', 'Absent'),
('Charlie', 'Present'),
('Charlie', 'Present');


SELECT EmployeeName, [Present] AS PresentDays, [Absent] AS AbsentDays
FROM
(
    SELECT EmployeeName, Status
    FROM Attendance
) AS SourceTable
PIVOT
(
    COUNT(Status)                    -- Count how many times each status occurs
    FOR Status IN ([Present], [Absent]) -- Status values become columns
) AS PivotTable
ORDER BY EmployeeName;

/*
    - The inner query just selects raw data.
    - PIVOT with COUNT(Status): counts rows where Status = 'Present' or 'Absent' per employee.
    - FOR Status IN (...): the Status values ('Present', 'Absent') become new columns.
*/

/*
  JOINS in SQL

  - INNER JOIN       → Matches only.
  - LEFT JOIN        → All from left + matched from right.
  - RIGHT JOIN       → All from right + matched from left.
  - FULL OUTER JOIN  → All rows from both sides.
  - CROSS JOIN       → Cartesian product.
*/

-- Drop child table first to avoid foreign key conflicts
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID('dbo.Students', 'U') IS NOT NULL DROP TABLE dbo.Students;
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
GO

-- Students table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50)
);
GO

-- Courses table
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50)
);
GO

-- Enrollments table (junction table for many-to-many relationship)
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    EnrollmentDate DATE
);
GO

-- Insert sample data
INSERT INTO Students (StudentID, StudentName) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');
GO

INSERT INTO Courses (CourseID, CourseName) VALUES
(101, 'SQL Basics'),
(102, 'Advanced SQL'),
(103, 'Python for Data');
GO

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2024-01-15'),
(2, 1, 102, '2024-02-01'),
(3, 2, 101, '2024-01-20'),
(4, 3, 102, '2024-03-12');
GO

-- INNER JOIN: Only matching rows in all 3 tables
SELECT
    S.StudentName,
    C.CourseName,
    E.EnrollmentDate
FROM Enrollments E
INNER JOIN Students S ON E.StudentID = S.StudentID
INNER JOIN Courses C ON E.CourseID = C.CourseID;
GO

-- LEFT JOIN: All students + their enrollment info (if any)
SELECT
    S.StudentName,
    C.CourseName,
    E.EnrollmentDate
FROM Students S
LEFT JOIN Enrollments E ON S.StudentID = E.StudentID
LEFT JOIN Courses C ON E.CourseID = C.CourseID;
GO

-- RIGHT JOIN: All courses + enrolled students (if any)
SELECT
    C.CourseName,
    S.StudentName,
    E.EnrollmentDate
FROM Courses C
RIGHT JOIN Enrollments E ON C.CourseID = E.CourseID
RIGHT JOIN Students S ON E.StudentID = S.StudentID;
GO

-- FULL OUTER JOIN: All students and courses, whether matched or not
SELECT
    S.StudentName,
    C.CourseName,
    E.EnrollmentDate
FROM Students S
FULL OUTER JOIN Enrollments E ON S.StudentID = E.StudentID
FULL OUTER JOIN Courses C ON E.CourseID = C.CourseID;
GO

-- CROSS JOIN: Cartesian product of Students × Courses
SELECT
    S.StudentName,
    C.CourseName
FROM Students S
CROSS JOIN Courses C;
GO

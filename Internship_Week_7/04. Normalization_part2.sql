
IF OBJECT_ID('dbo.CourseInstructors', 'U') IS NOT NULL DROP TABLE dbo.CourseInstructors;
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID('dbo.Instructors', 'U') IS NOT NULL DROP TABLE dbo.Instructors;
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
IF OBJECT_ID('dbo.Students', 'U') IS NOT NULL DROP TABLE dbo.Students;


CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100) NOT NULL
);


CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL
);


CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    InstructorName NVARCHAR(100) NOT NULL
);


CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


CREATE TABLE CourseInstructors (
    CourseInstructorID INT PRIMARY KEY IDENTITY(1,1),
    CourseID INT NOT NULL,
    InstructorID INT NOT NULL,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID)
);


INSERT INTO Students (StudentID, StudentName)
VALUES (101, 'Emma Watson'),
       (102, 'Liam Brown');


INSERT INTO Courses (CourseID, CourseName)
VALUES (201, 'Database Systems'),
       (202, 'Operating Systems');


INSERT INTO Instructors (InstructorID, InstructorName)
VALUES (301, 'Dr. Alan Turing'),
       (302, 'Dr. Grace Hopper');


INSERT INTO Enrollments (StudentID, CourseID)
VALUES (101, 201), 
       (101, 202), 
       (102, 202); 


INSERT INTO CourseInstructors (CourseID, InstructorID)
VALUES (201, 301), 
       (202, 302); 


SELECT 
    s.StudentID,
    s.StudentName,
    c.CourseName,
    i.InstructorName
FROM Enrollments e
INNER JOIN Students s ON e.StudentID = s.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
INNER JOIN CourseInstructors ci ON c.CourseID = ci.CourseID
INNER JOIN Instructors i ON ci.InstructorID = i.InstructorID
ORDER BY s.StudentID, c.CourseName;



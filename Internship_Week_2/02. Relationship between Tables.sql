/*
  In relational databases, a "relationship" defines how data in one table 
  is connected to data in another. SQL supports various types of relationships 
  using PRIMARY KEYS and FOREIGN KEYS.

  CORE CONCEPTS:
  1. PRIMARY KEY: Uniquely identifies each row in a table.
  2. FOREIGN KEY: A column in one table that refers to the PRIMARY KEY in another.
  3. Types of Relationships:
     a. ONE-TO-ONE   → Rare; One row in A = One row in B
     b. ONE-TO-MANY  → Most common; e.g., one Department has many Students
     c. MANY-TO-MANY → Requires a bridge/junction table; e.g., Students & Courses
*/


IF OBJECT_ID('StudentCourse', 'U') IS NOT NULL DROP TABLE StudentCourse;
IF OBJECT_ID('Student', 'U') IS NOT NULL DROP TABLE Student;
IF OBJECT_ID('Course', 'U') IS NOT NULL DROP TABLE Course;
IF OBJECT_ID('Department', 'U') IS NOT NULL DROP TABLE Department;


 --One Department can have many Students (One-to-Many)
CREATE TABLE Department (
    DeptID INT PRIMARY KEY IDENTITY(1,1),
    DeptName VARCHAR(50) NOT NULL
);


 --A Course can be taken by many Students (Many-to-Many)
CREATE TABLE Course (
    CourseID INT PRIMARY KEY IDENTITY(100,1),
    CourseName VARCHAR(50) NOT NULL,
    Credits INT NOT NULL
);


 --A Student belongs to ONE Department (Many-to-One)
CREATE TABLE Student (
    StudentID INT PRIMARY KEY IDENTITY(1000,1),
    StudentName VARCHAR(100) NOT NULL,
    DeptID INT,    --Foreign key referencing Department

    CONSTRAINT FK_Student_Department FOREIGN KEY (DeptID)
    REFERENCES Department(DeptID)
    ON DELETE SET NULL    --if Department deleted, student’s DeptID becomes NULL
    ON UPDATE CASCADE
);


-- Many-to-Many between Student and Course
CREATE TABLE StudentCourse (
    StudentID INT,
    CourseID INT,

    CONSTRAINT PK_StudentCourse PRIMARY KEY (StudentID, CourseID),

    CONSTRAINT FK_StudentCourse_Student FOREIGN KEY (StudentID)
    REFERENCES Student(StudentID)
    ON DELETE CASCADE,

    CONSTRAINT FK_StudentCourse_Course FOREIGN KEY (CourseID)
    REFERENCES Course(CourseID)
    ON DELETE CASCADE
);


INSERT INTO Department (DeptName) VALUES ('Computer Science'), ('Mechanical'), ('Civil');


INSERT INTO Course (CourseName, Credits)
VALUES ('Database Systems', 3), ('Thermodynamics', 4), ('Structural Analysis', 3);

INSERT INTO Student (StudentName, DeptID)
VALUES 
('Alice', 1),
('Bob', 2), 
('Charlie', 1),
('Diana', 3);  

 --Student-Course Enrollments (Many-to-Many)
INSERT INTO StudentCourse (StudentID, CourseID)
VALUES 
(1000, 100),   
(1001, 101),  
(1002, 100),   
(1002, 102),   
(1003, 102);   


 --1. One-to-Many: List all students with their department names
SELECT S.StudentName, D.DeptName
FROM Student S
LEFT JOIN Department D ON S.DeptID = D.DeptID;

 --2. Many-to-Many: List students with the courses they're enrolled in
SELECT S.StudentName, C.CourseName
FROM Student S
JOIN StudentCourse SC ON S.StudentID = SC.StudentID
JOIN Course C ON SC.CourseID = C.CourseID;

 --3. Department with number of students (Group by)
SELECT D.DeptName, COUNT(S.StudentID) AS NumStudents
FROM Department D
LEFT JOIN Student S ON D.DeptID = S.DeptID
GROUP BY D.DeptName;

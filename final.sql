-- FINAL PROJECT

-- DROP DATABASE 
drop database final;

-- CREATE DATABASE
create database final;

-- USE DATABASE
use final;

-- CREATING TABLE
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


-- INSERTING RECORDS
INSERT INTO Students VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

INSERT INTO Departments VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Courses VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

INSERT INTO Instructors VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);

INSERT INTO Enrollments VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

-- 1. CRUD OPERATIONS
-- INSERT
INSERT INTO Students VALUES (3, 'Mira', 'Patel', 'mira@gmail.com', '2001-12-05', '2023-08-01');

-- UPDATE
UPDATE Students SET Email='john.new@email.com' WHERE StudentID=1;

-- DELETE
DELETE FROM Students WHERE StudentID=3;

-- READ
SELECT * FROM Students;

-- 2. RETRIEVE STUDENTS WHO ENROLLED AFTER 2022
SELECT * FROM Students
WHERE YEAR(EnrollmentDate) > 2022;

-- 3. COURSES OFFERED BY MATHEMATICS WITH LIMIT 5
SELECT * FROM Courses
WHERE DepartmentID = 1
LIMIT 5;

-- 4. NUMBER OF STUDENTS ENROLLED IN EACH COURSE (MORE THAN 5 FILTER)
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- 5. STUDENTS ENROLLED IN BOTH SQL & DATA STRUCTURES
SELECT s.StudentID, s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT StudentID FROM Enrollments WHERE CourseID = 103
)
AND s.StudentID IN (
    SELECT StudentID FROM Enrollments WHERE CourseID = 104
);

-- 6. EITHER STUDENTS ENROLLED IN SQL OR DATA STRUCTURES
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102);
 
-- 7. AVERAGE NUMBER OF CREDITS
SELECT AVG(Credits) AS AvgCredits FROM Courses;

-- 9. COUNT STUDENTS IN EACH DEPARTMENT
SELECT d.DepartmentName, COUNT(e.StudentID) AS TotalStudents
FROM Departments d
LEFT JOIN Courses c ON d.DepartmentID = c.DepartmentID
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

-- 10. INNER JOIN - STUDENTS & THEIR COURSES
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 11. LEFT JOIN - ALL STUDENTS AND THEIR COURSES
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. SUBQUERY - COURSES WITH > 10 STUDENTS
SELECT StudentID, CourseID
FROM Enrollments
WHERE CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(StudentID) > 10
);

-- 13. EXTRACT YEAR FROM ENROLLMENTDATE
SELECT StudentID, YEAR(EnrollmentDate) AS EnrollYear
FROM Students;

-- 14. CONCATENATE INSTRUCTOR FULL NAME
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;

-- 15. RUNNING TOTAL OF STUDENTS ENROLLED
SELECT EnrollmentID, StudentID,
       SUM(1) OVER (ORDER BY EnrollmentID) AS RunningTotal
FROM Enrollments;


-- 16. LABEL SENIOR / JUNIOR
SELECT StudentID, FirstName, EnrollmentDate,
CASE 
    WHEN YEAR(CURDATE()) - YEAR(EnrollmentDate) > 2
        THEN 'Senior'
    ELSE 'Junior'
END AS StudentLevel
FROM Students;
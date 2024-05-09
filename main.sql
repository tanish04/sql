-- Create the database
CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- Create tables
CREATE TABLE IF NOT EXISTS STUDENT (
    RollNo CHAR(6),
    StudentName VARCHAR(20),
    Course VARCHAR(10),
    DOB DATE,
    PRIMARY KEY (RollNo)
);

CREATE TABLE IF NOT EXISTS SOCIETY (
    SocID CHAR(6),
    SocName VARCHAR(20),
    MentorName VARCHAR(15),
    Date DATE,
    TotalSeats INT UNSIGNED,
    PRIMARY KEY (SocID)
);

CREATE TABLE IF NOT EXISTS ENROLLMENT (
    RollNo CHAR(6),
    SID CHAR(6),
    DateOfEnrollment DATE,
    EnrollmentFees ENUM('yes', 'no'),
    FOREIGN KEY (RollNo) REFERENCES STUDENT(RollNo),
    FOREIGN KEY (SID) REFERENCES SOCIETY(SocID),
    PRIMARY KEY (RollNo, SID)
);

-- Inserting into SOCIETY table
INSERT INTO SOCIETY (SocID, SocName, MentorName, Date, TotalSeats)
VALUES
    ('SC001', 'Debating', 'John Doe', '2023-01-01', 100), -- Increasing TotalSeats for Debating society
    ('SC002', 'Dancing', 'Jane Smith', '2023-02-01', 40),
    ('SC003', 'Sashakt', 'Alex Gupta', '2023-03-01', 60),
    ('SC004', 'NSS', 'Emily Gupta', '2023-04-01', 70),
    ('SC005', 'Music Club', 'Michael Johnson', '2023-05-01', 45);
-- Inserting into STUDENT table
INSERT INTO STUDENT (RollNo, StudentName, Course, DOB)
VALUES
    ('S001', 'Alice', 'CS', '2000-05-15'), -- Changing course name for Alice to 'CS'
    ('S002', 'Bob', 'Chemistry', '2001-03-20'),
    ('S003', 'Charlie', 'Physics', '2000-12-10'),
    ('S004', 'David', 'CS', '2001-07-05'), -- Changing course name for David to 'CS'
    ('S005', 'Eva', 'Biology', '2000-09-25');



-- Inserting into ENROLLMENT table
INSERT INTO ENROLLMENT (RollNo, SID, DateOfEnrollment, EnrollmentFees)
VALUES
    ('S001', 'SC001', '2023-01-02', 'yes'),
    ('S002', 'SC001', '2023-01-05', 'yes'),
    ('S003', 'SC001', '2023-01-10', 'no'),
    ('S001', 'SC002', '2023-02-02', 'yes'),
    ('S002', 'SC002', '2023-02-05', 'yes'),
    ('S003', 'SC002', '2023-02-10', 'yes'),
    ('S004', 'SC002', '2023-02-12', 'no'),
    ('S005', 'SC003', '2023-03-01', 'yes'),
    ('S001', 'SC003', '2023-03-02', 'no'),
    ('S002', 'SC003', '2023-03-05', 'yes'),
    ('S003', 'SC003', '2023-03-10', 'yes'),
    ('S004', 'SC003', '2023-03-12', 'yes'),
    ('S005', 'SC004', '2023-04-01', 'yes'),
    ('S001', 'SC004', '2023-04-02', 'yes'),
    ('S002', 'SC004', '2023-04-05', 'no'),
    ('S003', 'SC004', '2023-04-10', 'yes'),
    ('S004', 'SC004', '2023-04-12', 'yes'),
    ('S005', 'SC005', '2023-05-01', 'no'),
    ('S001', 'SC005', '2023-05-02', 'no');

-- Verify data insertion
SELECT * FROM STUDENT;
SELECT * FROM SOCIETY;
SELECT * FROM ENROLLMENT;

-- 1. Retrieve names of students enrolled in any society.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo;

-- 2. Retrieve all society names.
SELECT SocName FROM SOCIETY;

-- 3. Retrieve students' names starting with letter ‘A’.
SELECT StudentName FROM STUDENT WHERE StudentName LIKE 'A%';

-- 4. Retrieve students' details studying in courses ‘computer science’ or ‘chemistry’.
SELECT * FROM STUDENT WHERE Course IN ('CS', 'Chemistry');

-- 5. Retrieve students’ names whose roll no either starts with ‘X’ or ‘Z’ and ends with ‘9’.
SELECT StudentName FROM STUDENT WHERE (RollNo LIKE 'X%' OR RollNo LIKE 'Z%') AND RollNo LIKE '%9';

-- 6. Find society details with more than N TotalSeats where N is to be input by the user.
SET @N = 50;
SELECT * FROM SOCIETY WHERE TotalSeats > @N;

-- 7. Update society table for mentor name of a specific society.
UPDATE SOCIETY SET MentorName = 'New Mentor' WHERE SocID = 'SC001';

-- 8. Find society names in which more than five students have enrolled.
SELECT s.SocName
FROM SOCIETY s
JOIN ENROLLMENT e ON s.SocID = e.SID
GROUP BY s.SocName
HAVING COUNT(*) > 5;

-- 9. Find the name of youngest student enrolled in society ‘NSS’.
SELECT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
WHERE e.SID = 'SC004'
ORDER BY s.DOB ASC
LIMIT 1;

-- 10. Find the name of the most popular society (on the basis of enrolled students).
SELECT s.SocName
FROM SOCIETY s
JOIN ENROLLMENT e ON s.SocID = e.SID
GROUP BY s.SocName
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 11. Find the name of two least popular societies (on the basis of enrolled students).
SELECT s.SocName
FROM SOCIETY s
JOIN ENROLLMENT e ON s.SocID = e.SID
GROUP BY s.SocName
ORDER BY COUNT(*) ASC
LIMIT 2;

-- 12. Find the student names who are not enrolled in any society.
SELECT StudentName
FROM STUDENT
WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);

-- 13. Find the student names enrolled in at least two societies.
SELECT s.StudentName
FROM STUDENT s
JOIN (
    SELECT RollNo
    FROM ENROLLMENT
    GROUP BY RollNo
    HAVING COUNT(*) >= 2
) AS e ON s.RollNo = e.RollNo;

-- 14. Find society names in which the maximum students are enrolled.
SELECT s.SocName
FROM SOCIETY s
JOIN (
    SELECT SID, COUNT(*) AS num_students
    FROM ENROLLMENT
    GROUP BY SID
    ORDER BY num_students DESC
    LIMIT 1
) AS e ON s.SocID = e.SID;

-- 15. Find names of all students who have enrolled in any society and society names in which at least one student has enrolled.
SELECT s.StudentName, e.SocName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo;

-- 16. Find names of students who are enrolled in any of the three societies ‘Debating’, ‘Dancing’ and ‘Sashakt’.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
JOIN SOCIETY soc ON e.SID = soc.SocID
WHERE soc.SocName IN ('Debating', 'Dancing', 'Sashakt');

-- 17. Find society names such that its mentor has a name with ‘Gupta’ in it.
SELECT SocName
FROM SOCIETY
WHERE MentorName LIKE '%Gupta%';

-- 18. Find the society names in which the number of enrolled students is only 10% of its capacity.
SELECT s.SocName
FROM SOCIETY s
JOIN (
    SELECT SID, COUNT(*) AS num_students
    FROM ENROLLMENT
    GROUP BY SID
) AS e ON s.SocID = e.SID
WHERE e.num_students <= 0.1 * s.TotalSeats;

-- 19. Display the vacant seats for each society.
SELECT s.SocName, s.TotalSeats - IFNULL(e.num_students, 0) AS VacantSeats
FROM SOCIETY s
LEFT JOIN (
    SELECT SID, COUNT(*) AS num_students
    FROM ENROLLMENT
    GROUP BY SID
) AS e ON s.SocID = e.SID;

-- 20. Increment Total Seats of each society by 10%.
UPDATE SOCIETY
SET TotalSeats = TotalSeats * 1.1;

-- 21. Add the enrollment fees paid (‘yes’/’No’) field in the enrollment table.
ALTER TABLE ENROLLMENT
ADD COLUMN EnrollmentFees ENUM('yes', 'no');

-- 22. Update date of enrollment of society id ‘s1’ to ‘2018-01-15’, ‘s2’ to current date and ‘s3’ to ‘2018-01-02’.
UPDATE ENROLLMENT
SET DateOfEnrollment =
    CASE
        WHEN SID = 'SC001' THEN '2018-01-15'
        WHEN SID = 'SC002' THEN CURDATE()
        WHEN SID = 'SC003' THEN '2018-01-02'
    END;

-- 23. Create a view to keep track of society names with the total number of students enrolled in it.
CREATE VIEW Society_Enrollment_Count AS
SELECT s.SocName, COUNT(e.RollNo) AS TotalEnrolled
FROM SOCIETY s
LEFT JOIN ENROLLMENT e ON s.SocID = e.SID
GROUP BY s.SocName;

-- 24. Find student names enrolled in all the societies.
SELECT s.StudentName
FROM STUDENT s
WHERE NOT EXISTS (
    SELECT SocID FROM SOCIETY
    WHERE NOT EXISTS (
        SELECT SID FROM ENROLLMENT
        WHERE SID = SocID AND RollNo = s.RollNo
    )
);

-- 25. Count the number of societies with more than 5 students enrolled in it.
SELECT COUNT(*)
FROM (
    SELECT SID
    FROM ENROLLMENT
    GROUP BY SID
    HAVING COUNT(*) > 5
) AS Subquery;

-- 26. Add column Mobile number in student table with default value ‘9999999999’.
ALTER TABLE STUDENT
ADD COLUMN Mobile VARCHAR(15) DEFAULT '9999999999';

-- 27. Find the total number of students whose age is > 20 years.
SELECT COUNT(*)
FROM STUDENT
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 20;

-- 28. Find names of students who are born in 2001 and are enrolled in at least one society.
SELECT DISTINCT s.StudentName
FROM STUDENT s
JOIN ENROLLMENT e ON s.RollNo = e.RollNo
WHERE YEAR(s.DOB) = 2001;

-- 29. Count all societies whose name starts with ‘S’ and ends with ‘t’ and at least 5 students are enrolled in the society.
SELECT COUNT(*)
FROM (
    SELECT SID
    FROM SOCIETY
    WHERE SocName LIKE 'S%t' AND SID IN (
        SELECT SID
        FROM ENROLLMENT
        GROUP BY SID
        HAVING COUNT(*) >= 5
    )
) AS Subquery;

-- 30. Display the following information: Society name, Mentor name, Total Capacity, Total Enrolled, Unfilled Seats.
SELECT s.SocName, s.MentorName, s.TotalSeats, IFNULL(e.num_students, 0) AS TotalEnrolled, s.TotalSeats - IFNULL(e.num_students, 0) AS UnfilledSeats
FROM SOCIETY s
LEFT JOIN (
    SELECT SID, COUNT(*) AS num_students
    FROM ENROLLMENT
    GROUP BY SID
) AS e ON s.SocID = e.SID;




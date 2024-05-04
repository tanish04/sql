Sure, here's how you can create and execute SQL queries for each of the given tasks:

1. Retrieve names of students enrolled in any society.
```sql
SELECT StudentName 
FROM STUDENT
WHERE RollNo IN (SELECT RollNo FROM ENROLLMENT);
```

2. Retrieve all society names.
```sql
SELECT SocName FROM SOCIETY;
```

3. Retrieve students' names starting with letter ‘A’.
```sql
SELECT StudentName 
FROM STUDENT
WHERE StudentName LIKE 'A%';
```

4. Retrieve students' details studying in courses ‘computer science’ or ‘chemistry’.
```sql
SELECT * 
FROM STUDENT 
WHERE Course IN ('computer science', 'chemistry');
```

5. Retrieve students’ names whose roll no either starts with ‘X’ or ‘Z’ and ends with ‘9’.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE RollNo LIKE 'X%9' OR RollNo LIKE 'Z%9';
```

6. Find society details with more than N TotalSeats where N is to be input by the user.
```sql
SELECT * 
FROM SOCIETY 
WHERE TotalSeats > N;
```

Continue for the rest. Let me know if you'd like me to proceed!
7. Update society table for mentor name of a specific society.
```sql
UPDATE SOCIETY 
SET MentorName = 'NewMentorName' 
WHERE SocID = 'specific_society_id';
```

8. Find society names in which more than five students have enrolled.
```sql
SELECT SocName 
FROM SOCIETY 
WHERE SocID IN (SELECT SID FROM ENROLLMENT GROUP BY SID HAVING COUNT(*) > 5);
```

9. Find the name of the youngest student enrolled in society ‘NSS’.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE RollNo = (SELECT RollNo FROM ENROLLMENT WHERE SID = 'NSS' ORDER BY DOB ASC LIMIT 1);
```

10. Find the name of the most popular society (on the basis of enrolled students).
```sql
SELECT SocName 
FROM SOCIETY 
WHERE SocID = (SELECT SID FROM ENROLLMENT GROUP BY SID ORDER BY COUNT(*) DESC LIMIT 1);
```

11. Find the name of two least popular societies (on the basis of enrolled students).
```sql
SELECT SocName 
FROM SOCIETY 
WHERE SocID IN (SELECT SID FROM ENROLLMENT GROUP BY SID ORDER BY COUNT(*) ASC LIMIT 2);
```

12. Find the student names who are not enrolled in any society.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);
```

13. Find the student names enrolled in at least two societies.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE RollNo IN (SELECT RollNo FROM ENROLLMENT GROUP BY RollNo HAVING COUNT(*) >= 2);
```

14. Find society names in which the maximum students are enrolled.
```sql
SELECT SocName 
FROM SOCIETY 
WHERE TotalSeats = (SELECT MAX(TotalSeats) FROM SOCIETY);
```

15. Find names of all students who have enrolled in any society and society names in which at least one student has enrolled.
```sql
SELECT StudentName, SocName 
FROM STUDENT 
LEFT JOIN ENROLLMENT ON STUDENT.RollNo = ENROLLMENT.RollNo
LEFT JOIN SOCIETY ON ENROLLMENT.SID = SOCIETY.SocID;
```

16. Find names of students who are enrolled in any of the three societies ‘Debating’, ‘Dancing’ and ‘Sashakt’.
```sql
SELECT DISTINCT StudentName 
FROM STUDENT 
INNER JOIN ENROLLMENT ON STUDENT.RollNo = ENROLLMENT.RollNo
INNER JOIN SOCIETY ON ENROLLMENT.SID = SOCIETY.SocID
WHERE SOCIETY.SocName IN ('Debating', 'Dancing', 'Sashakt');
```

Let me know if you want to continue with the remaining queries!
Sure, here are the remaining queries:

17. Find society names such that its mentor has a name with ‘Gupta’ in it.
```sql
SELECT SocName 
FROM SOCIETY 
WHERE MentorName LIKE '%Gupta%';
```

18. Find the society names in which the number of enrolled students is only 10% of its capacity.
```sql
SELECT SocName 
FROM SOCIETY 
WHERE SID IN (SELECT SID FROM ENROLLMENT GROUP BY SID HAVING COUNT(*) = 0.1 * TotalSeats);
```

19. Display the vacant seats for each society.
```sql
SELECT SocName, TotalSeats - COUNT(RollNo) AS VacantSeats 
FROM SOCIETY 
LEFT JOIN ENROLLMENT ON SOCIETY.SocID = ENROLLMENT.SID 
GROUP BY SocName;
```

20. Increment Total Seats of each society by 10%.
```sql
UPDATE SOCIETY 
SET TotalSeats = TotalSeats * 1.1;
```

21. Add the enrollment fees paid (‘yes’/’No’) field in the enrollment table.
```sql
ALTER TABLE ENROLLMENT 
ADD EnrollmentFeesPaid ENUM('yes', 'no');
```

22. Update date of enrollment of society id ‘s1’ to ‘2018-01-15’, ‘s2’ to current date and ‘s3’ to ‘2018-01-02’.
```sql
UPDATE ENROLLMENT 
SET DateOfEnrollment = '2018-01-15' 
WHERE SID = 's1';

UPDATE ENROLLMENT 
SET DateOfEnrollment = CURRENT_DATE() 
WHERE SID = 's2';

UPDATE ENROLLMENT 
SET DateOfEnrollment = '2018-01-02' 
WHERE SID = 's3';
```

23. Create a view to keep track of society names with the total number of students enrolled in it.
```sql
CREATE VIEW SocietyEnrollment AS
SELECT SocName, COUNT(RollNo) AS TotalEnrolled
FROM SOCIETY
LEFT JOIN ENROLLMENT ON SOCIETY.SocID = ENROLLMENT.SID
GROUP BY SocName;
```

24. Find student names enrolled in all the societies.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE RollNo IN (SELECT RollNo FROM ENROLLMENT GROUP BY RollNo HAVING COUNT(DISTINCT SID) = (SELECT COUNT(*) FROM SOCIETY));
```

25. Count the number of societies with more than 5 students enrolled in it.
```sql
SELECT COUNT(*) 
FROM (SELECT SID FROM ENROLLMENT GROUP BY SID HAVING COUNT(*) > 5) AS SocietyCount;
```

26. Add column Mobile number in student table with default value ‘9999999999’.
```sql
ALTER TABLE STUDENT 
ADD MobileNumber CHAR(10) DEFAULT '9999999999';
```

27. Find the total number of students whose age is > 20 years.
```sql
SELECT COUNT(*) 
FROM STUDENT 
WHERE TIMESTAMPDIFF(YEAR, DOB, CURDATE()) > 20;
```

28. Find names of students who are born in 2001 and are enrolled in at least one society.
```sql
SELECT StudentName 
FROM STUDENT 
WHERE YEAR(DOB) = 2001 AND RollNo IN (SELECT RollNo FROM ENROLLMENT);
```

29. Count all societies whose name starts with ‘S’ and ends with ‘t’ and at least 5 students are enrolled in the society.
```sql
SELECT COUNT(*) 
FROM (SELECT SocID FROM SOCIETY WHERE SocName LIKE 'S%t' GROUP BY SocID HAVING COUNT(*) >= 5) AS SocietyCount;
```

30. Display the following information:
   Society name | Mentor name | Total Capacity | Total Enrolled | Unfilled Seats
```sql
SELECT SOCIETY.SocName, SOCIETY.MentorName, SOCIETY.TotalSeats, COUNT(ENROLLMENT.RollNo) AS TotalEnrolled, SOCIETY.TotalSeats - COUNT(ENROLLMENT.RollNo) AS UnfilledSeats
FROM SOCIETY
LEFT JOIN ENROLLMENT ON SOCIETY.SocID = ENROLLMENT.SID
GROUP BY SOCIETY.SocID;
```

That should cover all the queries! Let me know if you need further assistance!

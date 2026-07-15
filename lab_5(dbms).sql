--  DATABASE RESET
-- ===============================
DROP DATABASE IF EXISTS UniversityBD;
CREATE DATABASE UniversityBD;
USE UniversityBD;

-- ===============================
-- 1. CLEANUP (Safety Order)
-- ===============================
DROP TABLE IF EXISTS prereq;
DROP TABLE IF EXISTS advisor;
DROP TABLE IF EXISTS takes;
DROP TABLE IF EXISTS teaches;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS department;

-- ===============================
-- 2. DDL (TABLE CREATION)
-- ===============================

CREATE TABLE department (
    dept_name VARCHAR(20) PRIMARY KEY,
    building VARCHAR(15),
    budget DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE instructor (
    ID VARCHAR(5) PRIMARY KEY,
    name VARCHAR(20),
    dept_name VARCHAR(20),
    salary DECIMAL(8,2),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
) ENGINE=InnoDB;

CREATE TABLE student (
    ID VARCHAR(5) PRIMARY KEY,
    name VARCHAR(20),
    dept_name VARCHAR(20),
    tot_cred DECIMAL(3,0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
) ENGINE=InnoDB;

CREATE TABLE course (
    course_id VARCHAR(8) PRIMARY KEY,
    title VARCHAR(50),
    dept_name VARCHAR(20),
    credits DECIMAL(2,0),
    FOREIGN KEY (dept_name) REFERENCES department(dept_name)
) ENGINE=InnoDB;

CREATE TABLE section (
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    building VARCHAR(15),
    room_number VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course(course_id)
) ENGINE=InnoDB;

CREATE TABLE teaches (
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES instructor(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
) ENGINE=InnoDB;

CREATE TABLE takes (
    ID VARCHAR(5),
    course_id VARCHAR(8),
    sec_id VARCHAR(8),
    semester VARCHAR(6),
    year DECIMAL(4,0),
    grade VARCHAR(2),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES student(ID),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
) ENGINE=InnoDB;

CREATE TABLE advisor (
    s_ID VARCHAR(5) PRIMARY KEY,
    i_ID VARCHAR(5),
    FOREIGN KEY (s_ID) REFERENCES student(ID),
    FOREIGN KEY (i_ID) REFERENCES instructor(ID)
) ENGINE=InnoDB;

CREATE TABLE prereq (
    course_id VARCHAR(8),
    prereq_id VARCHAR(8),
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (prereq_id) REFERENCES course(course_id)
) ENGINE=InnoDB;

-- ===============================
-- 3. DML (INSERT DATA)
-- ===============================

-- Departments (ALL required)
INSERT INTO department VALUES
('Comp. Sci.', 'Taylor', 100000),
('Biology', 'Watson', 90000),
('Elec. Eng.', 'Taylor', 85000),
('History', 'Painter', 50000),
('Finance', 'Painter', 120000),
('Physics', 'Newton', 95000);

-- Instructors
INSERT INTO instructor VALUES
('10101', 'Srinivasan', 'Comp. Sci.', 65000),
('12121', 'Wu', 'Finance', 90000),
('22222', 'Einstein', 'Physics', 95000),
('32343', 'El Said', 'History', 60000),
('45565', 'Katz', 'Comp. Sci.', 75000),
('58583', 'Califieri', 'History', 62000),
('76543', 'Singh', 'Finance', 80000),
('98345', 'Kim', 'Elec. Eng.', 80000);

-- Courses
INSERT INTO course VALUES
('CS-101', 'Intro to CS', 'Comp. Sci.', 4),
('CS-315', 'Robotics', 'Comp. Sci.', 3),
('CS-347', 'Db Systems', 'Comp. Sci.', 3),
('EE-181', 'Intro to Digital Systems', 'Elec. Eng.', 3),
('BIO-101', 'Intro to Bio', 'Biology', 3),
('HIS-351', 'World History', 'History', 3);

-- Sections
INSERT INTO section VALUES
('CS-101', '1', 'Fall', 2024, 'Taylor', '3128', 'A'),
('CS-347', '1', 'Fall', 2024, 'Taylor', '3128', 'A'),
('CS-101', '1', 'Spring', 2025, 'Packard', '101', 'B'),
('CS-315', '1', 'Spring', 2025, 'Taylor', '3128', 'B'),
('BIO-101', '1', 'Summer', 2025, 'Painter', '514', 'C');

-- Teaches
INSERT INTO teaches VALUES
('10101', 'CS-101', '1', 'Fall', 2024),
('10101', 'CS-347', '1', 'Fall', 2024),
('10101', 'CS-101', '1', 'Spring', 2025),
('45565', 'CS-315', '1', 'Spring', 2025);

-- Students
INSERT INTO student VALUES
('00128', 'Zhang', 'Comp. Sci.', 102),
('12345', 'Shankar', 'Comp. Sci.', 32),
('54321', 'Williams', 'Comp. Sci.', 54),
('76543', 'Brown', 'Comp. Sci.', 58),
('98988', 'Tanaka', 'Biology', 120);

-- Takes
INSERT INTO takes VALUES
('00128', 'CS-101', '1', 'Fall', 2024, 'A'),
('00128', 'CS-347', '1', 'Fall', 2024, 'A-'),
('12345', 'CS-101', '1', 'Fall', 2024, 'C');

-- Advisor
INSERT INTO advisor VALUES ('00128', '10101');

-- Prerequisite
INSERT INTO prereq VALUES ('CS-315', 'CS-101');

-- Section A --
SELECT name
from instructor
where name like '%an%';

SELECT ID,Course_id
FROM takes
WHERE grade is NULL;

 SELECT dept_name, COUNT(*) AS total_instructor
 FROM instructor
 GROUP BY dept_name;
 
  SELECT dept_name,AVG(salary) AS avg_salary
  FROM instructor
  GROUP BY dept_name;

SELECT dept_name
FROM instructor
GROUP BY dept_name
HAVING AVG(salary) >70000;

-- Section B --

SELECT course_id
FROM section
WHERE semester = 'Fall'
AND year = 2024
INTERSECT
SELECT course_id
FROM section
WHERE semester = 'Spring'
AND year = 2025;


SELECT course_id
FROM section
WHERE semester = 'Fall'
AND year = 2024
EXCEPT
SELECT course_id
FROM section
WHERE semester = 'Spring'
AND year = 2025;


SELECT name
FROM instructor
UNION
SELECT name
FROM student;


 --- Section C---
 SELECT name
FROM instructor
WHERE salary >
(
    SELECT AVG(salary)
    FROM instructor
);


SELECT name
FROM instructor
WHERE salary > SOME
(
    SELECT salary
    FROM instructor
    WHERE dept_name = 'Biology'
);



SELECT name
FROM student
WHERE ID IN
(
    SELECT ID
    FROM takes
    WHERE course_id = 'CS-101'
);


 --- section D---
 
INSERT INTO instructor (ID, name, dept_name, salary)
VALUES ('99999', 'Mozart', 'Music', 50000);


INSERT INTO department (dept_name, building, budget)
VALUES ('Music', 'Watson', 100000);


UPDATE instructor
SET salary = salary * 1.05
WHERE dept_name = 'Comp. Sci.';


DELETE FROM student
WHERE tot_cred < 40;



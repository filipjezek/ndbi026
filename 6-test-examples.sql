-- author: Filip Ježek (44432378)

-- Test examples
-- please fill the database with provided mock data first

-- create a new study programme
DECLARE @pid INT = NULL;
EXECUTE create_programme 'Artificial intelligence', @pid OUTPUT;

-- add some required subjects
DECLARE @sid INT = NULL;
SELECT @sid = id
FROM subjects
WHERE name = 'Mathematical analysis 2';
EXECUTE add_required_subject @pid, @sid;

SELECT @sid = id
FROM subjects
WHERE name = 'Programming in C#';
EXECUTE add_required_subject @pid, @sid;

-- create a new subject and add it too
INSERT INTO subjects
  (name, credits)
VALUES
  ('Machine learning for beginners', 5);
SELECT @sid = SCOPE_IDENTITY();
EXECUTE add_required_subject @pid, @sid;

-- the programme should not be visible among available programmes yet,
-- because its subjects are not taught in the current year
SELECT *
FROM VW_available_programmes;

-- create instances for the new subject
-- (teacher, subject, capacity, OUT id)
DECLARE @iid INT = NULL;
EXECUTE create_subject_instance 17, @sid, 30, @iid OUTPUT;
EXECUTE create_subject_instance 18, @sid, NULL, @iid OUTPUT;

-- add another teacher to teach the second instance
DECLARE @tid INT = NULL;
-- (salary, name, birth_date, city, street, postal_code, OUT id)
EXECUTE add_teacher 39000, 'Tomáš Příklep', '1978-09-09', 'Prague', 'Třešňová 52', 11400, @tid OUTPUT;
-- see him among teachers
EXECUTE add_instance_teacher @tid, @iid;
SELECT *
FROM VW_teachers;

-- the programme should now be visible among available programmes
SELECT *
FROM VW_available_programmes;

-- create a new student
DECLARE @stud INT = NULL;
-- (name, birth_date, city, street, postal_code, OUT id)
EXECUTE add_student 'Jan Otloukal', '2000-04-12', 'Prague', 'Slabá 123', '10900', @stud OUTPUT;
-- see him among students
SELECT *
FROM VW_students;

-- view available subjects
SELECT *
FROM VW_subject_enrollment;

-- enroll in previously created subject instance
-- error: the student is not enrolled in any programme yet
-- EXECUTE enroll_subject @stud, @iid;
-- enroll in the new programme
EXECUTE enroll_programme @stud, @pid;
EXECUTE enroll_subject @stud, @iid;

-- enroll in some other subject instances
EXECUTE enroll_subject @stud, 23;
EXECUTE enroll_subject @stud, 18;
EXECUTE enroll_subject @stud, 2;

SELECT *
FROM VW_timetable
WHERE student = @stud;

-- try to graduate
-- error: student has not completed the required subjects
-- EXECUTE graduate @stud, @pid;
-- view the programme progress
SELECT *
FROM VW_student_programme
WHERE student = @stud;

EXECUTE finish_subject @stud, @iid, 1;
EXECUTE finish_subject @stud, 2, 2;
EXECUTE finish_subject @stud, 23, 4;
EXECUTE finish_subject @stud, 18, 3;

-- error: student has still not completed the required subjects
-- EXECUTE graduate @stud, @pid;
-- view the programme progress
SELECT *
FROM VW_student_programme
WHERE student = @stud;

-- enroll in another instance of MA2 and complete it
EXECUTE enroll_subject @stud, 22;
EXECUTE finish_subject @stud, 22, 3;
-- SELECT dbo.can_graduate(@stud, @pid);
SELECT *
FROM VW_student_programme
WHERE student = @stud;

EXECUTE graduate @stud, @pid;

-- enroll in another programme, then drop it
EXECUTE enroll_programme @stud, 1;
EXECUTE enroll_subject @stud, 4;
SELECT *
FROM VW_student_programme
WHERE student = @stud;
EXECUTE drop_subject @stud, 4;
EXECUTE drop_programme @stud, 1;
SELECT *
FROM VW_student_programme
WHERE student = @stud;

-- check utilization and popularity of teacher 17
SELECT *
FROM VW_teacher_popularity
WHERE id = 17;
SELECT *
FROM VW_teacher_utilization
WHERE id = 17;
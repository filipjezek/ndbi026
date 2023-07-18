-- author: Filip Ježek (44432378)

CREATE VIEW VW_students AS
  SELECT p.*
  FROM people p
    JOIN students s ON s.id = p.id;
GO

CREATE VIEW VW_teachers AS
  SELECT p.*, t.salary
  FROM people p
    JOIN teachers t ON t.id = p.id;
GO

-- timetable usable by both students and teachers (by filtering based on either student id or teacher id)
CREATE VIEW VW_timetable AS
  SELECT
    ss.student,
    stud.personal_number AS student_personal_number,
    s.id AS subject_id,
    s.code AS subject_code,
    s.name AS subject,
    t.name AS teacher,
    t.id AS teacher_id
  FROM
    subjects s
    JOIN subject_instances si ON si.instanceof = s.id
    JOIN students_subjects ss ON ss.subject = si.id
    JOIN teachers_subjects ts ON ts.subject = si.id
    JOIN people t ON ts.teacher = t.id
    JOIN people stud ON ss.student = stud.id
  WHERE
  si.year = YEAR(GETDATE());
GO

-- student's progress in the programmes he is enrolled in
CREATE VIEW VW_student_programme AS
  SELECT
    sp.student,
    p.id AS programme_id,
    p.name AS programme,
    p.code,
    s.name AS subject,
    CASE
      WHEN MIN(COALESCE(stud_results.grade, 4)) < 4 THEN 1
      ELSE 0
    END AS passed
  FROM
    students_programmes sp
    JOIN programmes p ON sp.programme = p.id
    JOIN programme_required pr ON p.id = pr.programme
    JOIN subjects s ON pr.subject = s.id
    LEFT JOIN (
      SELECT si.instanceof, ss.student, ss.grade
      FROM subject_instances si
        JOIN students_subjects ss ON si.id = ss.subject
    ) stud_results ON stud_results.instanceof = s.id AND
      stud_results.student = sp.student
  GROUP BY sp.student, s.id, p.id,
    p.name, p.code, s.name;
GO

-- subjects and their availability for enrollment
CREATE VIEW VW_subject_enrollment AS
  SELECT si.id, si.capacity, s.name, s.code, COUNT(ss.id) AS enrolled
  FROM subject_instances si
    JOIN subjects s ON si.instanceof = s.id
    LEFT JOIN students_subjects ss ON si.id = ss.subject
  WHERE si.year = YEAR(GETDATE())
  GROUP BY si.id, si.capacity, s.name, s.code;
GO

-- listing of programmes that can be studied this year
CREATE VIEW VW_available_programmes AS
  SELECT p.id, p.name, p.code, s.name AS subject
  FROM programmes p
    JOIN programme_required pr ON p.id = pr.programme
    JOIN subjects s ON pr.subject = s.id
  WHERE EXISTS (
    SELECT * FROM subject_instances
    WHERE instanceof = s.id AND
      [year] = YEAR(GETDATE())
  );
GO

-- how many students choose this teacher
-- chosen = students studying his instances of a specific subject this year
-- total = students studying all instances of a specific subject this year
CREATE VIEW VW_teacher_popularity AS
  WITH tss (teacher, subject, student)
  AS (
    SELECT ts.teacher, s.id AS subject, ss.student
    FROM teachers_subjects ts
      JOIN subject_instances si ON si.id = ts.subject
      JOIN subjects s ON si.instanceof = s.id
      JOIN students_subjects ss ON ss.subject = si.id
  )
  SELECT t.id, t.name, t.personal_number,
    (SELECT COUNT(*) FROM tss WHERE teacher = t.id) AS chosen,
    (SELECT COUNT(*) FROM tss WHERE tss.subject IN (
      SELECT subject FROM tss WHERE tss.teacher = t.id
    )) AS total
  FROM VW_teachers t;
GO

-- teacher's salary and how many subject instances he teaches
CREATE VIEW VW_teacher_utilization AS
  SELECT t.id, t.personal_number, t.name, t.salary, COUNT(si.id) AS subjects
  FROM VW_teachers t
    LEFT JOIN teachers_subjects ts ON ts.teacher = t.id
    JOIN subject_instances si ON ts.subject = si.id
  WHERE si.year = YEAR(GETDATE())
  GROUP BY t.id, t.name, t.personal_number, t.salary;
GO


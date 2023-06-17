-- author: Filip Ježek (44432378)

DROP PROCEDURE add_required_subject;
DROP PROCEDURE create_programme;
DROP PROCEDURE add_instance_teacher;
DROP PROCEDURE create_subject_instance;
DROP PROCEDURE add_teacher;
DROP PROCEDURE add_student;
DROP PROCEDURE drop_programme;
DROP PROCEDURE graduate;
DROP PROCEDURE enroll_programme;
DROP FUNCTION can_graduate;
DROP PROCEDURE finish_subject;
DROP PROCEDURE drop_subject;
DROP PROCEDURE enroll_subject;

DROP VIEW VW_teacher_utilization;
DROP VIEW VW_teacher_popularity;
DROP VIEW VW_available_programmes;
DROP VIEW VW_subject_enrollment;
DROP VIEW VW_student_programme;
DROP VIEW VW_timetable;
DROP VIEW VW_teachers;
DROP VIEW VW_students;

DROP TABLE teachers_subjects;
DROP TABLE teachers;
DROP TABLE students_subjects;
DROP TABLE students_programmes;
DROP TABLE students;
DROP TABLE people;
DROP TABLE programme_required;
DROP TABLE subject_instances;
DROP TABLE subjects;
DROP TABLE programmes;
-- author: Filip Ježek (44432378)

UPDATE STATISTICS programmes;
UPDATE STATISTICS subjects;
UPDATE STATISTICS subject_instances;
UPDATE STATISTICS programme_required;
UPDATE STATISTICS people;
UPDATE STATISTICS students;
UPDATE STATISTICS students_programmes;
UPDATE STATISTICS students_subjects;
UPDATE STATISTICS teachers;
UPDATE STATISTICS teachers_subjects;

CREATE STATISTICS subject_instances_year ON subject_instances(year);
CREATE STATISTICS students_programmes_to ON students_programmes([to]);
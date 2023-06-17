-- author: Filip Ježek (44432378)

-- foreign key indices

CREATE INDEX IX_instanceof ON subject_instances(instanceof);
CREATE INDEX IX_student ON students_programmes(student);
CREATE INDEX IX_programme ON students_programmes(programme);
CREATE INDEX IX_subject ON programme_required(subject);
CREATE INDEX IX_programme ON programme_required(programme);
CREATE INDEX IX_subject ON students_subjects(subject);
CREATE INDEX IX_student ON students_subjects(student);
CREATE INDEX IX_teacher ON teachers_degrees(teacher);
CREATE INDEX IX_teacher ON teachers_subjects(teacher);
CREATE INDEX IX_subject ON teachers_subjects(subject);

-- used in views and triggers
CREATE INDEX IX_year ON subject_instances(year);
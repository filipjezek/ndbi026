-- author: Filip Ježek (44432378)

-- foreign key indices

CREATE INDEX IX_instanceof ON subject_instances(instanceof);
CREATE INDEX IX_student ON students_programmes(student);
CREATE INDEX IX_programme ON students_programmes(programme);

-- used in views and triggers
CREATE INDEX IX_year ON subject_instances(year);
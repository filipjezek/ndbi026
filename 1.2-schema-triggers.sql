-- author: Filip Ježek (44432378)

-- students must not attend a subject instance while not being enrolled in any programme
CREATE TRIGGER student_subject_programme ON students_subjects AFTER INSERT, UPDATE AS BEGIN
  IF (EXISTS(
    SELECT *
    FROM inserted i
      JOIN students_programmes sp ON i.student = sp.student
      JOIN subject_instances si ON i.subject = si.id
    WHERE YEAR(sp.since) > si.year OR sp.[to] IS NOT NULL OR YEAR(sp.[to]) < si.year
  )) BEGIN
    ROLLBACK TRANSACTION;
    THROW 60000, 'Student must be enrolled in a programme while attending a subject instance', 0;
  END;
END;
GO

-- students must not attend a subject which they already completed
CREATE TRIGGER student_subject_multiple ON students_subjects AFTER INSERT, UPDATE AS BEGIN
  IF (EXISTS(
    SELECT *
    FROM inserted i
      JOIN subject_instances si ON i.subject = si.id
      JOIN subject_instances si2 ON si.id != si2.id AND si.instanceof = si2.instanceof
      JOIN students_subjects ss ON si2.id = ss.subject
    WHERE ss.grade IN (1, 2, 3)
  )) BEGIN
    ROLLBACK TRANSACTION;
    THROW 60005, 'Student cannot attend any already completed subject', 0;
  END;
END;
GO

-- students must not enroll in a programme before they were born
CREATE TRIGGER student_birthday_programme ON students_programmes AFTER INSERT, UPDATE AS BEGIN
  IF (EXISTS(
    SELECT *
    FROM inserted i
      JOIN people pe ON i.student = pe.id
    WHERE i.since < pe.birth_date
  )) BEGIN
    ROLLBACK TRANSACTION;
    THROW 60001, 'Student must be born in order to enroll in a programme', 0;
  END;
END;
GO

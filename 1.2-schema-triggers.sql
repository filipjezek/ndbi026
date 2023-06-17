-- author: Filip Ježek (44432378)

-- students must not attend a subject instance while not being enrolled in any programme
CREATE TRIGGER student_subject_programme ON students_subjects AFTER INSERT, UPDATE AS BEGIN
  IF (EXISTS(
    SELECT *
    FROM inserted i
      JOIN students_programmes sp ON i.student = sp.student
      JOIN subject_instances s ON i.subject = s.id
    WHERE YEAR(sp.since) > s.year OR sp.[to] IS NOT NULL OR YEAR(sp.[to]) < s.year
  )) BEGIN
    ROLLBACK TRANSACTION;
    THROW 60000, 'Student must be enrolled in a programme while attending a subject instance', 0;
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

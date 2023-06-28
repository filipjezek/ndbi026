-- author: Filip Ježek (44432378)

CREATE PROCEDURE enroll_subject
  @id_student INT,
  @id_instance INT
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      IF (NOT EXISTS(
        SELECT * FROM VW_subject_enrollment
        WHERE id = @id_instance AND (capacity IS NULL OR enrolled < capacity)
      )) THROW 60002, 'Subject instance does not exist in the current year or is full', 0;

      IF (NOT EXISTS(SELECT * FROM students WHERE id = @id_student))
        THROW 60003, 'Student does not exist', 0;

      INSERT INTO students_subjects (student, subject) VALUES (@id_student, @id_instance);
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

-- removes student from a subject
CREATE PROCEDURE drop_subject
  @id_student INT,
  @id_instance INT
AS
  IF (NOT EXISTS(
    SELECT * FROM students_subjects
    WHERE student = @id_student AND subject = @id_instance AND grade IS NULL
  )) THROW 60004, 'Student is not enrolled in this subject instance or he completed the subject instance', 0;

  DELETE FROM students_subjects WHERE student = @id_student AND subject = @id_instance;
GO

CREATE PROCEDURE finish_subject
  @id_student INT,
  @id_instance INT,
  @grade TINYINT
AS
  IF (NOT EXISTS(
    SELECT * FROM students_subjects
    WHERE student = @id_student AND subject = @id_instance
  )) THROW 60004, 'Student is not enrolled in this subject instance', 0;

  UPDATE students_subjects SET grade = @grade
  WHERE student = @id_student AND subject = @id_instance;
GO

CREATE FUNCTION can_graduate (
  @id_student INT,
  @id_programme INT
)
RETURNS BIT AS BEGIN
  IF (NOT EXISTS(
    SELECT * FROM students_programmes
    WHERE student = @id_student AND programme = @id_programme
  )) RETURN 0;

  IF (EXISTS(
    SELECT * FROM VW_student_programme
    WHERE student = @id_student AND programme_id = @id_programme AND passed = 0
  )) RETURN 0;
  RETURN 1;
END;
GO

CREATE PROCEDURE enroll_programme
  @id_student INT,
  @id_programme INT
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      IF (NOT EXISTS(
        SELECT * FROM programmes
        WHERE id = @id_programme
      )) THROW 60006, 'Programme does not exist', 0;

      IF (EXISTS(
        SELECT * FROM students_programmes
        WHERE programme = @id_programme AND
          student = @id_student AND
          ([to] IS NULL OR dbo.can_graduate(@id_student, @id_programme) = 1)
      )) THROW 60007, 'Student either already is enrolled in the programme or has graduated it in the past', 0;

      INSERT INTO students_programmes (student, programme, since, [to])
      VALUES (@id_student, @id_programme, GETDATE(), NULL);
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

CREATE PROCEDURE graduate
  @id_student INT,
  @id_programme INT
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      IF (NOT EXISTS(
        SELECT * FROM students_programmes
        WHERE programme = @id_programme AND
          student = @id_student AND
          [to] IS NULL AND dbo.can_graduate(@id_student, @id_programme) = 1
      )) THROW 60009, 'Student cannot graduate this programme', 0;

      UPDATE students_programmes SET [to] = GETDATE()
      WHERE programme = @id_programme AND student = @id_student AND [to] IS NULL;
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

-- removes student from a programme
CREATE PROCEDURE drop_programme
  @id_student INT,
  @id_programme INT
AS
  IF (NOT EXISTS(
    SELECT * FROM students_programmes
    WHERE student = @id_student AND programme = @id_programme
  )) THROW 60008, 'Student is not enrolled in this programme', 0;

  DELETE FROM students_programmes WHERE student = @id_student AND programme = @id_programme;
GO

CREATE PROCEDURE add_student
  @name NVARCHAR(100),
  @birth_date DATE,
  @city NVARCHAR(100),
  @street NVARCHAR(100),
  @postal_code CHAR(5),
  @id_student INT OUT
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      INSERT INTO people (name, birth_date, city, street, postal_code)
        VALUES (@name, @birth_date, @city, @street, @postal_code);
      
      SELECT @id_student = SCOPE_IDENTITY();
      INSERT INTO students (id) VALUES (@id_student);
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

CREATE PROCEDURE add_teacher
  @salary INT,
  @name NVARCHAR(100),
  @birth_date DATE,
  @city NVARCHAR(100),
  @street NVARCHAR(100),
  @postal_code CHAR(5),
  @id_teacher INT OUT
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      INSERT INTO people (name, birth_date, city, street, postal_code)
        VALUES (@name, @birth_date, @city, @street, @postal_code);
      
      SELECT @id_teacher = SCOPE_IDENTITY();
      INSERT INTO teachers (id, salary) VALUES (@id_teacher, @salary);
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

CREATE PROCEDURE create_subject_instance (
  @id_teacher INT,
  @id_subject INT,
  @capacity INT,
  @id_instance INT OUT
)
AS
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  BEGIN TRANSACTION;
    BEGIN TRY
      IF (NOT EXISTS(SELECT * FROM teachers WHERE id = @id_teacher))
        THROW 60010, 'Teacher does not exist', 0;
      IF (NOT EXISTS(SELECT * FROM subjects WHERE id = @id_subject))
        THROW 60011, 'Subject does not exist', 0;
      INSERT INTO subject_instances (year, capacity, instanceof)
        VALUES (YEAR(GETDATE()), @capacity, @id_subject);

      SELECT @id_instance = SCOPE_IDENTITY();
      INSERT INTO teachers_subjects (teacher, subject) VALUES (@id_teacher, @id_instance);
    END TRY
    BEGIN CATCH
      IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;
      THROW;
    END CATCH
  COMMIT;
GO

CREATE PROCEDURE add_instance_teacher
  @id_teacher INT,
  @id_instance INT
AS
  IF (NOT EXISTS(SELECT * FROM teachers WHERE id = @id_teacher))
    THROW 60010, 'Teacher does not exist', 0;
  IF (NOT EXISTS(SELECT * FROM subject_instances WHERE id = @id_instance AND year = YEAR(GETDATE())))
    THROW 60012, 'Subject instance does not exist in the current year', 0;
  INSERT INTO teachers_subjects (teacher, subject) VALUES (@id_teacher, @id_instance)
GO

CREATE PROCEDURE create_programme
  @name NVARCHAR(100),
  @id_programme INT OUT
AS
  INSERT INTO programmes (name) VALUES (@name);
  SELECT @id_programme = SCOPE_IDENTITY();
GO

CREATE PROCEDURE add_required_subject
  @id_programme INT,
  @id_subject INT
AS
  IF (NOT EXISTS(
    SELECT * FROM programmes
    WHERE id = @id_programme
  )) THROW 60006, 'Programme does not exist', 0;

  IF (NOT EXISTS(SELECT * FROM subjects WHERE id = @id_subject))
    THROW 60011, 'Subject does not exist', 0;
  
  INSERT INTO programme_required (programme, subject)
  VALUES (@id_programme, @id_subject);
GO
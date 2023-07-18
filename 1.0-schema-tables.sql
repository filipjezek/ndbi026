-- author: Filip Ježek (44432378)

/*
Specification:

Student Information System
--------------------------

SIS is a system for university students and employees. It is possible to enroll in various subjects and programmes,
as well as create them and even graduate.

Please see the provided ER diagram for explanation of the semantic schema.

Procedures and views are explained (if neccessary) in their respective files.

*/

CREATE TABLE programmes
(
  id INT PRIMARY KEY IDENTITY,
  code CHAR(4) NOT NULL UNIQUE,
  name NVARCHAR(100) NOT NULL
);
CREATE TABLE subjects
(
  id INT PRIMARY KEY IDENTITY,
  code CHAR(4) NOT NULL UNIQUE,
  name NVARCHAR(100) NOT NULL,
  credits INT NOT NULL CHECK (credits > 0)
);
CREATE TABLE subject_instances
(
  id INT PRIMARY KEY IDENTITY,
  code CHAR(6) NOT NULL UNIQUE,
  year INT NOT NULL,
  capacity INT CHECK (capacity IS NULL OR CAPACITY > 0),
  instanceof INT NOT NULL REFERENCES subjects(id)
);
CREATE TABLE programme_required
(
  id INT PRIMARY KEY IDENTITY,
  subject INT NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
  programme INT NOT NULL REFERENCES programmes(id) ON DELETE CASCADE,
  UNIQUE(subject, programme)
)

CREATE TABLE people
(
  id INT PRIMARY KEY IDENTITY,
  personal_number CHAR(10) NOT NULL UNIQUE,
  name NVARCHAR(100) NOT NULL,
  birth_date DATE NOT NULL,
  city NVARCHAR(100),
  street NVARCHAR(100),
  postal_code CHAR(5),
);

CREATE TABLE students
(
  id INT PRIMARY KEY REFERENCES people(id) ON DELETE CASCADE
);
CREATE TABLE students_programmes
(
  id INT PRIMARY KEY IDENTITY,
  student INT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  programme INT NOT NULL REFERENCES programmes(id),
  since DATE NOT NULL,
  [to] DATE,
  CHECK ([to] IS NULL OR since <= [to])
);
CREATE TABLE students_subjects
(
  id INT PRIMARY KEY IDENTITY,
  subject INT NOT NULL REFERENCES subject_instances(id),
  student INT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  grade SMALLINT CHECK (grade IS NULL OR (grade > 0 AND grade < 5)),
  UNIQUE(student, subject)
);

CREATE TABLE teachers
(
  id INT PRIMARY KEY REFERENCES people(id) ON DELETE CASCADE,
  salary INT NOT NULL CHECK (salary > 0)
);
CREATE TABLE teachers_subjects
(
  id INT PRIMARY KEY IDENTITY,
  teacher INT NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  subject INT NOT NULL REFERENCES subject_instances(id),
  UNIQUE(teacher, subject)
);
-- author: Filip Ježek (44432378)

CREATE TABLE programmes
(
  id INT PRIMARY KEY IDENTITY,
  name NVARCHAR(100) NOT NULL
);
CREATE TABLE subjects
(
  id INT PRIMARY KEY IDENTITY,
  name NVARCHAR(100) NOT NULL
);
CREATE TABLE subject_instances
(
  id INT PRIMARY KEY IDENTITY,
  year INT NOT NULL,
  instanceof INT NOT NULL REFERENCES subjects(id)
);

CREATE TABLE people
(
  id INT PRIMARY KEY IDENTITY,
  name NVARCHAR(100) NOT NULL,
  birth_date DATE NOT NULL
);

CREATE TABLE students
(
  id INT PRIMARY KEY REFERENCES people(id)
);
CREATE TABLE students_programmes
(
  id INT PRIMARY KEY IDENTITY,
  student INT NOT NULL REFERENCES students(id),
  programme INT NOT NULL REFERENCES programmes(id),
  since DATE NOT NULL,
  [to] DATE,
  CHECK ([to] IS NULL OR since < [to])
);
CREATE TABLE students_subjects
(
  id INT PRIMARY KEY IDENTITY,
  subject INT NOT NULL REFERENCES subject_instances(id),
  student INT NOT NULL REFERENCES students(id),
  UNIQUE(student, subject)
);

CREATE TABLE teachers
(
  id INT PRIMARY KEY REFERENCES people(id),
  salary INT NOT NULL CHECK (salary > 0)
);
CREATE TABLE teachers_degrees
(
  id INT PRIMARY KEY IDENTITY,
  teacher INT NOT NULL REFERENCES teachers(id),
  degree NVARCHAR(10) NOT NULL,
  UNIQUE(teacher, degree)
);
CREATE TABLE teachers_subjects
(
  id INT PRIMARY KEY IDENTITY,
  teacher INT NOT NULL REFERENCES teachers(id),
  subject INT NOT NULL REFERENCES subject_instances(id),
  UNIQUE(teacher, subject)
);
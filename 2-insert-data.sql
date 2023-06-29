-- author: Filip Ježek (44432378)

DELETE FROM teachers_subjects;
DELETE FROM teachers;
DELETE FROM students_subjects;
DELETE FROM students_programmes;
DELETE FROM students;
DELETE FROM people;
DELETE FROM programme_required;
DELETE FROM subject_instances;
DELETE FROM subjects;
DELETE FROM programmes;

SET IDENTITY_INSERT programmes ON;
INSERT INTO programmes
  (id, name)
VALUES
  (1, 'Database and web'),
  (2, 'Programming and software development'),
  (3, 'Computer vision');
SET IDENTITY_INSERT programmes OFF;

SET IDENTITY_INSERT subjects ON;
INSERT INTO subjects
  (id, name, credits)
VALUES
  (1, 'Modern database systems', 4),
  (2, 'Data formats', 5),
  (3, 'Web services', 5),

  (4, 'Software system architectures', 5),
  (5, 'Software developments tools', 2),
  (6, 'Programming in C#', 3),

  (7, 'Mathematical analysis 2', 5),
  (8, 'Introduction to colour science', 3),
  (9, 'Video retrieval', 5);
SET IDENTITY_INSERT subjects OFF;

SET IDENTITY_INSERT subject_instances ON;
INSERT INTO subject_instances
  (id, year, capacity, instanceof)
VALUES
  (1, 2023, 60, 1),
  (2, 2023, NULL, 1),
  (3, 2023, 50, 2),
  (4, 2023, 80, 2),
  (5, 2022, 10, 2),
  (6, 2022, 60, 2),
  (7, 2023, NULL, 3),
  (8, 2022, 50, 3),
  (9, 2022, 70, 3),
  (10, 2023, 30, 4),
  (11, 2022, 60, 4),
  (12, 2022, 50, 4),
  (13, 2023, 10, 5),
  (14, 2022, 80, 5),
  (15, 2022, NULL, 5),
  (16, 2022, 40, 5),
  (17, 2022, 60, 6),
  (18, 2023, 10, 6),
  (19, 2023, NULL, 6),
  (20, 2022, 60, 7),
  (21, 2022, 30, 7),
  (22, 2023, 50, 7),
  (23, 2023, 60, 7),
  (24, 2022, 40, 8),
  (25, 2023, 50, 8),
  (26, 2023, 50, 9),
  (27, 2023, NULL, 9),
  (28, 2023, 10, 9),
  (29, 2023, 20, 9);
SET IDENTITY_INSERT subject_instances OFF;

SET IDENTITY_INSERT programme_required ON;
INSERT INTO programme_required
  (id, subject, programme)
VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1),
  (4, 4, 2),
  (5, 5, 2),
  (6, 6, 2),
  (7, 7, 3),
  (8, 8, 3),
  (9, 9, 3);
SET IDENTITY_INSERT programme_required OFF;

SET IDENTITY_INSERT people ON;
INSERT INTO people
  (id, name, birth_date, city, street, postal_code)
VALUES
  (1, 'Carlota Elloit', '1989-05-04', 'Shin’ichi', '35 Melvin Road', 47112),
  (2, 'Ansell Vampouille', '1979-11-10', 'Moppo', '9 Maywood Junction', 96772),
  (3, 'Horacio Dryden', '1980-09-27', 'Venlo', '9 Stang Drive', 65226),
  (4, 'Bartholomeus Feld', '2000-11-15', 'Lakkíon', '104 Southridge Terrace', 20972),
  (5, 'Christoffer Cocke', '1998-08-15', 'Paraná', '89 Burrows Circle', 19209),
  (6, 'Pamelina Bartali', '1991-12-27', 'Itapé', '45706 Helena Avenue', 88198),
  (7, 'Shalna Harbidge', '1987-11-16', 'Springfield', '20 Gateway Trail', 16093),
  (8, 'Reeba Mowsdill', '1980-11-19', 'Komysh-Zorya', '85 Golf Court', 67300),
  (9, 'Brannon Kelley', '1971-07-04', 'Lieksa', '2948 School Plaza', 16073),
  (10, 'Kelbee Iacovolo', '1989-06-02', 'Wugong', '9859 Onsgard Place', 36082),
  (11, 'Asia Zarb', '1982-09-21', 'Ad Dujayl', '7941 Lerdahl Point', 36402),
  (12, 'Cosmo Kenen', '1977-04-19', 'Telouet', '1 Surrey Avenue', 40068),
  (13, 'Bar Bispham', '1972-06-14', 'Poddębice', '016 Fremont Place', 88984),
  (14, 'Humfried Hegley', '1976-09-20', 'Bazha', '0 Lotheville Way', 64387),
  (15, 'Evangelia Palle', '1975-11-23', 'Szubin', '530 Cordelia Junction', 21133),
  (16, 'Craig Hatz', '1981-10-27', 'Sagarejo', '75723 Larry Plaza', 29315),
  (17, 'Nani Frigout', '1987-07-07', 'Pangligaran', '053 Dwight Street', 22155),
  (18, 'Bryant Vannah', '1980-12-05', 'Anju', '0963 Holy Cross Plaza', 32570),
  (19, 'Chlo Huston', '1998-11-25', 'Luhanka', '80 Lakewood Gardens Drive', 82185),
  (20, 'Lynnell Bleibaum', '1990-03-13', 'Qiangqinxue', '8 Daystar Plaza', 28612);
SET IDENTITY_INSERT people OFF;

INSERT INTO students
  (id)
VALUES
  (1),
  (2),
  (3),
  (4),
  (5),
  (6),
  (7),
  (8),
  (9),
  (10),
  (11),
  (12),
  (13),
  (14),
  (15),
  (16);

SET IDENTITY_INSERT students_programmes ON;
INSERT INTO students_programmes
  (id, student, programme, since, [to])
VALUES
  (1, 1, 3, '2011-05-01', '2015-02-23'),
  (2, 2, 1, '2012-06-19', '2022-08-19'),
  (3, 3, 1, '2014-09-28', NULL),
  (4, 4, 2, '2011-05-20', '2018-05-14'),
  (5, 5, 3, '2020-05-24', '2022-11-06'),
  (6, 6, 2, '2010-11-15', '2019-10-18'),
  (7, 7, 2, '2016-03-10', '2018-07-31'),
  (8, 8, 1, '2018-12-06', NULL),
  (9, 9, 1, '2019-07-16', '2023-01-15'),
  (10, 10, 2, '2020-10-13', NULL),
  (11, 11, 2, '2011-12-10', '2014-07-30'),
  (12, 11, 3, '2021-10-31', NULL),
  (13, 13, 3, '2015-12-17', NULL),
  (14, 14, 2, '2021-09-21', '2022-08-16'),
  (15, 15, 1, '2020-12-25', NULL),
  (16, 16, 2, '2010-09-08', '2013-11-18'),
  (17, 3, 2, '2019-09-27', NULL),
  (18, 10, 1, '2012-07-19', '2018-09-05'),
  (19, 15, 2, '2020-07-25', '2022-07-05'),
  (20, 2, 2, '2011-04-22', '2021-05-10');
SET IDENTITY_INSERT students_programmes OFF;

SET IDENTITY_INSERT students_subjects ON;
INSERT INTO students_subjects
  (id, subject, student, grade)
VALUES
  (1, 20, 13, 3),
  (2, 5, 15, 2),
  (3, 13, 15, 3),
  (4, 9, 15, NULL),
  (5, 26, 15, 2),
  (6, 28, 10, 4),
  (7, 16, 13, 1),
  (8, 8, 2, NULL),
  (9, 18, 9, NULL),
  (10, 15, 15, NULL),
  (11, 22, 15, NULL),
  (12, 24, 3, NULL),
  (13, 6, 9, 4),
  (14, 1, 13, NULL),
  (15, 17, 3, NULL),
  (16, 7, 11, 1),
  (17, 9, 8, NULL),
  (18, 24, 15, 3),
  (19, 3, 11, 1),
  (20, 16, 9, 2),
  (21, 20, 5, 2),
  (22, 2, 8, 3),
  (23, 11, 9, NULL),
  (24, 5, 2, NULL),
  (25, 28, 9, NULL),
  (26, 18, 3, 2),
  (27, 23, 10, NULL),
  (28, 11, 15, 3),
  (29, 21, 15, NULL),
  (30, 4, 13, 2),
  (31, 16, 15, NULL),
  (32, 9, 14, 2),
  (33, 21, 3, 1),
  (34, 15, 8, NULL),
  (35, 28, 8, 4),
  (36, 22, 11, NULL),
  (37, 16, 14, NULL),
  (38, 29, 8, NULL),
  (39, 19, 13, NULL),
  (40, 5, 5, 4),
  (41, 14, 3, NULL),
  (42, 2, 11, NULL),
  (43, 26, 13, 2),
  (44, 19, 15, 3),
  (45, 7, 10, NULL),
  (46, 12, 14, NULL),
  (47, 6, 8, NULL),
  (48, 23, 8, NULL);
SET IDENTITY_INSERT students_subjects OFF;

INSERT INTO teachers
  (id, salary)
VALUES
  (17, 40000),
  (18, 43000),
  (19, 38000),
  (20, 41000);

SET IDENTITY_INSERT teachers_subjects ON;
INSERT INTO teachers_subjects
  (id, teacher, subject)
VALUES
  (1, 20, 1),
  (2, 19, 2),
  (3, 18, 3),
  (4, 20, 4),
  (5, 19, 5),
  (6, 20, 6),
  (7, 20, 7),
  (8, 18, 8),
  (9, 20, 9),
  (10, 18, 10),
  (11, 20, 11),
  (12, 18, 12),
  (13, 19, 13),
  (14, 19, 14),
  (15, 19, 15),
  (16, 17, 16),
  (17, 18, 17),
  (18, 17, 18),
  (19, 19, 19),
  (20, 20, 20),
  (21, 18, 21),
  (22, 20, 22),
  (23, 19, 23),
  (24, 18, 24),
  (25, 19, 25),
  (26, 19, 26),
  (27, 20, 27),
  (28, 18, 28),
  (29, 18, 29),
  (30, 20, 2),
  (31, 19, 8),
  (32, 20, 16),
  (33, 20, 19),
  (34, 20, 23),
  (35, 18, 9);
SET IDENTITY_INSERT teachers_subjects OFF;

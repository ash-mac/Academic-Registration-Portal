INSERT INTO course_catalogue(course_id, title, dept_id, lec_hr, tut_hr, prac_hr, ss_hr, credits) VALUES ('EE101', 'Signals and Systems', 'ee', 3, 1, 1, 4, 3), ('HS101', 'Linguistics', 'cs', 3, 1, 0, 4, 3), ('MA222', 'Numerical Analysis', 'ma', 3, 1, 1, 7, 3), ('CS511', 'Computer Vision', 'cs', 3, 1, 3, 4, 4), ('CS103', 'Discrete Mathematical Structures', 'cs', 3, 1, 3, 8, 3), ('CS209', 'Data Structures and Algorithms', 'cs', 3, 1, 3, 4, 3), ('EE202', 'Networking', 'ee', 3, 1, 3, 4, 3), ('MA202', 'Differential Equations', 'ma', 3, 1, 0, 6, 4), ('CS532', 'Machine Learning', 'cs', 3, 1, 3, 4, 4), ('MA201', 'Linear Algebra', 'ma', 3, 1, 0, 9, 4), ('EE111', 'Semiconductor Devices', 'ee', 3, 1, 3, 4, 3), ('MA412', 'Complex Equations', 'ma', 3, 1, 3, 4, 4), ('HS102', 'Story Writing', 'ee', 3, 1, 3, 4, 3), ('CS202', 'Programming Paradigms', 'cs', 3, 1, 3, 4, 3), ('EE204', 'Power Functions', 'ee', 3, 1, 3, 4, 3), ('EE203', 'Jet Lag', 'ee', 3, 1, 3, 4, 3);

CREATE TABLE IF NOT EXISTS trans_2019csb1123
(
    year INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    course_id CHAR(5) NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    credits NUMERIC NOT NULL,
    grade NUMERIC NOT NULL
);
INSERT INTO trans_2019csb1123(year, sem, course_id, title, type, credits, grade) VALUES(1, 1, 'EE101', 'Signals and Systems', 'science_core', 3, 9), (1, 1, 'HS101', 'Linguistics', 'hs_core', 3, 8), (1, 1, 'MA222', 'Numerical Analysis', 'science_core', 3, 9), (1, 2, 'CS511', 'Computer Vision', 'science_core', 4, 8), (1, 2, 'CS103', 'Discrete Mathematical Structures', 'program_core', 3, 6), (2, 1, 'CS209', 'Data Structures and Algorithms', 'program_core', 3, 9), (2, 2, 'EE202', 'Networking', 3, 9, 'open_elective'), (2, 2, 'MA202', 'Differential Equations', 4, 8, 'open_elective'), (3, 1, 'CS532', 'Machine Learning', 4, 9, 'program_elective');

CREATE TABLE IF NOT EXISTS trans_2019mcb1223
(
    year INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    course_id CHAR(5) NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    credits NUMERIC NOT NULL,
    grade NUMERIC NOT NULL
);
INSERT INTO trans_2019mcb1223(year, sem, course_id, title, type, credits, grade) VALUES(1, 1, 'EE101', 'Signals and Systems', 'science_core', 3, 5), (1, 1, 'HS101', 'Linguistics', 'hs_core', 3, 8), (1, 1, 'MA222', 'Numerical Analysis', 'science_core', 3, 6), (1, 2, 'CS511', 'Computer Vision', 'science_core', 4, 6), (1, 2, 'CS103', 'Discrete Mathematical Structures', 'program_core', 3, 6), (2, 1, 'MA201', 'Linear Algebra', 'program_core', 4, 6), (2, 2, 'EE111', 'Semiconductor Devices', 'open_elective', 3, 7), (2, 2, 'MA202', 'Differential Equations', 'program_core', 4, 8), (3, 1, 'MA412', 'Complex Equations', 'program_elective', 4, 6);

CREATE TABLE IF NOT EXISTS trans_2019csb1088
(
    year INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    course_id CHAR(5) NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    credits NUMERIC NOT NULL,
    grade NUMERIC NOT NULL
);
INSERT INTO trans_2019csb1088(year, sem, course_id, title, type, credits, grade) VALUES(1, 1, 'EE101', 'Signals and Systems', 'science_core', 3, 7), (1, 1, 'HS101', 'Linguistics', 'hs_core', 3, 8), (1, 1, 'MA222', 'Numerical Analysis', 'science_core', 3, 8), (1, 2, 'CS511', 'Computer Vision', 'science_core', 4, 6), (1, 2, 'CS103', 'Discrete Mathematical Structures', 'program_core', 3, 7), (2, 1, 'CS209', 'Data Structures and Algorithms', 'program_core', 3, 0), (2, 2, 'EE202', 'Networking', 'open_elective', 3, 9), (2, 2, 'MA202', 'Differential Equations', 'open_elective', 4, 7), (3, 1, 'CS532', 'Machine Learning', 'program_elective', 4, 6);

CREATE TABLE IF NOT EXISTS trans_2020csb1069
(
    year INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    course_id CHAR(5) NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    credits NUMERIC NOT NULL,
    grade NUMERIC NOT NULL
);
INSERT INTO trans_2020csb1069(year, sem, course_id, title, type, credits, grade) VALUES(1, 1, 'EE101', 'Signals and Systems', 'science_core', 3, 10), (1, 1, 'HS102', 'Story Writing', 'hs_core', 3, 8), (1, 1, 'MA222', 'Numerical Analysis', 'science_core', 3, 9), (1, 2, 'CS511', 'Computer Vision', 'science_core', 4, 9), (1, 2, 'CS103', 'Discrete Mathematical Structures', 'program_core', 3, 10), (2, 1, 'CS202', 'Programming Paradigms', 'program_core', 3, 10), (2, 2, 'EE202', 'Networking', 'open_elective', 3, 9), (2, 2, 'MA202', 'Differential Equations', 'open_elective', 4, 10), (3, 1, 'CS532', 'Machine Learning', 'program_elective', 4, 9);

CREATE TABLE IF NOT EXISTS trans_2020eeb1165
(
    year INTEGER NOT NULL,
    sem INTEGER NOT NULL,
    course_id CHAR(5) NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    credits NUMERIC NOT NULL,
    grade NUMERIC NOT NULL
);
INSERT INTO trans_2020csb1069(year, sem, course_id, title, type, credits, grade) VALUES(1, 1, 'EE101', 'Signals and Systems', 'science_core', 3, 10), (1, 1, 'HS102', 'Story Writing', 'hs_core', 3, 8), (1, 1, 'MA222', 'Numerical Analysis', 'science_core', 3, 9), (1, 2, 'CS511', 'Computer Vision', 'science_core', 4, 9), (1, 2, 'EE204', 'Power Functions', 'program_core', 3, 7), (2, 1, 'EE203', 'Jet Lag', 'program_core', 3, 5), (2, 2, 'EE202', 'Networking', 'program_elective', 3, 9), (2, 2, 'MA202', 'Differential Equations', 'open_elective', 4, 10), (3, 1, 'CS532', 'Machine Learning', 'program_elective', 4, 9);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS btech_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --science_core or hs_core
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS btech_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --science_core or hs_core
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS cs_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program_core or program_elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS ma_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program_core or program_elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS ee_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS cs_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS ma_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS ee_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

INSERT INTO btech_2019(course_id, type) VALUES ('EE101', 'science_core'), ('HS101', 'hs_core'), ('MA222', 'science_core'), ('CS511', 'science_core');
INSERT INTO btech_2020(course_id, type) VALUES ('EE101', 'science_core'), ('HS102', 'hs_core'), ('MA222', 'science_core'), ('CS511', 'science_core');
INSERT INTO cs_2019(course_id, type) VALUES ('CS103', 'program_core'), ('CS209', 'program_core'), ('CS532', 'program_elective'), ('CS530', 'program_elective');
INSERT INTO cs_2020(course_id, type) VALUES ('CS103', 'program_core'), ('CS209', 'program_core'), ('CS202', 'program_core'), ('CS532', 'program_elective'), ('CS530', 'program_elective');
INSERT INTO ma_2019(course_id, type) VALUES ('CS103', 'program_core'), ('MA201', 'program_core'), ('MA202', 'program_core'), ('MA412', 'program_elective');
INSERT INTO ma_2020(course_id, type) VALUES ('CS103', 'program_core'), ('MA201', 'program_core'), ('MA202', 'program_core'), ('MA412', 'program_elective');
INSERT INTO ee_2020(course_id, type) VALUES ('EE203', 'program_core'), ('EE204', 'program_core'), ('EE202', 'program_elective'), ('CS532', 'program_elective');
INSERT INTO ee_2019(course_id, type) VALUES ('EE203', 'program_core'), ('EE204', 'program_core'), ('EE202', 'program_elective'), ('CS532', 'program_elective');


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

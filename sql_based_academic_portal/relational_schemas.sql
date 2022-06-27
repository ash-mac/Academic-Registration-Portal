CREATE TABLE IF NOT EXISTS departments
(
dept_id VARCHAR(10) PRIMARY KEY,
dept_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS faculty
(
fac_id VARCHAR(50) PRIMARY KEY,
fac_name text NOT NULL,
dept_id VARCHAR(10) NOT NULL,
FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS students
(
student_id CHAR(11) PRIMARY KEY,
student_name text NOT NULL,
dept_id VARCHAR(10) NOT NULL,
join_year INTEGER NOT NULL,
FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS batch_advisor
(
fac_id VARCHAR(50) NOT NULL,
dept_id VARCHAR(10) NOT NULL,
batch_yr INTEGER NOT NULL,
PRIMARY KEY(dept_id,batch_yr),
FOREIGN KEY(fac_id) REFERENCES faculty(fac_id),
FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS course_catalogue
(
course_id char(5) PRIMARY KEY,
title text NOT NULL,
dept_id VARCHAR(10) NOT NULL,
lec_hr numeric NOT NULL,
tut_hr numeric NOT NULL,
prac_hr numeric NOT NULL,
ss_hr numeric NOT NULL,
credits numeric NOT NULL,
FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS prerequisite
(
course_id char(5) NOT NULL,
prereq_id char(5) NOT NULL,
batches int[] NOT NULL DEFAULT '{}',
dept_allowed varchar(10)[] NOT NULL DEFAULT '{}',  
cgpa numeric CHECK (cgpa >= 0 and cgpa <= 10) NOT NULL DEFAULT 0,
PRIMARY KEY(course_id,prereq_id),
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
FOREIGN KEY(prereq_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS course_offering
(
course_id CHAR(5) NOT NULL,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
PRIMARY KEY(course_id,sem,year)
);

CREATE TABLE IF NOT EXISTS teaches
(
course_id char(5) NOT NULL,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
fac_id varchar(50) NOT NULL,
section_id integer NOT NULL DEFAULT 1,
PRIMARY KEY(course_id,sem,year,fac_id),
FOREIGN KEY(course_id,sem,year) REFERENCES course_offering(course_id,sem,year),
FOREIGN KEY(fac_id) REFERENCES faculty(fac_id)
);

CREATE TABLE IF NOT EXISTS slots
(
slot_id VARCHAR(10) PRIMARY KEY,
num_sect integer NOT NULL DEFAULT 1,
start_time CHAR(5) NOT NULL DEFAULT '00:00',
end_time CHAR(5) NOT NULL DEFAULT '00:00',
slot_type VARCHAR(10) NOT NULL DEFAULT 'lecture', --tut or class or lab or seminar
days char(3)[] NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS section_slot_info
(
course_id CHAR(5) NOT NULL,
slot_id VARCHAR(10) NOT NULL,
num_sect INTEGER NOT NULL DEFAULT 1,
sect_occupied INTEGER NOT NULL DEFAULT 0,
PRIMARY KEY(course_id),
FOREIGN KEY(slot_id) REFERENCES slots(slot_id),
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS tickets
(
ticket_id INTEGER NOT NULL PRIMARY KEY,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
course_id char(5) NOT NULL,
student_id char(11) NOT NULL,
cause text NOT NULL,
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
FOREIGN KEY(student_id) REFERENCES students(student_id)
);

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

CREATE TABLE IF NOT EXISTS CS_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program_core or program_elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS MA_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program_core or program_elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS EE_2019
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS CS_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS MA_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS EE_2020
(
course_id char(5) NOT NULL PRIMARY KEY,
type text NOT NULL, --program core or program elective
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
);

CREATE TABLE IF NOT EXISTS tickets_acads
(
    ticket_id integer NOT NULL PRIMARY KEY,
    sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
    year integer CHECK (year > 0) NOT NULL,
    course_id char(5) NOT NULL,
    student_id char(11) NOT NULL,
    cause text NOT NULL,
    fac_dec VARCHAR(3) NOT NULL,
    adv_dec VARCHAR(3) NOT NULL,
    acad_dec VARCHAR(3) NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
    FOREIGN KEY(ticket_id) REFERENCES tickets(ticket_id)
);

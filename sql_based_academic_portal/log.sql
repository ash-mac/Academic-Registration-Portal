create user acad with superuser createrole encrypted password 'password';
\c - acad
password
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
create or replace function enroll_faculty(facultyid varchar(50), fname text, deptid varchar(10))
returns void
language plpgsql
as
$$
declare
begin
insert into faculty
values(facultyid,fname,deptid);
end;
$$;

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
--CS --> cs
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

CREATE OR REPLACE FUNCTION faculty_reg()
RETURNS trigger
language plpgsql
as
$$
DECLARE
BEGIN
EXECUTE format('create user %I with encrypted password ''password'';',new.fac_id);
EXECUTE format('
CREATE TABLE IF NOT EXISTS %I
(
ticket_id INTEGER NOT NULL PRIMARY KEY,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
course_id char(5) NOT NULL,
student_id char(11) NOT NULL,
cause text NOT NULL,
fac_dec varchar(3) NOT NULL,
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(ticket_id) REFERENCES tickets(ticket_id)
);
'
, 'ticket_'||new.fac_id);
EXECUTE format('GRANT select on %I TO %I;','ticket_'||new.fac_id,new.fac_id);
EXECUTE format('GRANT insert on %I TO %I;','ticket_'||new.fac_id,new.fac_id);
EXECUTE format('GRANT update on %I TO %I;','ticket_'||new.fac_id,new.fac_id);

-- grant select permission to advisor later on the ticket_fac_id

EXECUTE format('GRANT select on batch_advisor, btech_2019,btech_2020, course_catalogue,tickets, course_offering, cs_2019,cs_2020,
                 departments, faculty, ma_2019, ma_2020, ee_2019, ee_2020, 
                 prerequisite, section_slot_info, slots, students, teaches TO %I;',new.fac_id);
EXECUTE format('GRANT insert on course_offering, section_slot_info, teaches TO %I;',new.fac_id);
EXECUTE format('GRANT update on section_slot_info, prerequisite TO %I;',new.fac_id);
EXECUTE format('GRANT pg_read_server_files TO %I;',new.fac_id);
RETURN NEW;
END;
$$;


 
CREATE TRIGGER faculty_reg_trigger
BEFORE INSERT
ON faculty
FOR EACH ROW
EXECUTE PROCEDURE faculty_reg();

CREATE OR REPLACE FUNCTION batch_advisor_reg()
RETURNS trigger
language plpgsql
as
$$
DECLARE
BEGIN
EXECUTE format('
CREATE TABLE IF NOT EXISTS %I
(
ticket_id INTEGER NOT NULL PRIMARY KEY,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
course_id char(5) NOT NULL,
student_id char(11) NOT NULL,
cause text NOT NULL,
fac_dec varchar(3) NOT NULL,
adv_dec varchar(3) NOT NULL,
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(ticket_id) REFERENCES tickets(ticket_id)
);
'
, 'ticket_advisor_'||new.fac_id);

EXECUTE format('GRANT select,insert,update on %I TO %I;','ticket_advisor_'||new.fac_id, new.fac_id);
RETURN NEW;
END;
$$;


 
CREATE TRIGGER advisor_reg_trigger
BEFORE INSERT
ON batch_advisor
FOR EACH ROW
EXECUTE PROCEDURE batch_advisor_reg();

create or replace function enroll_batch_advisor(facid varchar(50), deptid varchar(10), batchyr integer)
returns void
language plpgsql
as
$$
begin
insert into batch_advisor(fac_id,dept_id,batch_yr)
values(facid,deptid,batchyr);
end;
$$;

-- can be run only by acads
CREATE OR REPLACE FUNCTION student_reg()
RETURNS trigger
language plpgsql
as
$$
DECLARE
BEGIN
EXECUTE format('create user %I with encrypted password ''password'';',new.student_id);

EXECUTE format('CREATE TABLE IF NOT EXISTS %I 
(
year integer CHECK (year > 0) NOT NULL,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
course_id char(5) NOT NULL,
title text not null,
type text CHECK (type = ''hs_core'' or type = ''science_core'' or type = ''program_core'' or type = ''program_elective'' or type = ''open_elective'') NOT NULL,
credits numeric check(credits>0) not null,
grade integer check(grade>=0) default 0 not null,
PRIMARY KEY(year,sem,course_id),
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
)', 'trans_'||NEW.student_id);

EXECUTE format('CREATE TABLE IF NOT EXISTS %I 
(
year integer CHECK (year > 0) NOT NULL,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
course_id char(5) NOT NULL,
title text not null,
type text CHECK (type = ''hs_core'' or type = ''science_core'' or type = ''program_core'' or type = ''program_elective'' or type = ''open_elective'') NOT NULL,
credits numeric check(credits>0) not null,
PRIMARY KEY(year,sem,course_id),
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id)
)', 'register_'||NEW.student_id);

EXECUTE format('
CREATE TABLE IF NOT EXISTS %I
(
ticket_id INTEGER NOT NULL PRIMARY KEY,
sem integer CHECK (sem = 1 or sem = 2) NOT NULL,
year integer CHECK (year > 0) NOT NULL,
course_id char(5) NOT NULL,
student_id char(11) NOT NULL,
cause text NOT NULL,
fac_dec varchar(3) NOT NULL,
adv_dec varchar(3) NOT NULL,
acads_dec varchar(3) NOT NULL,
FOREIGN KEY(course_id) REFERENCES course_catalogue(course_id),
FOREIGN KEY(student_id) REFERENCES students(student_id),
FOREIGN KEY(ticket_id) REFERENCES tickets(ticket_id)
);
'
, 'ticket_'||new.student_id);
EXECUTE format('GRANT select on %I, %I, %I TO %I;','ticket_'||new.student_id,'register_'||new.student_id,'trans_'||new.student_id, new.student_id);
EXECUTE format('GRANT insert on %I, %I TO %I;','ticket_'||new.student_id,'register_'||new.student_id, new.student_id);
EXECUTE format('GRANT select on batch_advisor, btech_2019, btech_2020, 
                                                cs_2019, cs_2020, 
                                                ma_2019, ma_2020, 
                                                ee_2019, ee_2020, 
                                                course_catalogue, course_offering, 
                                                departments, faculty, 
                                                prerequisite, section_slot_info,
                                                slots, students, teaches TO %I;',new.student_id);
EXECUTE format('GRANT select,insert on tickets TO %I;',new.student_id);

RETURN NEW;
END;
$$;


 
CREATE TRIGGER student_reg_trigger
BEFORE INSERT
ON students
FOR EACH ROW
EXECUTE PROCEDURE student_reg();

create or replace function enroll_student(studentid char(11), sname text, dep_id varchar(10),join_year integer)
returns void
language plpgsql
as
$$
declare
begin
insert into students
values(studentid,sname,dep_id,join_year);
end;
$$;

INSERT INTO departments(dept_id,dept_name)
VALUES('cs','computer_science');

INSERT INTO departments(dept_id,dept_name)
VALUES('ee','electrical');

INSERT INTO departments(dept_id,dept_name)
VALUES('ma','mathematics');

INSERT INTO departments(dept_id,dept_name)
VALUES('xy','');

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('99999','','xy',0,0,0,0,0);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('GE103','intro_to_computing_and_data_structures','cs',3,0,3,7.5,4.5);

INSERT INTO prerequisite
values('GE103','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id, title, dept_id, lec_hr, tut_hr, prac_hr, ss_hr, credits) 
VALUES ('EE101', 'Signals and Systems', 'ee', 3, 1, 1, 4, 3), 
        ('HS101', 'Linguistics', 'cs', 3, 1, 0, 4, 3), 
        ('MA222', 'Numerical Analysis', 'ma', 3, 1, 1, 7, 3), 
        ('CS511', 'Computer Vision', 'cs', 3, 1, 3, 4, 4), 
        ('CS103', 'Discrete Mathematical Structures', 'cs', 3, 1, 3, 8, 3), 
        ('CS209', 'Data Structures and Algorithms', 'cs', 3, 1, 3, 4, 3), 
        ('EE202', 'Networking', 'ee', 3, 1, 3, 4, 3), 
        ('MA202', 'Differential Equations', 'ma', 3, 1, 0, 6, 4), 
        ('CS532', 'Machine Learning', 'cs', 3, 1, 3, 4, 4), 
        ('MA201', 'Linear Algebra', 'ma', 3, 1, 0, 9, 4), 
        ('EE111', 'Semiconductor Devices', 'ee', 3, 1, 3, 4, 3), 
        ('MA412', 'Complex Equations', 'ma', 3, 1, 3, 4, 4), 
        ('HS102', 'Story Writing', 'ee', 3, 1, 3, 4, 3), 
        ('CS202', 'Programming Paradigms', 'cs', 3, 1, 3, 4, 3), 
        ('EE204', 'Power Functions', 'ee', 3, 1, 3, 4, 3), 
        ('EE203', 'Jet Lag', 'ee', 3, 1, 3, 4, 3);

INSERT INTO prerequisite
values  ('EE101','99999',DEFAULT,DEFAULT,DEFAULT),
        ('HS101','99999',DEFAULT,DEFAULT,DEFAULT),
        ('MA222','99999',DEFAULT,DEFAULT,DEFAULT),
        ('CS511','CS201',DEFAULT,DEFAULT,DEFAULT),
        ('CS103','99999',DEFAULT,DEFAULT,DEFAULT),
        ('CS209','GE103',DEFAULT,DEFAULT,DEFAULT),
        ('EE202','99999',DEFAULT,DEFAULT,DEFAULT),
        ('MA202','99999',DEFAULT,DEFAULT,DEFAULT),
        ('CS532','CS201',DEFAULT,DEFAULT,DEFAULT),
        ('MA201','99999',DEFAULT,DEFAULT,DEFAULT),
        ('EE111','99999',DEFAULT,DEFAULT,DEFAULT),
        ('MA412','99999',DEFAULT,DEFAULT,DEFAULT),
        ('HS102','99999',DEFAULT,DEFAULT,DEFAULT),
        ('CS202','99999',DEFAULT,DEFAULT,DEFAULT),
        ('EE204','99999',DEFAULT,DEFAULT,DEFAULT),
        ('EE203','99999',DEFAULT,DEFAULT,DEFAULT);



INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS101','Discrete Maths','cs',3,1,0,5,3);

INSERT INTO prerequisite
values('CS101','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS201','Data Structures','cs',3,1,2,6,4);

INSERT INTO prerequisite
values('CS201','GE103',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS301','Databases','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('MA101','Calculus','ma',3,1,0,5,3);

INSERT INTO prerequisite
values('MA101','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('MA411','Real Analysis','ma',3,1,0,5,3);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS203','Digital Logic Design','cs',3,1,3,6,4);

INSERT INTO prerequisite
values('CS203','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS204','Computer Architecture','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS303','Operating Systems','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS305','Software Engineering','cs',3,0,2,7,4);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS201','GE103',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS301','CS201',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS204','CS203',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS305','CS301',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS305','CS303',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('MA411','MA101',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PCE-1',DEFAULT,'09:00','09:50',DEFAULT,'{"mon","wed","fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PCE-2',2,'10:00','10:50',DEFAULT,'{"tue","thu","fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-1',DEFAULT,'09:00','09:50',DEFAULT,'{"mon","wed"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-2',2,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-3',1,'16:00','17:50','lab','{"fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('HSME',2,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

select enroll_faculty('balesh1', 'Balesh Kumar', 'ma');
select enroll_faculty('tapas1', 'Tapas Chatterjee', 'ma');
select enroll_faculty('prabhakar1', 'Madeti Prabhakar', 'ma');
select enroll_faculty('puneet1', 'Puneet Goyal', 'cs');
select enroll_faculty('shirshendu1', 'Shirshendu Das', 'cs');
select enroll_faculty('sudarshan1', 'Sudarshan Iyengar', 'cs');
select enroll_faculty('viswanath1', 'Viswanath Gunturi', 'cs');
select enroll_faculty('balwinder1', 'Balwinder Sodhi', 'cs');
select enroll_faculty('neeraj1', 'Neeraj Goyal', 'cs');
select enroll_faculty('kalyan1', 'TV Kalyan', 'cs');

CREATE OR REPLACE FUNCTION teaches_checks()
RETURNS TRIGGER
language plpgsql
as
$$
declare
begin
if (((select current_user)<>new.fac_id) and ((select current_user) <> 'acad'))
	THEN
	RAISE EXCEPTION 'Kindly enter your faculty ID for offering course.';
END IF;

EXECUTE FORMAT('
CREATE TABLE IF NOT EXISTS %I
(
student_id char(11) NOT NULL PRIMARY KEY,
grade numeric CHECK(grade >=0 and grade <=10) NOT NULL
);
',new.course_id||'_'||new.fac_id||'_'||new.sem||'_'||new.year);
EXECUTE FORMAT ('GRANT select,insert,update on %I to %I',new.course_id||'_'||new.fac_id||'_'||new.sem||'_'||new.year, new.fac_id);
return NEW;
end;
$$;

CREATE TRIGGER teaches_trigger
BEFORE INSERT
ON teaches
FOR EACH ROW
EXECUTE PROCEDURE teaches_checks();

CREATE OR REPLACE FUNCTION course_enrollment_table()
RETURNS TRIGGER
language plpgsql
as
$$
declare
begin
EXECUTE format
('
CREATE TABLE IF NOT EXISTS %I 
(
student_id char(11) NOT NULL PRIMARY KEY,
section_id INTEGER NOT NULL DEFAULT 1
);
', NEW.year||'_'||NEW.sem||'_'||NEW.course_id||'_enrollment');

return NEW;
end;
$$;

CREATE TRIGGER course_offering_trigger
AFTER INSERT
ON course_offering
FOR EACH ROW
EXECUTE PROCEDURE course_enrollment_table();

create or replace procedure offer_course(course char(5),semester integer, yr integer, faculty_id varchar(50),slot varchar(10),
                                         min_cgpa numeric default 0,batches_allowed int[] default '{}',depts_allowed varchar(10)[] default '{}')
language plpgsql
as

$$
declare
num_sections integer;
section_alloted integer default 1;
target_info record;
begin
if((select count(*) from section_slot_info where section_slot_info.course_id = course) = 0)
	THEN num_sections = 
	(select num_sect
	from slots
	where slot_id = slot);
	insert into course_offering(course_id,sem,year)
	values(course,semester,yr);
	insert into teaches(course_id,sem,year,fac_id,section_id)
	values(course,semester,yr,faculty_id,section_alloted);
	-- verify fac_id with username in trigger teaches DONE
	insert into section_slot_info(course_id,slot_id,num_sect,sect_occupied)
	values(course,slot,num_sections,1);
	UPDATE prerequisite
	SET batches = batches_allowed,
	cgpa = min_cgpa,
	dept_allowed = depts_allowed
	WHERE course_id = course;
else
	if((select count(*) from section_slot_info where section_slot_info.course_id = course and section_slot_info.num_sect = section_slot_info.sect_occupied) = 0)
		THEN
		UPDATE section_slot_info
		SET sect_occupied = sect_occupied + 1
		WHERE course_id = course;
		section_alloted = (select sect_occupied from section_slot_info where section_slot_info.course_id = course);
		insert into teaches(course_id,sem,year,fac_id,section_id)
		values(course,semester,yr,faculty_id,section_alloted);
		RAISE INFO 'The course requirements are already decided by the course coordinator.';
	else
		RAISE EXCEPTION 'Sorry, the course already has required number of faculties, contact acads.';
		RETURN;
	END IF;
END IF;
end;
$$;

\c - prabhakar1
password
CALL offer_course('MA101',1,2019,'prabhakar1','HSME');

CALL offer_course('MA101',1,2019,'tapas1','HSME',9);

\c - tapas1
password
CALL offer_course('MA101',1,2019,'tapas1','HSME',9);

\c - balesh1
password
CALL offer_course('MA411',1,2020,'balesh1','PCE-1',batches_allowed => '{2019}',min_cgpa => 7);

\c - shirshendu1
password
CALL offer_course('GE103',1,2021,'shirshendu1','PC-2',batches_allowed => '{2020}');

\c - puneet1
password
CALL offer_course('GE103',1,2021,'puneet1','PC-2',batches_allowed => '{2020}');

\c - viswanath1
password
CALL offer_course('CS301',1,2021,'viswanath1','PCE-1',batches_allowed => '{2019}');

\c - puneet1
password
CALL offer_course('CS201',1,2020,'puneet1','PCE-2', batches_allowed => '{2019}', min_cgpa => 6);

create or replace function grant_student_permissions()
returns void
language plpgsql
as
$$
declare
courseTemp record;
studentTemp record;
begin
for courseTemp in (select * from course_offering)
LOOP
    for studentTemp in (select * from students)
    LOOP
    EXECUTE format('GRANT select,insert on %I TO %I;',
    courseTemp.year||'_'||courseTemp.sem||'_'||courseTemp.course_id||'_enrollment',
    studentTemp.student_id);
    end LOOP;
end LOOP;
end;
$$;
select enroll_student('2020mcb1001', 'Adhish Prasad', 'ma',2020);
select enroll_student('2020mcb1002', 'Mahesh Shree', 'ma',2020);
-- select enroll_student('2019csb1111', 'Ramu Kumar', 'cs',2019);
select enroll_student('2019csb1112', 'Raman Kumar', 'cs',2019);
select enroll_student('2019eeb1222', 'Ashwin S', 'ee',2019);
select enroll_student('2019mcb1003', 'Ramesh', 'ma',2019);

select grant_student_permissions();

CREATE OR REPLACE FUNCTION calculate_CGPA(studentid char(11))
RETURNS NUMERIC
LANGUAGE plpgsql
AS
$$
declare
    course record;
    total_points NUMERIC := 0;
    total_credits NUMERIC := 0;
BEGIN
    for course in EXECUTE FORMAT('select credits, grade from %I','trans_'||studentid)
    loop
	if(course.grade >=4)
	THEN
        total_points = total_points + (course.credits*course.grade);
        total_credits = total_credits + (course.credits);
	END IF;
    end loop;
if (total_credits = 0)
then
return 0;
end if;
RETURN (total_points/total_credits);
END;
$$;

CREATE OR REPLACE FUNCTION check_credits(studentid CHAR(11),curr_sem INTEGER, curr_yr INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS
$$
declare
    joinyr integer;
    course record;
    total_credits1 NUMERIC := 0; -- sum of credits earned in the previous to previous sem
    total_credits2 NUMERIC := 0; -- sum of credits earned in the previous sem
    current_year INTEGER := curr_yr;
    current_sem INTEGER := curr_sem;
    checking_year1 INTEGER := 0;
    checking_sem1 INTEGER := 0;
    checking_year2 INTEGER := 0;
    checking_sem2 INTEGER := 0;
    limit_value NUMERIC := 0; -- upper bound of the number of credits
 
BEGIN
    EXECUTE 'select join_year from students where student_id = $1'
    INTO joinyr
    USING studentid;
    if ((joinyr = curr_yr) or (((curr_yr - 1) = joinyr) and (curr_sem = 2))) then
        return 19.5;
    end if;
    
    -- if current_sem = 1 then
    --     checking_year1 = current_year - 1;
    --     checking_sem1 = 1;
    --     checking_year2 = current_year - 1;
    --     checking_sem2 = 2;
    -- end if;
    -- if current_sem = 2 then
    --     checking_year1 = current_year - 1;
    --     checking_sem1 = 2;
    --     checking_year2 = current_year;
    --     checking_sem2 = 1;
    -- end if;

    if current_sem = 1 then
        checking_year1 = current_year;
        checking_sem1 = 2;
        checking_year2 = current_year - 1;
        checking_sem2 = 1;
    end if;
    if current_sem = 2 then
        checking_year1 = current_year - 1;
        checking_sem1 = 1;
        checking_year2 = current_year - 1;
        checking_sem2 = 2;
    end if;
 
    for course in  EXECUTE FORMAT('select year,sem,credits,grade
        from %I','trans_'||studentid)
    loop
        if course.sem = checking_sem1 AND course.year = checking_year1 AND course.grade>3 then
            total_credits1 = total_credits1 + (course.credits);
        end if;
        if course.sem = checking_sem2 AND course.year = checking_year2 AND course.grade>3 then
            total_credits2 = total_credits2 + (course.credits);
        end if;
    end loop;
 
    limit_value=((total_credits1+total_credits2)/2)*1.25; -- calculate the limit_value
 
    -- assuming that if a student is present in the 1st semester of the 1st year or in the 2nd semester of the 1st year than he/she can take at max 19.5 credits
   
    -- if current_sem = 1 AND current_year = 1 then
    --     limit_value = 19.5;
    -- end if;
 
    -- if current_sem = 2 AND current_year = 1 then
    --     limit_value = 19.5;
    -- end if;
 
    --RAISE INFO 'As per 1.25 rule, the student cannot take more than % credits in this semester',limit_value;
    RETURN limit_value;
END;
$$;

create or replace function check_slot(studentid char(11),course_slot varchar(5))
returns char(5)
language plpgsql
as
$$
declare
register_row record;
section_row record;
begin
for  register_row in EXECUTE FORMAT('select * from %I','register_'||studentid)
LOOP
	for section_row in (select * from section_slot_info where section_slot_info.course_id = register_row.course_id)
	LOOP
		if(section_row.slot_id = course_slot)
		THEN
		return register_row.course_id;
		end if;
	END LOOP;
END LOOP;
return '00000';
end;
$$;

create or replace function yr_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
my_yr integer;
allowed_yr integer[];
temp_yr integer;
yr_present integer :=0;

begin

-- if ( ((select current_user)<>studentid) and ((select current_user) <> 'acads') )
-- 	THEN
-- 	RAISE EXCEPTION 'You can''t access academic data of other students';
-- END IF;

my_yr = (select join_year from students where students.student_id = studentid);
allowed_yr = (select batches from prerequisite where prerequisite.course_id = courseid limit 1);

if(allowed_yr = '{}')
THEN
    yr_present = 1;
    RETURN yr_present;
END IF;

FOREACH temp_yr in ARRAY allowed_yr
LOOP
    IF temp_yr = my_yr
    THEN
        yr_present = 1;
        EXIT;
    END IF;
END LOOP;
IF(yr_present = 0)
    THEN
    RAISE EXCEPTION '% batch is not allowed to register in this course!!!', my_yr;
END IF;
return yr_present;
END;
$$;

create or replace function dept_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
my_dept varchar(10);
allowed_dept varchar(10)[];
temp_dept varchar(10);
dept_present integer :=0;

begin

-- if ( ((select current_user)<>studentid) and ((select current_user) <> 'acads') )
-- 	THEN
-- 	RAISE EXCEPTION 'You can''t access academic data of other students';
-- END IF;

my_dept = (select dept_id from students where students.student_id = studentid);
allowed_dept = (select dept_allowed from prerequisite where prerequisite.course_id = courseid limit 1);

if(allowed_dept = '{}')
THEN
    dept_present = 1;
    RETURN dept_present;
END IF;

FOREACH temp_dept in ARRAY allowed_dept
LOOP
    IF temp_dept = my_dept
    THEN
        dept_present = 1;
        EXIT;
    END IF;
END LOOP;
IF(dept_present = 0)
    THEN
    RAISE EXCEPTION '% department is not allowed to register in this course!!!', my_dept;
END IF;
return dept_present;
END;
$$;

create or replace function prereq_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
prereqTemp record;
prereq_in_trans integer := 0;
begin
-- if ( ((select current_user)<>studentid) and ((select current_user) <> 'acads') )
-- 	THEN
-- 	RAISE EXCEPTION 'You can''t access academic data of other students';
-- END IF;
FOR prereqTemp in (select * from prerequisite where course_id = courseid)
LOOP
    IF prereqTemp.prereq_id = '99999'
    THEN
        prereq_in_trans = 1;
        return prereq_in_trans;
        EXIT;
    END IF;
    EXECUTE 'select count(*) from '
            ||quote_ident('trans_'||studentid)
            ||' where course_id = $1 and grade>=4;'
    INTO prereq_in_trans
    USING prereqTemp.prereq_id;                
    if(prereq_in_trans = 0)
    THEN
        RAISE EXCEPTION '% course is not covered by you. ',prereqTemp.prereq_id;
        prereq_in_trans = 0;
    END IF;
END LOOP;
return prereq_in_trans;
end;
$$;

create or replace function register_in_course(studentid char(11), yr integer, semester integer, courseid char(5), sectionid integer, course_type text)
returns void
language plpgsql
as
$$
declare
course_title text;
f1 integer :=1;
course_already integer := 0 ;
-------------------------------
f2 integer := 1;		-- flag for slot check
clashes_with CHAR(5);	
section_slot record;
courseslot varchar(10);
course_yesno integer;
------------------------------
f3 integer :=1;			--flag for credit limit
permissible_credits numeric := 0;
current_sem_credits numeric := 0;
registered_course record;
this_credits numeric := 0;
-------------------------------
f4 integer := 1;
--------------
yr_present integer := 0;
dept_present integer :=0;
current_cgpa numeric;
required_cgpa numeric;
prereq_cleared integer := 0;
begin
-- passed this course earlier or not

EXECUTE 'select count(*) from (select course_id from '
        ||quote_ident('trans_'||studentid)
        ||' where course_id = $1 and grade >= 4) as foo'
INTO course_already
USING courseid;
if(course_already = 1)
THEN
f1 = 0;
RAISE EXCEPTION 'You have already passed this course!';
END IF;
-----------------------------------------------------------------------------------------------------------
-- slot
	courseslot = (select slot_id from section_slot_info where course_id = courseid);
	course_yesno = (select count(*) from (select * from teaches where (teaches.course_id,teaches.sem,teaches.year,teaches.section_id) = (courseid,semester,yr,sectionid)) as temp);
	if(course_yesno = 0)
	THEN
	RAISE EXCEPTION 'No such course offered this semester % and year % with sectionID %.', semester,yr,sectionid;
	END IF;
	clashes_with = check_slot(studentid,courseslot);
	if(clashes_with <> '00000')
		THEN
		f2 = 0;
		RAISE EXCEPTION 'You have % clashing with this course',clashes_with;
	end if;
---------------------------------------------------------------------------------------------------------------
-- credit limit
permissible_credits = check_credits(studentid,semester,yr);
for registered_course in EXECUTE FORMAT('select * from  %I','register_'||studentid)
	LOOP
		if(registered_course.sem = semester and registered_course.year = yr)
		THEN
		current_sem_credits = current_sem_credits + registered_course.credits;
		END IF;
	END LOOP;
this_credits = (select credits from course_catalogue where course_id = courseid);

IF((this_credits + current_sem_credits) > permissible_credits)
	THEN
	f3 = 0;
	RAISE EXCEPTION 'Credit Limit Exceeded, You may generate a ticket.';
END IF;

---------------------------------------------------------------------------------------------------------
-- prerequisite
	-- yr/batch
    yr_present = yr_check(studentid,courseid);
    -- dept
    dept_present = dept_check(studentid, courseid);
    --cgpa
    required_cgpa = (select cgpa from prerequisite where prerequisite.course_id = courseid limit 1);
    current_cgpa = calculate_CGPA(studentid);
    if(current_cgpa < required_cgpa)
    THEN
    RAISE EXCEPTION 'You require atleast % CGPA to register, your current CGPA is %', required_cgpa,current_cgpa;
    END IF;
	--prereq course pass or not
    prereq_cleared =  prereq_check(studentid,courseid);


EXECUTE FORMAT('
INSERT INTO %I
values(''%s'',%s);
',yr||'_'||semester||'_'||courseid||'_enrollment',studentid,sectionid);
course_title  = (select title from course_catalogue where course_id = courseid);


EXECUTE FORMAT('
INSERT INTO %I
values(%s,%s,''%s'',''%s'',''%s'',%s);
','register_'||studentid,yr,semester,courseid,course_title,course_type,this_credits);
end;
$$;

\c - 2020mcb1002
password
select register_in_course('2020mcb1002',2021,1,'GE103',1,'program_core');

select enroll_faculty('apurv1', 'Apurv Mudgal', 'cs');
\c - apurv1
password
CALL offer_course('CS101',2,2021,'apurv1','PC-1',batches_allowed => '{2020}');

\c - acad
password
select grant_student_permissions();

\c - 2020mcb1002
password
select register_in_course('2020mcb1002',2021,2,'cs101',1,'program_core');

\c - acad
password

create or replace function csv_upload_grade(courseid char(5), facid varchar(50), semester integer, yr integer,filePath text)
returns void
language plpgsql
as
$$
declare
begin
if ((select current_user)<>facid)
	THEN
	RAISE EXCEPTION 'Kindly enter your own faculty ID for uploading grade.';
END IF;
IF((select count(*) from teaches where (course_id,sem,teaches.year,fac_id)=(courseid,semester,yr,facid)) = 1)
THEN
    EXECUTE FORMAT('
    COPY %I
    FROM ''%s''
    DELIMITER '',''
    CSV HEADER;
    ',courseid||'_'||facid||'_'||semester||'_'||yr,filePath);
END IF;
end;
$$;
\c - apurv1
password
select csv_upload_grade('CS101','apurv1',2,2021,'C:\Users\Ashish Sharma\Desktop\cs301_project\submission\main_functions\sample.csv');

\c - acad
password
CREATE OR REPLACE FUNCTION copy_grades(sem_val INTEGER, year_val INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    course record;
    trans_insert record;
    course_title text;
    course_credits numeric;
    course_type text;
    student_join_year integer;
    student_branch text;
BEGIN
    for course in (select * from teaches)
    loop
        if course.sem=sem_val AND course.year=year_val then
            for trans_insert in EXECUTE FORMAT('select * from %I',course.course_id||'_'||course.fac_id||'_'||course.sem||'_'||course.year)
            loop
                -- ignore, just used for debugging purposes     RAISE INFO '% % % % % % % %', 'trans_'||trans_insert.student_id, course.year, course.sem, course.course_id,course.course_id,course.course_id,course.sem,trans_insert.grade;
                course_title = (select title from course_catalogue where lower(course_catalogue.course_id) = lower(course.course_id));
                course_credits = (select credits from course_catalogue where lower(course_catalogue.course_id) = lower(course.course_id));
                student_join_year = (select join_year from students where students.student_id = trans_insert.student_id);
                student_branch = (select dept_id from students where students.student_id = trans_insert.student_id);
                -- type is remaining
                -- RAISE INFO '%',course_title;
                -- RAISE INFO '%',student_join_year;
                -- RAISE INFO '%',student_branch;
 
                
               
               EXECUTE 'select type from '||quote_ident('btech_'||student_join_year)
                ||' where lower(course_id) = lower($1)' INTO course_type USING course.course_id;
                EXECUTE 'select type from '||quote_ident(lower(student_branch)||'_'||student_join_year)
                ||' where lower(course_id) = lower($1)' INTO course_type USING course.course_id;
                course_type = 'open_elective';
                EXECUTE format('INSERT INTO %I VALUES(%s, %s, %L, %L, %L, %s, %s)', 'trans_'||trans_insert.student_id, course.year, course.sem, course.course_id, course_title, course_type, course_credits, trans_insert.grade);
            end loop;
        end if;
    end loop;
    RETURN;
END;
$$;
select copy_grades(2,2021);


create or replace function grant_advisors()
returns void
language plpgsql
as
$$
declare
facTemp record;
advisorTemp record;
begin
for advisorTemp in (select * from batch_advisor)
LOOP
    for facTemp in (select * from faculty)
    LOOP
    EXECUTE FORMAT('GRANT select on %I to %I;','ticket_'||facTemp.fac_id,advisorTemp.fac_id);
    END LOOP;
END LOOP;
end;
$$;

select grant_advisors();

create or replace function func_tickets()
returns trigger
language plpgsql
as
$$
declare
begin
if ((select current_user)<>new.student_id)
	THEN
	RAISE EXCEPTION 'Kindly enter your student ID for generating ticket.';
END IF;
if((NEW.course_id,NEW.sem,NEW.year) NOT IN (select * from course_offering))
    THEN
    RAISE EXCEPTION 'The course % is not offered this semester, Enter ticket for an offered course.',NEW.course_id;
END IF;
EXECUTE FORMAT('
INSERT INTO %I
values(%s,%s,%s,''%s'',''%s'',''%s'','''','''','''');
','ticket_'||NEW.student_id,NEW.ticket_id,NEW.sem,New.year,NEW.course_id,NEW.student_id,NEW.cause);
RETURN NEW;
end;
$$;

CREATE TRIGGER trig_tickets
AFTER INSERT
ON tickets
FOR EACH ROW
EXECUTE PROCEDURE func_tickets();

create or replace function generate_ticket(studentid char(11), semester integer ,yr integer, courseid char(5), reason text)
returns void
language plpgsql
as
$$
declare
ticket_number integer := 0;
begin
ticket_number = (select count(*) from tickets) + 1;
INSERT INTO tickets
values(ticket_number,semester,yr,courseid,studentid,reason);
end;
$$;

select generate_ticket('2020mcb1002',1,2020,'CS201','batch,prereq');

CREATE OR REPLACE FUNCTION generate_ticket_fac(fac_id_temp VARCHAR(50), course_id_temp CHAR(5), sem_temp INTEGER, year_temp INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    course record;
    ticket_gtable record;
    fac_dec varchar(3) := '000';
BEGIN
    IF (select current_user)<> fac_id_temp
    THEN
    RAISE EXCEPTION 'Enter your own faculty id.';
    END IF;
    for course in (select * from teaches)
    loop
        if course.sem=sem_temp AND course.year=year_temp AND course.fac_id=fac_id_temp AND course.course_id=course_id_temp AND course.section_id=1 then
            for ticket_gtable in (select * from tickets)
            loop
                if ticket_gtable.course_id=course.course_id AND ticket_gtable.sem=course.sem AND ticket_gtable.year=course.year then
                    EXECUTE FORMAT('INSERT INTO %I VALUES(%s, %s, %s, %L, %L, %L, %L)', 'ticket_'||fac_id_temp,ticket_gtable.ticket_id, sem_temp, year_temp, course_id_temp, ticket_gtable.student_id, ticket_gtable.cause, fac_dec); 
                end if;
            end loop;
        end if;
    end loop;
    RETURN;
END;
$$;
\c - puneet1
password
select * from generate_ticket_fac('puneet1','CS201',1,2020);

CREATE OR REPLACE FUNCTION make_dec_fac(ticketid INTEGER, studentid CHAR(11), facid VARCHAR(50), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET fac_dec=%L where %s=%I.ticket_id', 'ticket_'||facid, current_decision, ticketid, 'ticket_'||facid);
END;
$$;
select make_dec_fac(1,'2019mcb1002','puneet1','yes');

CREATE OR REPLACE FUNCTION generate_ticket_adv(year_temp INTEGER, dep_id_temp CHAR(5), semester integer, yr integer)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    rec1 record;
    student_yr integer;
    student_dep varchar(10);
    relevant_fac varchar(50);
    fac_dec_temp varchar(3) := '000';
    relevant_advisor varchar(50);
BEGIN
    relevant_advisor = (select fac_id from batch_advisor where (dept_id,batch_yr) = (dep_id_temp,year_temp));
    for rec1 in (select * from tickets)
    loop
        if (rec1.year,rec1.sem) = (yr,semester)
        THEN
            student_yr = (select join_year from students where student_id = rec1.student_id);
            student_dep = (select dept_id from students where student_id = rec1.student_id);
            if (year_temp, dep_id_temp)=(student_yr,student_dep)
            THEN
                relevant_fac = (select fac_id from teaches where course_id = rec1.course_id and section_id = 1 and (teaches.year,teaches.sem) = (yr,semester));
                EXECUTE 'select fac_dec from '||
                        quote_ident('ticket_'||relevant_fac)||
                        ' where (ticket_id,sem,year,course_id,student_id) = ($1,$2,$3,$4,$5);'
                INTO fac_dec_temp
                USING rec1.ticket_id,rec1.sem,rec1.year,rec1.course_id,rec1.student_id;
                EXECUTE FORMAT('INSERT INTO %I VALUES(%s, %s, %s, %L, %L, %L, %L, %L)', 'ticket_advisor_'||relevant_advisor,rec1.ticket_id,rec1.sem,rec1.year,rec1.course_id,rec1.student_id, rec1.cause, fac_dec_temp,'000');     
            END IF;
        END IF;
    end loop;
    RETURN;
END;
$$;

CREATE OR REPLACE FUNCTION make_dec_adv(ticketid INTEGER, studentid CHAR(11), advid VARCHAR(50), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET adv_dec=%L where %s=%I.ticket_id', 'ticket_advisor_'||advid, current_decision, ticketid, 'ticket_advisor_'||advid);
END;
$$;

select make_dec_adv(1,'2020mcb1002','tapas1','yes');

CREATE OR REPLACE FUNCTION generate_all_tickets(sem_temp INTEGER, year_temp INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    batch_adv record;
    ticket_rec record;
    decision_acads VARCHAR(3) := '000';
BEGIN
    IF (select current_user) <> 'acad'
    THEN
    RAISE EXCEPTION 'Only for acad_section';
    END IF;
    for batch_adv in (select * from batch_advisor)
    loop
        for ticket_rec in EXECUTE FORMAT('select * from %I','ticket_advisor_'||batch_adv.fac_id)
        loop
            if ticket_rec.sem=sem_temp AND ticket_rec.year=year_temp then
                EXECUTE FORMAT('INSERT INTO tickets_acads VALUES(%s, %s, %s, %L, %L, %L, %L, %L, %L)',
                ticket_rec.ticket_id,
                ticket_rec.sem,
                ticket_rec.year,
                ticket_rec.course_id,
                ticket_rec.student_id,
                ticket_rec.cause,
                ticket_rec.fac_dec,
                ticket_rec.adv_dec,
                decision_acads);
            end if;
        end loop;
    end loop;
    RETURN;
END;
$$;

select generate_all_tickets(1,2020);

create or replace function force_enroll()
returns trigger
language plpgsql
as
$$
declare
rel_title text;
rel_type text := 'open_elective';
rel_credits numeric;
begin
rel_title = (select title from course_catalogue where course_id = NEW.course_id);
rel_credits = (select credits from course_catalogue where course_id = NEW.course_id);
EXECUTE FORMAT('
UPDATE %I
SET acads_dec = %L,
    fac_dec = %L,
    adv_dec = %L
WHERE %I.ticket_id = %s;
','ticket_'||NEW.student_id,NEW.acad_dec,NEW.fac_dec,NEW.adv_dec,'ticket_'||NEW.student_id,NEW.ticket_id);

IF (NEW.acad_dec = 'yes')
then
EXECUTE FORMAT ('insert into %I
values(%L, 1);',NEW.year||'_'||NEW.sem||'_'||NEW.course_id||'_enrollment',NEW.student_id);
EXECUTE FORMAT ('insert into %I
values(%L, %s, %L, %L, %L, %s);','register_'||NEW.student_id,NEW.year,NEW.sem,NEW.course_id,rel_title,rel_type,rel_credits);
RETURN NEW;
end if;
end;
$$;

CREATE TRIGGER tickets_acads_trig
AFTER UPDATE
ON tickets_acads
FOR EACH ROW
EXECUTE PROCEDURE force_enroll();

CREATE OR REPLACE FUNCTION make_dec_acad(ticketid INTEGER, studentid CHAR(11), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET acad_dec=%L where %s=%I.ticket_id', 'tickets_acads', current_decision, ticketid, 'tickets_acads');
END;
$$;
select make_dec_acad(1,'2020mcb1002','yes');


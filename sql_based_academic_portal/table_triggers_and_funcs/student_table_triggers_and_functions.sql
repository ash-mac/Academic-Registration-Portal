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
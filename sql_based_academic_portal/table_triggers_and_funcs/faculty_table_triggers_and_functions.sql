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
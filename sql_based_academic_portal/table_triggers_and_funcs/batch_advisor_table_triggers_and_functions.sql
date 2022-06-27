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
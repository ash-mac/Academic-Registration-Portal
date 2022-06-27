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
BEFORE INSERT
ON tickets
FOR EACH ROW
EXECUTE PROCEDURE func_tickets();
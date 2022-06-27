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
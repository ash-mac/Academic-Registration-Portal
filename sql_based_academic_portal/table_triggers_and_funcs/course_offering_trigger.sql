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

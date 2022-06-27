create or replace function generate_enrollment_triggers()
returns void
language plpgsql
as
$$
declare
courseTemp record;
begin
for courseTemp in (select * from course_offering)
LOOP
    EXECUTE FORMAT('
    CREATE TRIGGER %I
    BEFORE INSERT
    ON %I
    FOR EACH ROW
    EXECUTE PROCEDURE verify_student();
    ','trig_'||courseTemp.year||'_'||courseTemp.sem||'_'||courseTemp.course_id,
        courseTemp.year||'_'||courseTemp.sem||'_'||courseTemp.course_id||'_enrollment');
END LOOP;
end;
$$;
-- EXECUTE FORMAT('
    -- create or replace function %I
    -- returns trigger
    -- language plpgsql
    -- as
    -- $$
    -- declare
    -- begin
    -- if ((select current_user)<>new.student_id)
	-- THEN
	-- RAISE EXCEPTION ''Kindly enter your own student_id for registering in  course.'';
    -- END IF;
    -- end;
    -- $$;
    -- ',courseTemp.year||'_'||courseTemp.sem||'_'||courseTemp.course_id||'()');
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
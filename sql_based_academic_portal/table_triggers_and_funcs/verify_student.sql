create or replace function verify_student()
returns trigger
language plpgsql
as
$$
declare
begin
if ((select current_user)<>new.student_id)
	THEN
	RAISE EXCEPTION 'Kindly enter your own student_id for registering in  course.';
END IF;
end;
$$;
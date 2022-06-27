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

-- transcript
-- register_table
-- ticket_table
-- user studentid
-- per



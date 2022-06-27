create or replace function grant_student_permissions()
returns void
language plpgsql
as
$$
declare
courseTemp record;
studentTemp record;
begin
for courseTemp in (select * from course_offering)
LOOP
    for studentTemp in (select * from students)
    LOOP
    EXECUTE format('GRANT select,insert on %I TO %I;',
    courseTemp.year||'_'||courseTemp.sem||'_'||courseTemp.course_id||'_enrollment',
    studentTemp.student_id);
    end LOOP;
end LOOP;
end;
$$;
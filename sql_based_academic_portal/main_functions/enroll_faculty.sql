create or replace function enroll_faculty(facultyid varchar(50), fname text, deptid varchar(10))
returns void
language plpgsql
as
$$
declare
begin
insert into faculty
values(facultyid,fname,deptid);
end;
$$;
-- triggers on faculty table
-- create user with faculty id
-- create its ticket table and grant insert permission on it
-- grant other permissions
/*
EXECUTE format('create user %I with encrypted password ''password'';',facultyid);
EXECUTE format('GRANT select on %I TO %I;','course_catalogue',facultyid);
EXECUTE format('GRANT select on %I TO %I;','slots',facultyid);
EXECUTE format('GRANT select on %I TO %I;','section_slot_info',facultyid);
EXECUTE format('GRANT select on %I TO %I;','teaches',facultyid);
EXECUTE format('GRANT select on %I TO %I;','students',facultyid);
EXECUTE format('GRANT select on %I TO %I;','prerequisite',facultyid);
EXECUTE format('GRANT select on %I TO %I;','faculty',facultyid);
EXECUTE format('GRANT select on %I TO %I;','departments',facultyid);
EXECUTE format('GRANT select on %I TO %I;','course_offering',facultyid);
EXECUTE format('GRANT insert on %I TO %I;','course_offering',facultyid);
EXECUTE format('GRANT insert on %I TO %I;','section_slot_info',facultyid);
EXECUTE format('GRANT insert on %I TO %I;','teaches',facultyid);
EXECUTE format('GRANT update on %I TO %I;','section_slot_info',facultyid);
EXECUTE format('GRANT update on %I TO %I;','prerequisite',facultyid);
*/

select * from enroll_faculty('prabhakar','Madeti Prabhakar','MA');
select * from enroll_faculty('tapas','Tapas Chatterjee','MA');
select * from enroll_faculty('balesh','Balesh Kumar','MA');
select * from enroll_faculty('viswanath','Viswanath Gunturi','CS');
select * from enroll_faculty('puneet','Puneet Goyal','CS');
select * from enroll_faculty('shirshendu','Shirshendu Das','CS');
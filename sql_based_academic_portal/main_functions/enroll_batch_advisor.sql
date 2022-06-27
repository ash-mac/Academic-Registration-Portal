create or replace function enroll_batch_advisor(facid varchar(50), deptid varchar(10), batchyr integer)
returns void
language plpgsql
as
$$
begin
insert into batch_advisor(fac_id,dept_id,batch_yr)
values(facid,deptid,batchyr);
end;
$$;

-- trigger creates ticket_advisor_fac_id(ticket_id,sem,year,course_id,student_id,cause,fac_dec,adv_dec)

create or replace function generate_ticket(studentid char(11), semester integer ,yr integer, courseid char(5), reason text)
returns void
language plpgsql
as
$$
declare
ticket_number integer := 0;
begin
ticket_number = (select count(*) from tickets) + 1;
INSERT INTO tickets
values(ticket_number,semester,yr,courseid,studentid,reason);
end;
$$;

select generate_ticket('2020mcb1002',1,2020,'CS201','batch,prereq');
--don't create trigger for ticket table to insert into enrollment, as then student can use insert into
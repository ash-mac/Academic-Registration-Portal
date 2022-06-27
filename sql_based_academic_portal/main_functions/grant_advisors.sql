create or replace function grant_advisors()
returns void
language plpgsql
as
$$
declare
facTemp record;
advisorTemp record;
begin
for advisorTemp in (select * from batch_advisor)
LOOP
    for facTemp in (select * from faculty)
    LOOP
    EXECUTE FORMAT('GRANT select on %I to %I;','ticket_'||facTemp.fac_id,advisorTemp.fac_id);
    END LOOP;
END LOOP;
end;
$$;
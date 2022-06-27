CREATE OR REPLACE FUNCTION generate_all_tickets(sem_temp INTEGER, year_temp INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    batch_adv record;
    ticket_rec record;
    decision_acads VARCHAR(3) := '000';
BEGIN
    IF (select current_user) <> 'acad'
    THEN
    RAISE EXCEPTION 'Only for acad_section';
    END IF;
    for batch_adv in (select * from batch_advisor)
    loop
        for ticket_rec in EXECUTE FORMAT('select * from %I','ticket_advisor_'||batch_adv.fac_id)
        loop
            if ticket_rec.sem=sem_temp AND ticket_rec.year=year_temp then
                EXECUTE FORMAT('INSERT INTO tickets_acads VALUES(%s, %s, %s, %L, %L, %L, %L, %L, %L)',
                ticket_rec.ticket_id,
                ticket_rec.sem,
                ticket_rec.year,
                ticket_rec.course_id,
                ticket_rec.student_id,
                ticket_rec.cause,
                ticket_rec.fac_dec,
                ticket_rec.adv_dec,
                decision_acads);
            end if;
        end loop;
    end loop;
    RETURN;
END;
$$;

select generate_all_tickets(1,2020);

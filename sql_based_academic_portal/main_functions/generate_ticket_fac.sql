CREATE OR REPLACE FUNCTION generate_ticket_fac(fac_id_temp VARCHAR(50), course_id_temp CHAR(5), sem_temp INTEGER, year_temp INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    course record;
    ticket_gtable record;
    fac_dec varchar(3) := '000';
BEGIN
    IF (select current_user)<> fac_id_temp
    THEN
    RAISE EXCEPTION 'Enter your own faculty id.';
    END IF;
    for course in (select * from teaches)
    loop
        if course.sem=sem_temp AND course.year=year_temp AND course.fac_id=fac_id_temp AND course.course_id=course_id_temp AND course.section_id=1 then
            for ticket_gtable in (select * from tickets)
            loop
                if ticket_gtable.course_id=course.course_id AND ticket_gtable.sem=course.sem AND ticket_gtable.year=course.year then
                    EXECUTE FORMAT('INSERT INTO %I VALUES(%s, %s, %s, %L, %L, %L, %L)', 'ticket_'||fac_id_temp,ticket_gtable.ticket_id, sem_temp, year_temp, course_id_temp, ticket_gtable.student_id, ticket_gtable.cause, fac_dec); 
                end if;
            end loop;
        end if;
    end loop;
    RETURN;
END;
$$;

select * from generate_ticket_fac('puneet1','CS201',1,2020);

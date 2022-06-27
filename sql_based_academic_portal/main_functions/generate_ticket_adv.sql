CREATE OR REPLACE FUNCTION generate_ticket_adv(year_temp INTEGER, dep_id_temp CHAR(5), semester integer, yr integer)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    rec1 record;
    student_yr integer;
    student_dep varchar(10);
    relevant_fac varchar(50);
    fac_dec_temp varchar(3) := '000';
    relevant_advisor varchar(50);
BEGIN
    relevant_advisor = (select fac_id from batch_advisor where (dept_id,batch_yr) = (dep_id_temp,year_temp));
    for rec1 in (select * from tickets)
    loop
        if (rec1.year,rec1.sem) = (yr,semester)
        THEN
            student_yr = (select join_year from students where student_id = rec1.student_id);
            student_dep = (select dept_id from students where student_id = rec1.student_id);
            if (year_temp, dep_id_temp)=(student_yr,student_dep)
            THEN
                relevant_fac = (select fac_id from teaches where course_id = rec1.course_id and section_id = 1 and (teaches.year,teaches.sem) = (yr,semester));
                EXECUTE 'select fac_dec from '||
                        quote_ident('ticket_'||relevant_fac)||
                        ' where (ticket_id,sem,year,course_id,student_id) = ($1,$2,$3,$4,$5);'
                INTO fac_dec_temp
                USING rec1.ticket_id,rec1.sem,rec1.year,rec1.course_id,rec1.student_id;
                EXECUTE FORMAT('INSERT INTO %I VALUES(%s, %s, %s, %L, %L, %L, %L, %L)', 'ticket_advisor_'||relevant_advisor,rec1.ticket_id,rec1.sem,rec1.year,rec1.course_id,rec1.student_id, rec1.cause, fac_dec_temp,'000');     
            END IF;
        END IF;
    end loop;
    RETURN;
END;
$$;
 
select generate_ticket_adv(2020,'ma',1,2020);
 


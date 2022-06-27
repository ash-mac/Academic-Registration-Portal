CREATE OR REPLACE FUNCTION make_dec_acad(ticketid INTEGER, studentid CHAR(11), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET acad_dec=%L where %s=%I.ticket_id', 'tickets_acads', current_decision, ticketid, 'tickets_acads');
END;
$$;
select make_dec_acad(1,'2020mcb1002','yes');
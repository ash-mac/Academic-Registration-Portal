CREATE OR REPLACE FUNCTION make_dec_fac(ticketid INTEGER, studentid CHAR(11), facid VARCHAR(50), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET fac_dec=%L where %s=%I.ticket_id', 'ticket_'||facid, current_decision, ticketid, 'ticket_'||facid);
END;
$$;

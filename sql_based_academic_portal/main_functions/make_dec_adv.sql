CREATE OR REPLACE FUNCTION make_dec_adv(ticketid INTEGER, studentid CHAR(11), advid VARCHAR(50), decision VARCHAR(3))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
DECLARE
    current_decision VARCHAR(3);
BEGIN
    current_decision=decision;
    EXECUTE FORMAT('UPDATE %I SET adv_dec=%L where %s=%I.ticket_id', 'ticket_advisor_'||advid, current_decision, ticketid, 'ticket_advisor_'||advid);
END;
$$;

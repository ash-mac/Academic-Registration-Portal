create or replace function prereq_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
prereqTemp record;
prereq_in_trans integer := 0;
begin
-- if ( ((select current_user)<>studentid) and ((select current_user) <> 'acad') )
-- 	THEN
-- 	RAISE EXCEPTION 'You can''t access academic data of other students';
-- END IF;
FOR prereqTemp in (select * from prerequisite where course_id = courseid)
LOOP
    IF prereqTemp.prereq_id = '99999'
    THEN
        prereq_in_trans = 1;
        return prereq_in_trans;
        EXIT;
    END IF;
    EXECUTE 'select count(*) from '
            ||quote_ident('trans_'||studentid)
            ||' where course_id = $1 and grade>=4;'
    INTO prereq_in_trans
    USING prereqTemp.prereq_id;                
    if(prereq_in_trans = 0)
    THEN
        RAISE EXCEPTION '% course is not covered by you. ',prereqTemp.prereq_id;
        prereq_in_trans = 0;
    END IF;
END LOOP;
return prereq_in_trans;
end;
$$;

-- select prereq_check('2019mcb1213','CS301');
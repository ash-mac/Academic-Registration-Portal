CREATE OR REPLACE FUNCTION check_credits(studentid CHAR(11),curr_sem INTEGER, curr_yr INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS
$$
declare
    joinyr integer;
    course record;
    total_credits1 NUMERIC := 0; -- sum of credits earned in the previous to previous sem
    total_credits2 NUMERIC := 0; -- sum of credits earned in the previous sem
    current_year INTEGER := curr_yr;
    current_sem INTEGER := curr_sem;
    checking_year1 INTEGER := 0;
    checking_sem1 INTEGER := 0;
    checking_year2 INTEGER := 0;
    checking_sem2 INTEGER := 0;
    limit_value NUMERIC := 0; -- upper bound of the number of credits
 
BEGIN
    EXECUTE 'select join_year from students where student_id = $1'
    INTO joinyr
    USING studentid;
    if ((joinyr = curr_yr) or (((curr_yr - 1) = joinyr) and (curr_sem = 2))) then
        return 19.5;
    end if;
    
    -- if current_sem = 1 then
    --     checking_year1 = current_year - 1;
    --     checking_sem1 = 1;
    --     checking_year2 = current_year - 1;
    --     checking_sem2 = 2;
    -- end if;
    -- if current_sem = 2 then
    --     checking_year1 = current_year - 1;
    --     checking_sem1 = 2;
    --     checking_year2 = current_year;
    --     checking_sem2 = 1;
    -- end if;

    if current_sem = 1 then
        checking_year1 = current_year;
        checking_sem1 = 2;
        checking_year2 = current_year - 1;
        checking_sem2 = 1;
    end if;
    if current_sem = 2 then
        checking_year1 = current_year - 1;
        checking_sem1 = 1;
        checking_year2 = current_year - 1;
        checking_sem2 = 2;
    end if;
 
    for course in  EXECUTE FORMAT('select year,sem,credits,grade
        from %I','trans_'||studentid)
    loop
        if course.sem = checking_sem1 AND course.year = checking_year1 AND course.grade>3 then
            total_credits1 = total_credits1 + (course.credits);
        end if;
        if course.sem = checking_sem2 AND course.year = checking_year2 AND course.grade>3 then
            total_credits2 = total_credits2 + (course.credits);
        end if;
    end loop;
 
    limit_value=((total_credits1+total_credits2)/2)*1.25; -- calculate the limit_value
 
    -- assuming that if a student is present in the 1st semester of the 1st year or in the 2nd semester of the 1st year than he/she can take at max 19.5 credits
   
    -- if current_sem = 1 AND current_year = 1 then
    --     limit_value = 19.5;
    -- end if;
 
    -- if current_sem = 2 AND current_year = 1 then
    --     limit_value = 19.5;
    -- end if;
 
    --RAISE INFO 'As per 1.25 rule, the student cannot take more than % credits in this semester',limit_value;
    RETURN limit_value;
END;
$$;

---------------------------------------------------------------------------
-- select check_credits('2019mcb1213',2,2020);
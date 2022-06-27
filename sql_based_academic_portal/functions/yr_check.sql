create or replace function yr_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
my_yr integer;
allowed_yr integer[];
temp_yr integer;
yr_present integer :=0;

begin

-- if ( ((select current_user)<>studentid) and ((select current_user) <> 'acad') )
-- 	THEN
-- 	RAISE EXCEPTION 'You can''t access academic data of other students';
-- END IF;

my_yr = (select join_year from students where students.student_id = studentid);
allowed_yr = (select batches from prerequisite where prerequisite.course_id = courseid limit 1);

if(allowed_yr = '{}')
THEN
    yr_present = 1;
    RETURN yr_present;
END IF;

FOREACH temp_yr in ARRAY allowed_yr
LOOP
    IF temp_yr = my_yr
    THEN
        yr_present = 1;
        EXIT;
    END IF;
END LOOP;
IF(yr_present = 0)
    THEN
    RAISE EXCEPTION '% batch is not allowed to register in this course!!!', my_yr;
END IF;
return yr_present;
END;
$$;

-- select yr_check('2019mcb1213','GE103');
-- select yr_check('2019mcb1213','CS305');
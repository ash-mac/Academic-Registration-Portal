create or replace function dept_check(studentid char(11), courseid char(5))
returns integer
language plpgsql
as
$$
declare
my_dept varchar(10);
allowed_dept varchar(10)[];
temp_dept varchar(10);
dept_present integer :=0;

begin

if ( ((select current_user)<>studentid) and ((select current_user) <> 'acads') )
	THEN
	RAISE EXCEPTION 'You can''t access academic data of other students';
END IF;

my_dept = (select dept_id from students where students.student_id = studentid);
allowed_dept = (select dept_allowed from prerequisite where prerequisite.course_id = courseid limit 1);

if(allowed_dept = '{}')
THEN
    dept_present = 1;
    RETURN dept_present;
END IF;

FOREACH temp_dept in ARRAY allowed_dept
LOOP
    IF temp_dept = my_dept
    THEN
        dept_present = 1;
        EXIT;
    END IF;
END LOOP;
IF(dept_present = 0)
    THEN
    RAISE EXCEPTION '% department is not allowed to register in this course!!!', my_dept;
END IF;
return dept_present;
END;
$$;

-- select dept_check('2019mcb1213','GE103');
-- select dept_check('2019mcb1213','CS305');
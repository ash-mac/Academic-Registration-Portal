create or replace function register_in_course(studentid char(11), yr integer, semester integer, courseid char(5), sectionid integer, course_type text)
returns void
language plpgsql
as
$$
declare
course_title text;
f1 integer :=1;
course_already integer := 0 ;
-------------------------------
f2 integer := 1;		-- flag for slot check
clashes_with CHAR(5);	
section_slot record;
courseslot varchar(10);
course_yesno integer;
------------------------------
f3 integer :=1;			--flag for credit limit
permissible_credits numeric := 0;
current_sem_credits numeric := 0;
registered_course record;
this_credits numeric := 0;
-------------------------------
f4 integer := 1;
--------------
yr_present integer := 0;
dept_present integer :=0;
current_cgpa numeric;
required_cgpa numeric;
prereq_cleared integer := 0;
begin
-- passed this course earlier or not

EXECUTE 'select count(*) from (select course_id from '
        ||quote_ident('trans_'||studentid)
        ||' where course_id = $1 and grade >= 4) as foo'
INTO course_already
USING courseid;
if(course_already = 1)
THEN
f1 = 0;
RAISE EXCEPTION 'You have already passed this course!';
END IF;
-----------------------------------------------------------------------------------------------------------
-- slot
	courseslot = (select slot_id from section_slot_info where course_id = courseid);
	course_yesno = (select count(*) from (select * from teaches where (teaches.course_id,teaches.sem,teaches.year,teaches.section_id) = (courseid,semester,yr,sectionid)) as temp);
	if(course_yesno = 0)
	THEN
	RAISE EXCEPTION 'No such course offered this semester % and year % with sectionID %.', semester,yr,sectionid;
	END IF;
	clashes_with = check_slot(studentid,courseslot);
	if(clashes_with <> '00000')
		THEN
		f2 = 0;
		RAISE EXCEPTION 'You have % clashing with this course',clashes_with;
	end if;
---------------------------------------------------------------------------------------------------------------
-- credit limit
permissible_credits = check_credits(studentid,semester,yr);
for registered_course in EXECUTE FORMAT('select * from  %I','register_'||studentid)
	LOOP
		if(registered_course.sem = semester and registered_course.year = yr)
		THEN
		current_sem_credits = current_sem_credits + registered_course.credits;
		END IF;
	END LOOP;
this_credits = (select credits from course_catalogue where course_id = courseid);

IF((this_credits + current_sem_credits) > permissible_credits)
	THEN
	f3 = 0;
	RAISE EXCEPTION 'Credit Limit Exceeded, You may generate a ticket.';
END IF;

---------------------------------------------------------------------------------------------------------
-- prerequisite
	-- yr/batch
    yr_present = yr_check(studentid,courseid);
    -- dept
    dept_present = dept_check(studentid, courseid);
    --cgpa
    required_cgpa = (select cgpa from prerequisite where prerequisite.course_id = courseid limit 1);
    current_cgpa = calculate_CGPA(studentid);
    if(current_cgpa < required_cgpa)
    THEN
    RAISE EXCEPTION 'You require atleast % CGPA to register, your current CGPA is %', required_cgpa,current_cgpa;
    END IF;
	--prereq course pass or not
    prereq_cleared =  prereq_check(studentid,courseid);


EXECUTE FORMAT('
INSERT INTO %I
values(''%s'',%s);
',yr||'_'||semester||'_'||courseid||'_enrollment',studentid,sectionid);
course_title  = (select title from course_catalogue where course_id = courseid);


EXECUTE FORMAT('
INSERT INTO %I
values(%s,%s,''%s'',''%s'',''%s'',%s);
','register_'||studentid,yr,semester,courseid,course_title,course_type,this_credits);
end;
$$;

--check user DONE
--grant permission DONE

-- select register_in_course('2019mcb1213',2019,1,'MA101',2,'science_core');
-- select register_in_course('2019csb1111',2019,1,'MA101',1,'science_core');
-- select register_in_course('2019eeb1211',2019,1,'MA101',1,'science_core');
-- select register_in_course('2021mcb1222',2021,1,'GE103',1,'science_core');
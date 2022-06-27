CREATE OR REPLACE FUNCTION check_graduation(student_id char(11))
RETURNS VOID
LANGUAGE plpgsql
AS
$func$
declare
    course record;
    total_credits NUMERIC := 0; 
    current_cgpa NUMERIC(4, 2) := 0;
    course_type_credits_check BOOLEAN := FALSE;
    status BOOLEAN := FALSE;
    lacking_credits NUMERIC := 0;
BEGIN
    for course in EXECUTE FORMAT('select credits, grade
        from %I','trans_'||student_id)

    loop
        if course.grade >= 4 then
		total_credits = total_credits + course.credits;
	end if;
    end loop;
    lacking_credits = 145 - total_credits;

    current_cgpa = calculate_CGPA(student_id);
    if current_cgpa < 5 then
	status = FALSE;
    elsif total_credits < 145 then
	status = FALSE;
    end if;
    if current_cgpa < 5 then
	raise notice '% has CGPA = %, which is less than 5 (the minimum CGPA required to graduate)', student_id, current_cgpa;
    elsif total_credits < 145 then
	raise notice '% has to get % more credits as he has only secured % credits, while a student needs to accumulate 145 credits for basic B.Tech degree', student_id, lacking_credits, total_credits;
    else
	course_type_credits_check = check_course_category_credits(student_id);
    end if;

    if course_type_credits_check = FALSE then
	status = FALSE;
    else
        status = TRUE;
    end if;

    if status = FALSE then
	raise notice 'The Student is not ready to graduate';
    else
	raise notice 'The Student is ready to graduate';
    end if;
RETURN;
END;
$func$;


CREATE OR REPLACE FUNCTION check_course_category_credits(student_id char(11))
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$func$
declare
    course record;
    total_pc_credits NUMERIC := 0; -- pc -> program core
    total_pe_credits NUMERIC := 0; -- pe -> program elective
    total_sc_credits NUMERIC := 0; -- sc -> science core
    total_oe_credits NUMERIC := 0; -- oe -> open elective
    lacking_pc_credits NUMERIC := 0; -- pc -> program core
    lacking_pe_credits NUMERIC := 0; -- pe -> program elective
    lacking_sc_credits NUMERIC := 0; -- sc -> science core
    lacking_oe_credits NUMERIC := 0; -- oe -> open elective
    lacking_program_credits NUMERIC := 0; -- oe -> open elective
BEGIN
    for course in EXECUTE FORMAT('select credits, grade, type
        from %I','trans_'||student_id)
    loop
        if course.type = 'program_core' AND course.grade >= 4 then
		total_pc_credits = total_pc_credits + (course.credits);
	elsif course.type = 'program_elective' AND course.grade >= 4 then
		total_pe_credits = total_pe_credits + (course.credits);
	elsif course.type = 'science_core' AND course.grade >= 4 then
		total_sc_credits = total_sc_credits + (course.credits);
	elsif course.type = 'open_elective' AND course.grade >= 4 then
		total_oe_credits = total_oe_credits + (course.credits);
	end if;
    end loop;

    lacking_pc_credits = 36 - total_pc_credits;
    lacking_pe_credits = 6 - total_pe_credits;
    lacking_sc_credits = 24 - total_sc_credits;
    lacking_oe_credits = 6 - total_oe_credits;
    lacking_program_credits = 48 - (total_pc_credits + total_pe_credits);

    if total_pc_credits < 36 then
	raise notice '% has to get % more credits in Program Core Courses as he has only secured % credits, while a student needs to accumulate at least 36 credits in Program Core Courses', student_id, lacking_pc_credits, total_pc_credits;
	RETURN FALSE;
    elsif total_pe_credits < 6 then
	raise notice '% has to get % more credits in Program Elective Courses as he has only secured % credits, while a student needs to accumulate at least 6 credits in Program Elective Courses', student_id, lacking_pe_credits, total_pe_credits;
	RETURN FALSE;
    elsif (total_pc_credits + total_pe_credits) < 48 then
	raise notice '% has to get % more credits in Program Courses (Electives + Core) as he has only secured % credits, while a student needs to accumulate at least 48 credits in Program Courses', student_id, lacking_program_credits, (total_pc_credits + total_pe_credits);
	RETURN FALSE;
    elsif total_sc_credits < 24 then
	raise notice '% has to get % more credits in Science Core Courses as he has only secured % credits, while a student needs to accumulate at least 24 credits in Science Core Courses', student_id, lacking_sc_credits, total_sc_credits;
	RETURN FALSE;
    elsif total_oe_credits < 6 then
	raise notice '% has to get % more credits in Open Elective Courses as he has only secured % credits, while a student needs to accumulate at least 6 credits in Open Elective Courses', student_id, lacking_oe_credits, total_oe_credits;
	RETURN FALSE;
    else
	RETURN TRUE;
    end if;
RETURN TRUE;
END;
$func$;

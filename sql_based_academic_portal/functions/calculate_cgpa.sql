CREATE OR REPLACE FUNCTION calculate_CGPA(studentid char(11))
RETURNS NUMERIC
LANGUAGE plpgsql
AS
$$
declare
    course record;
    total_points NUMERIC := 0;
    total_credits NUMERIC := 0;
BEGIN
    for course in EXECUTE FORMAT('select credits, grade from %I','trans_'||studentid)
    loop
	if(course.grade >=4)
	THEN
        total_points = total_points + (course.credits*course.grade);
        total_credits = total_credits + (course.credits);
	END IF;
    end loop;
if (total_credits = 0)
then
return 0;
end if;
RETURN (total_points/total_credits);
END;
$$;
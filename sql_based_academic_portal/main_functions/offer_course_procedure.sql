-- faculty id verified in teaches table's trigger
create or replace procedure offer_course(course char(5),semester integer, yr integer, faculty_id varchar(50),slot varchar(10),
                                         min_cgpa numeric default 0,batches_allowed int[] default '{}',depts_allowed varchar(10)[] default '{}')
language plpgsql
as

$$
declare
num_sections integer;
section_alloted integer default 1;
target_info record;
begin
if((select count(*) from section_slot_info where section_slot_info.course_id = course) = 0)
	THEN num_sections = 
	(select num_sect
	from slots
	where slot_id = slot);
	insert into course_offering(course_id,sem,year)
	values(course,semester,yr);
	insert into teaches(course_id,sem,year,fac_id,section_id)
	values(course,semester,yr,faculty_id,section_alloted);
	-- verify fac_id with username in trigger teaches DONE
	insert into section_slot_info(course_id,slot_id,num_sect,sect_occupied)
	values(course,slot,num_sections,1);
	UPDATE prerequisite
	SET batches = batches_allowed,
	cgpa = min_cgpa,
	dept_allowed = depts_allowed
	WHERE course_id = course;
else
	if((select count(*) from section_slot_info where section_slot_info.course_id = course and section_slot_info.num_sect = section_slot_info.sect_occupied) = 0)
		THEN
		UPDATE section_slot_info
		SET sect_occupied = sect_occupied + 1
		WHERE course_id = course;
		section_alloted = (select sect_occupied from section_slot_info where section_slot_info.course_id = course);
		insert into teaches(course_id,sem,year,fac_id,section_id)
		values(course,semester,yr,faculty_id,section_alloted);
		RAISE INFO 'The course requirements are already decided by the course coordinator.';
	else
		RAISE EXCEPTION 'Sorry, the course already has required number of faculties, contact acads.';
		RETURN;
	END IF;
END IF;
end;
$$;
-- UPDATE prerequisite
-- SET batches = batches_allowed,
-- cgpa = min_cgpa,
-- dept_allowed = depts_allowed
-- WHERE course_id = course;


create or replace function check_slot(studentid char(11),course_slot varchar(5))
returns char(5)
language plpgsql
as
$$
declare
register_row record;
section_row record;
begin
for  register_row in EXECUTE FORMAT('select * from %I','register_'||studentid)
LOOP
	for section_row in (select * from section_slot_info where section_slot_info.course_id = register_row.course_id)
	LOOP
		if(section_row.slot_id = course_slot)
		THEN
		return register_row.course_id;
		end if;
	END LOOP;
END LOOP;
return '00000';
end;
$$;

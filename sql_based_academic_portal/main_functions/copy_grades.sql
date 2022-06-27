CREATE OR REPLACE FUNCTION copy_grades(sem_val INTEGER, year_val INTEGER)
RETURNS VOID
LANGUAGE plpgsql
AS
$$
declare
    course record;
    trans_insert record;
    course_title text;
    course_credits numeric;
    course_type text;
    student_join_year integer;
    student_branch text;
BEGIN
    for course in (select * from teaches)
    loop
        if course.sem=sem_val AND course.year=year_val then
            for trans_insert in EXECUTE FORMAT('select * from %I',course.course_id||'_'||course.fac_id||'_'||course.sem||'_'||course.year)
            loop
                -- ignore, just used for debugging purposes     RAISE INFO '% % % % % % % %', 'trans_'||trans_insert.student_id, course.year, course.sem, course.course_id,course.course_id,course.course_id,course.sem,trans_insert.grade;
                course_title = (select title from course_catalogue where lower(course_catalogue.course_id) = lower(course.course_id));
                course_credits = (select credits from course_catalogue where lower(course_catalogue.course_id) = lower(course.course_id));
                student_join_year = (select join_year from students where students.student_id = trans_insert.student_id);
                student_branch = (select dept_id from students where students.student_id = trans_insert.student_id);
                -- type is remaining
                -- RAISE INFO '%',course_title;
                -- RAISE INFO '%',student_join_year;
                -- RAISE INFO '%',student_branch;
 
                
               
               EXECUTE 'select type from '||quote_ident('btech_'||student_join_year)
                ||' where lower(course_id) = lower($1)' INTO course_type USING course.course_id;
                EXECUTE 'select type from '||quote_ident(lower(student_branch)||'_'||student_join_year)
                ||' where lower(course_id) = lower($1)' INTO course_type USING course.course_id;
                course_type = 'open_elective';
                EXECUTE format('INSERT INTO %I VALUES(%s, %s, %L, %L, %L, %s, %s)', 'trans_'||trans_insert.student_id, course.year, course.sem, course.course_id, course_title, course_type, course_credits, trans_insert.grade);
            end loop;
        end if;
    end loop;
    RETURN;
END;
$$;
 
select copy_grades(2,2021);

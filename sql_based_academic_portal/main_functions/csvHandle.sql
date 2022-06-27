\c - acad
password

create or replace function csv_upload_grade(courseid char(5), facid varchar(50), semester integer, yr integer,filePath text)
returns void
language plpgsql
as
$$
declare
begin
if ((select current_user)<>facid)
	THEN
	RAISE EXCEPTION 'Kindly enter your own faculty ID for uploading grade.';
END IF;
IF((select count(*) from teaches where (course_id,sem,teaches.year,fac_id)=(courseid,semester,yr,facid)) = 1)
THEN
    EXECUTE FORMAT('
    COPY %I
    FROM ''%s''
    DELIMITER '',''
    CSV HEADER;
    ',courseid||'_'||facid||'_'||semester||'_'||yr,filePath);
END IF;
end;
$$;
\c - apurv1
password
select csv_upload_grade('CS101','apurv1',2,2021,'C:\Users\Ashish Sharma\Desktop\cs301_project\submission\main_functions\sample.csv');
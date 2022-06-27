INSERT INTO departments(dept_id,dept_name)
VALUES('cs','computer_science');

INSERT INTO departments(dept_id,dept_name)
VALUES('ee','electrical');

INSERT INTO departments(dept_id,dept_name)
VALUES('ma','mathematics');

INSERT INTO departments(dept_id,dept_name)
VALUES('xy','');

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('99999','','xy',0,0,0,0,0);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('GE103','intro_to_computing_and_data_structures','cs',3,0,3,7.5,4.5);

INSERT INTO prerequisite
values('GE103','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS101','Discrete Maths','cs',3,1,0,5,3);

INSERT INTO prerequisite
values('CS101','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS201','Data Structures','cs',3,1,2,6,4);

INSERT INTO prerequisite
values('CS201','GE103',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS301','Databases','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('MA101','Calculus','ma',3,1,0,5,3);

INSERT INTO prerequisite
values('MA101','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('MA411','Real Analysis','ma',3,1,0,5,3);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS203','Digital Logic Design','cs',3,1,3,6,4);

INSERT INTO prerequisite
values('CS203','99999',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS204','Computer Architecture','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS303','Operating Systems','cs',3,1,2,6,4);

INSERT INTO course_catalogue(course_id,title,dept_id,lec_hr,tut_hr,prac_hr,ss_hr,credits)
VALUES('CS305','Software Engineering','cs',3,0,2,7,4);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS201','GE103',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS301','CS201',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS204','CS203',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS305','CS301',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('CS305','CS303',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO prerequisite(course_id,prereq_id,batches,dept_allowed,cgpa)
VALUES('MA411','MA101',DEFAULT,DEFAULT,DEFAULT);

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PCE-1',DEFAULT,'09:00','09:50',DEFAULT,'{"mon","wed","fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PCE-2',2,'10:00','10:50',DEFAULT,'{"tue","thu","fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-1',DEFAULT,'09:00','09:50',DEFAULT,'{"mon","wed"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-2',2,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('PC-3',1,'16:00','17:50','lab','{"fri"}');

INSERT INTO slots(slot_id,num_sect,start_time,end_time,slot_type,days)
VALUES('HSME',2,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

select enroll_faculty('balesh1', 'Balesh Kumar', 'ma');
select enroll_faculty('tapas1', 'Tapas Chatterjee', 'ma');
select enroll_faculty('prabhakar1', 'Madeti Prabhakar', 'ma');
select enroll_faculty('puneet1', 'Puneet Goyal', 'cs');
select enroll_faculty('shirshendu1', 'Shirshendu Das', 'cs');
select enroll_faculty('sudarshan1', 'Sudarshan Iyengar', 'cs');
select enroll_faculty('viswanath1', 'Viswanath Gunturi', 'cs');
select enroll_faculty('balwinder1', 'Balwinder Sodhi', 'cs');
select enroll_faculty('neeraj1', 'Neeraj Goyal', 'cs');
select enroll_faculty('kalyan1', 'TV Kalyan', 'cs');

\c - prabhakar1
password
CALL offer_course('MA101',1,2019,'prabhakar1','HSME');

CALL offer_course('MA101',1,2019,'tapas1','HSME',9);

\c - tapas1
password
CALL offer_course('MA101',1,2019,'tapas1','HSME',9);

\c - balesh1
password
CALL offer_course('MA411',1,2020,'balesh1','PCE-1',batches_allowed => '{2019}',min_cgpa => 7);

\c - shirshendu1
password
CALL offer_course('GE103',1,2021,'shirshendu1','PC-2',batches_allowed => '{2020}');

\c - puneet1
password
CALL offer_course('GE103',1,2021,'puneet1','PC-2',batches_allowed => '{2020}');

\c - viswanath1
password
CALL offer_course('CS301',1,2021,'viswanath1','PCE-1',batches_allowed => '{2019}');

\c - puneet1
password
CALL offer_course('CS201',1,2020,'puneet1','PCE-2', batches_allowed => '{2019}', min_cgpa => 6);

select enroll_student('2020mcb1001', 'Adhish Prasad', 'ma',2020);
select enroll_student('2020mcb1002', 'Mahesh Shree', 'ma',2020);
-- select enroll_student('2019csb1111', 'Ramu Kumar', 'cs',2019);
select enroll_student('2019csb1112', 'Raman Kumar', 'cs',2019);
select enroll_student('2019eeb1222', 'Ashwin S', 'ee',2019);
select enroll_student('2019mcb1003', 'Ramesh', 'ma',2019);

-- CALL offer_course('CS201',1,2020,'puneet','PC-1',7,'{2019,2018}','{''cs'',''MA''}');
-- CALL offer_course('GE103',1,2021,'shirshendu','PC-1',0,'{2020,2021}','{}');
-- select * from enroll_student('2019csb1111', 'Ramu', 'cs', 2019);

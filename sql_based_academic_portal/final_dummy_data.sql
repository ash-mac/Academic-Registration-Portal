insert into departments (dept_id, dept_name)
VALUES
('CS','Computer Science'),
('MA', 'Mathematics'),
('EE', 'Electrical and Electronics');

select * from enroll_student('2019mcb1222', 'Adhish Prasad', 'MA',2019);
select * from enroll_student('2018csb1113', 'Mahesh Shree', 'CS',2018);
select * from enroll_student('2019csb1111', 'Ramu Kumar', 'CS',2019);
select * from enroll_student('2019eeb1211', 'Raman Kumar', 'EE',2019);
select * from enroll_student('2019mcb1213', 'Ashish Sharma', 'MA',2019);
select * from enroll_student('2021mcb1222', 'Ramesh', 'MA',2021);

select * from enroll_faculty('balesh', 'Balesh Kumar', 'MA');
select * from enroll_faculty('tapas', 'Tapas Chatterjee', 'MA');
select * from enroll_faculty('prabhakar', 'Madeti Prabhakar', 'MA');
select * from enroll_faculty('puneet', 'Puneet Goyal', 'CS');
select * from enroll_faculty('shirshendu', 'Shirshendu Das', 'CS');
select * from enroll_faculty('sudarshan', 'Sudarshan Iyengar', 'CS');
select * from enroll_faculty('viswanth', 'Viswanath Gunturi', 'CS');




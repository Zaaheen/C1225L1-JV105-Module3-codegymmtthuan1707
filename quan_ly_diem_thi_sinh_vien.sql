use quan_ly_diem_thi_sinh_vien;

create table classes(
	class_id int not null auto_increment,
    class_name varchar(255) not null,
    start_date datetime not null,
    status bit,
    primary key (class_id)
);
create table students(
	student_id int not null auto_increment,
    class_id int not null,
    student_name varchar(255) not null,
    address varchar(50),
    phone varchar(10),
    status bit,
    primary key (student_id),
    foreign key (class_id) references classes(class_id)
);
create table subjects(
	subject_id int not null auto_increment,
    subject_name varchar(255) not null,
    credit tinyint not null default 1 check ( credit >= 1),
    status bit default 1,
    primary key (subject_id)
);
create table marks(
	mark_id int not null auto_increment,
    student_id int not null,
    subject_id int not null,
    mark float default 0 check ( mark between 0 and 100),
    exam_time tinyint default 1,
    unique (student_id, subject_id, exam_time),
    primary key (mark_id),
    foreign key (student_id) references students(student_id),
	foreign key (subject_id) references subjects(subject_id)
);

insert into classes (class_id, class_name, start_date, status)
values
	(1, 'a1', '2008-12-20', 1),
	(2, 'a2', '2008-12-22', 1),
	(3, 'b3', current_date, 0);
    
insert into students (student_name, address, phone, status, class_id)
values
	('Hung', 'Ha Noi', '0912113113', 1, 1),
    ('Hoa', 'Hai phong', '0912113007', 1, 1),
    ('Manh', 'HCM', '0123123123', 0, 2);

insert into subjects 
values 
	(1, 'CF', 5, 1),
	(2, 'C', 6, 1),
	(3, 'HDJ', 5, 1),
	(4, 'RDBMS', 10, 1);
    
insert into marks (subject_id, student_id, mark, exam_time)
values 
	(1, 1, 8, 1),
	(1, 2, 10, 2),
	(2, 1, 12, 1);
    
select * from classes;
select * from students;
select * from subjects;
select * from marks;
use quan_ly_sinh_vien;

create table classes (
    id int not null auto_increment,
    class_name varchar(255) not null,
    primary key (id)
);

create table teachers (
    id int not null auto_increment,
    teacher_name varchar(255) not null,
    teacher_age int,
    country_name varchar(100),
    primary key (id)
);
drop table if exists classes;
drop table if exists teachers;
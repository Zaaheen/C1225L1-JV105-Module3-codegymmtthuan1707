use quan_ly_sinh_vien;

create table class (
    id int not null auto_increment,
    name varchar(255) not null,
    primary key (id)
);

create table teacher (
    id int not null auto_increment,
    name varchar(255) not null,
    age int,
    country varchar(100),
    primary key (id)
);
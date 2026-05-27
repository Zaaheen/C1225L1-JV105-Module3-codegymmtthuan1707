use quan_ly_ban_hang;

create table products(
	id int not null auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) not null default 0.00,
    total_quantity int not null default 0,
    description text,
    primary key (id)
);

create table customers(
	id int not null auto_increment,
    customer_name varchar(100) not null,
    phone_number varchar(10) not null unique,
    email varchar(100),
    address varchar(255),
    primary key (id)
);
create table employees (
    id int not null auto_increment,
    employee_name varchar(100) not null,
    phone_number varchar(10) not null unique,
    email varchar(100),
    address varchar(255),
    primary key (id)
);
create table orders(
	id int not null auto_increment,
    customer_id int not null, 
    employee_id int not null,
    order_date datetime,
    total_amount decimal(10,2) not null default 0.00,
    primary key (id),
    
    foreign key (customer_id) references customers(id),
    foreign key (employee_id) references employees(id)
);
create table order_details (
    id int not null auto_increment,
    order_id int not null,
    product_id int not null,
    quantity int not null default 1,
    price_at_purchase decimal(10,2) not null default 0.00,
    primary key (id),
    
    foreign key (order_id) references orders(id),
    foreign key (product_id) references products(id)
);

drop table if exists order_details;
drop table if exists orders;
drop table if exists products;
drop table if exists customers;
drop table if exists employees;
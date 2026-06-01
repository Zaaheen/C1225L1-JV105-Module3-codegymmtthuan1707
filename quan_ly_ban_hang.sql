use quan_ly_ban_hang;

drop table if exists order_details;
drop table if exists orders;
drop table if exists customer_phones;
drop table if exists employees;
drop table if exists customers;
drop table if exists products;

create table products(
	id int not null auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) default null,
    total_quantity int not null default 0,
    description text,
    primary key (id)
);

create table customers (
    id int not null auto_increment,
    customer_name varchar(100) not null,
    email varchar(100),
    address varchar(255),
    primary key (id)
);

create table customer_phones (
    phone_id int not null auto_increment,
    customer_id int not null,
    phone_number varchar(10) not null unique,
    primary key (phone_id),
    foreign key (customer_id) references customers(id) on delete cascade
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
    total_amount decimal(10,2),
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
insert into customers ( id, customer_name)
values
	(1, 'Minh Quan'),
    (2, 'Ngoc Oanh'),
    (3, 'Hong Ha');
    
insert into employees (id, employee_name, phone_number)
values
    (1, 'Nhan Vien A', '0912345678'),
    (2, 'Nhan Vien B', '0987654321'); 
    
insert into orders (id, customer_id, employee_id, order_date, total_amount)
values
    (1, 1, 1, '2006-03-21', null),
    (2, 2, 2, '2006-03-23', null),
    (3, 1, 1, '2006-03-16', null);
    
insert into products (id, product_name, price, total_quantity)
values
    (1, 'May Giat', 3.00, 100), 
    (2, 'Tu Lanh', 5.00, 100),
    (3, 'Dieu Hoa', 7.00, 100),
    (4, 'Quat', 1.00, 100),
    (5, 'Bep Dien', 2.00, 100);

insert into order_details (order_id, product_id, quantity)
values
    (1, 1, 3), 
    (1, 3, 7),  
    (1, 4, 2), 
    (2, 1, 1),
    (3, 1, 8),  
    (2, 5, 4), 
    (2, 3, 3); 
    
-- Hiển thị các thông tin  gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order
select id, order_date, total_amount 
from orders;

-- Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
select customers.id, customers.customer_name,
	group_concat( distinct products.product_name separator ', ') as 'danh sách sản phẩm'
from customers
join orders on customers.id = orders.customer_id
join order_details on orders.id = order_details.order_id
join products on order_details.product_id = products.id
group by customers.id, customers.customer_name;

-- Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
select customers.id, customer_name 
from customers
left join orders on customers.id = orders.customer_id
where orders.customer_id is null;

-- Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn
select orders.id, orders.order_date,
	sum(order_details.quantity * products.price) as total
from orders
join order_details on orders.id = order_details.order_id
join products on order_details.product_id = products.id
group by orders.id, orders.order_date;
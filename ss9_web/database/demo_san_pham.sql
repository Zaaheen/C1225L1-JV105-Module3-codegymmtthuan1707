use demo;

drop table if exists products;

create table products(
	id int not null auto_increment,
    product_code varchar(255) not null unique,
    product_name varchar(255) not null,
    product_price decimal(10,2) default null,
    product_amount int not null default 0,
    product_description text,
    product_status bit default 1,
    primary key (id)
);

insert into products (product_code, product_name, product_price, product_amount, product_description, product_status)
values
    ('P001', 'Máy Giặt Toshiba 9kg', 6500000.00, 45, 'Máy giặt lồng đứng, tiết kiệm điện inverter', 1),
    ('P002', 'Tủ Lạnh Samsung 250L', 8200000.00, 30, 'Tủ lạnh 2 cánh, có ngăn đông mềm', 1),
    ('P003', 'Điều Hòa Panasonic 1HP', 9500000.00, 20, 'Điều hòa 1 chiều, lọc bụi mịn nanoe-G', 1),
    ('P004', 'Quạt Đứng Senko', 450000.00, 120, 'Quạt đứng có điều khiển từ xa, 3 tốc độ gió', 1),
    ('P005', 'Bếp Điện Từ Sunhouse', 1200000.00, 0, 'Bếp từ đơn, mặt kính chịu nhiệt cao cấp (Hết hàng)', 0),
	('P006', 'Máy Giặt Electrolux', 12000000.00, 15, 'Máy giặt cửa ngang', 1),
    ('P007', 'Tủ Lạnh Panasonic', 15000000.00, 10, 'Tủ lạnh 3 cánh', 1),
    ('P008', 'Điều Hòa Daikin', 11000000.00, 25, 'Inverter 1.5 HP', 1);
    
select id, product_code, product_name, product_price, product_amount, product_status 
from products;
-- Tạo Unique Index trên bảng Products (sử dụng cột productCode để tạo chỉ mục)
create index idx_product_code on products(product_code);
-- Tạo Composite Index trên bảng Products (sử dụng 2 cột productName và productPrice)
create index idx_name_price on products(product_name, product_price);

show index from products;

-- Tạo view lấy về các thông tin: productCode, productName, productPrice, productStatus từ bảng products.
create view view_product as 
select product_code, product_name, product_price, product_status
from products;

select * from view_product;

-- Tiến hành sửa đổi view
create or replace view view_san_pham_con_hang as
select id, product_code, product_name, product_price, product_amount
from products
where product_amount > 0 and product_price > 500000.00;
-- Tiến hành xoá view
drop view if exists view_san_pham_con_hang;

-- Tạo store procedure lấy tất cả thông tin của tất cả các sản phẩm trong bảng product
delimiter //
create procedure sp_all_thong_tin()
begin
	select * from products;
end //
delimiter ;

call sp_all_thong_tin();

-- Tạo store procedure thêm một sản phẩm mới
delimiter //
create procedure sp_insert(
	in p_code varchar(255),
    in p_name varchar(255),
    in p_price decimal(10,2),
    in p_amount int,
    in p_description text,
    in p_status bit
)
begin
	insert into products (product_code, product_name, product_price, product_amount, product_description, product_status)
    values (p_code, p_name, p_price, p_amount, p_description, p_status);
end //
delimiter ;

call sp_insert('P009', 'Lò Vi Sóng Sharp', 2500000.00, 15, 'Lò vi sóng có nướng, 20 Lít', 1);

-- Tạo store procedure sửa thông tin sản phẩm theo id
delimiter //
create procedure sp_update_product_by_id(
    in p_id int,
    in p_code varchar(255),
    in p_name varchar(255),
    in p_price decimal(10,2),
    in p_amount int,
    in p_description text,
    in p_status bit
)
begin
    update products 
    set 
        product_code = p_code,
        product_name = p_name,
        product_price = p_price,
        product_amount = p_amount,
        product_description = p_description,
        product_status = p_status
    where id = p_id;
end //
delimiter ;

call sp_update_product_by_id(1, 'P001', 'Máy Giặt Toshiba Cải Tiến 10kg', 7000000.00, 40, 'Mẫu mới năm nay', 1);

-- Tạo store procedure xoá sản phẩm theo id
delimiter //
create procedure sp_delete_product_by_id(
    in p_id int
)
begin
    delete from products 
    where id = p_id;
end //
delimiter ;

call sp_delete_product_by_id(5);
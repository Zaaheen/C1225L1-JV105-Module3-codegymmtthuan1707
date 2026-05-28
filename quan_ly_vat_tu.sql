create database quan_ly_vat_tu;

use quan_ly_vat_tu;

create table vat_tu(
	ma_vtu int not null auto_increment,
    ten_vtu varchar(255) not null,
    primary key (ma_vtu)
);

create table phieu_xuat(
	so_px int not null auto_increment,
    ngay_xuat date,
    primary key (so_px)
);

create table phieu_nhap(
	so_pn int not null auto_increment,
    ngay_nhap date,
    primary key (so_pn)
);

create table nha_cc(
	ma_ncc int not null auto_increment,
    ten_ncc varchar(255) not null,
    dia_chi varchar(255),
    primary key (ma_ncc)
);

create table ncc_sdt(
	ma_sdt_ncc int not null auto_increment,
    ma_ncc int not null,
    sdt varchar(10) not null unique,
    primary key (ma_sdt_ncc),
    
    foreign key (ma_ncc) references nha_cc(ma_ncc) on delete cascade
);

create table don_dh(
	so_dh int not null auto_increment,
    ngay_dh date,
    ma_ncc int not null,
    primary key (so_dh),
    
    foreign key (ma_ncc) references nha_cc(ma_ncc)
);

create table phieu_xuat_chi_tiet(
	ma_px_chi_tiet int not null auto_increment,
    ma_vtu int not null,
    so_px int not null,
    sl_xuat int not null default 1,
    don_gia_xuat decimal(10,2) not null default 0.00,
    primary key (ma_px_chi_tiet),
    
    foreign key (ma_vtu) references vat_tu(ma_vtu),
    foreign key (so_px) references phieu_xuat(so_px)
);

create table phieu_nhap_chi_tiet(
	ma_pn_chi_tiet int not null auto_increment,
    ma_vtu int not null,
    so_pn int not null,
    sl_nhap int not null default 1,
    don_gia_nhap decimal(10,2) not null default 0.00,
    primary key (ma_pn_chi_tiet),
    
    foreign key (ma_vtu) references vat_tu(ma_vtu),
    foreign key (so_pn) references phieu_nhap(so_pn)
);

create table don_dh_chi_tiet(
	so_dh_chi_tiet int not null auto_increment,
    ma_vtu int not null,
    so_dh int not null,
    primary key (so_dh_chi_tiet),
    
    foreign key (ma_vtu) references vat_tu(ma_vtu),
    foreign key (so_dh) references don_dh(so_dh)
);
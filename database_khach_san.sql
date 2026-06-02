use quan_ly_khach_san;

create table loai_khach(
	ma_loai_khach int not null auto_increment,
    ten_loai_khach varchar(45),
    primary key (ma_loai_khach)
);
create table khach_hang(
	ma_khach_hang int not null auto_increment,
    ma_loai_khach int not null,
    ho_ten varchar(45) not null,
    ngay_sinh date,
    gioi_tinh bit(1) default 1,
    so_cmnd varchar(45) not null,
    so_dien_thoai varchar(45) not null,
    email varchar(45),
    dia_chi varchar(45),
    primary key (ma_khach_hang),
    foreign key (ma_loai_khach) references loai_khach(ma_loai_khach)
);
create table vi_tri(
	ma_vi_tri int not null auto_increment,
    ten_vi_tri varchar(45),
    primary key (ma_vi_tri)
);
create table trinh_do(
	ma_trinh_do int not null auto_increment,
    ten_trinh_do varchar(45),
    primary key (ma_trinh_do)
);
create table bo_phan(
	ma_bo_phan int not null auto_increment,
    ten_bo_phan varchar(45),
    primary key (ma_bo_phan)
);
create table nhan_vien(
	ma_nhan_vien int not null auto_increment,
    ma_vi_tri int not null,
	ma_trinh_do int not null,
	ma_bo_phan int not null,
    ho_ten varchar(45) not null,
    ngay_sinh date,
    so_cmnd varchar(45) not null,
    luong double not null,
    so_dien_thoai varchar(45) not null,
    email varchar(45),
    dia_chi varchar(45),
    primary key (ma_nhan_vien),
    foreign key (ma_vi_tri) references vi_tri(ma_vi_tri),
	foreign key (ma_trinh_do) references trinh_do(ma_trinh_do),
    foreign key (ma_bo_phan) references bo_phan(ma_bo_phan)
);
create table kieu_thue(
	ma_kieu_thue int not null auto_increment,
    ten_kieu_thue varchar(45),
    primary key (ma_kieu_thue)
);
create table loai_dich_vu(
	ma_loai_dich_vu int not null auto_increment,
    ten_loai_dich_vu varchar(45),
    primary key (ma_loai_dich_vu)
);
create table dich_vu(
	ma_dich_vu int not null auto_increment,
    ma_kieu_thue int not null,
    ma_loai_dich_vu int not null,
    ten_dich_vu varchar(45) not null,
    dien_tich int,
    chi_phi_thue double not null,
    so_nguoi_toi_da int,
    tieu_chuan_phong varchar(45),
    mo_ta_tien_nghi_khac varchar(45),
    dien_tich_ho_boi double,
    so_tang int,
    primary key (ma_dich_vu),	
    foreign key (ma_kieu_thue) references kieu_thue(ma_kieu_thue),
	foreign key (ma_loai_dich_vu) references loai_dich_vu(ma_loai_dich_vu)
);
create table hop_dong(
	ma_hop_dong int not null auto_increment,
    ma_nhan_vien int not null,
    ma_khach_hang int not null,
    ma_dich_vu int not null,
    ngay_lam_hop_dong datetime not null,
    ngay_ket_thuc datetime not null,
    tien_dat_coc double not null,
    primary key (ma_hop_dong),
    foreign key (ma_nhan_vien) references nhan_vien(ma_nhan_vien),
	foreign key (ma_khach_hang) references khach_hang(ma_khach_hang),
    foreign key (ma_dich_vu) references dich_vu(ma_dich_vu)
);
create table dich_vu_di_kem(
	ma_dich_vu_di_kem int not null auto_increment,
    ten_dich_vu_di_kem varchar(45) not null,
    gia double not null,
    don_vi varchar(45) not null,
    trang_thai varchar(45),
    primary key (ma_dich_vu_di_kem)
);
create table hop_dong_chi_tiet(
	ma_hop_dong_chi_tiet int not null auto_increment,
    ma_hop_dong int not null,
    ma_dich_vu_di_kem int not null,
    so_luong int not null,
    primary key (ma_hop_dong_chi_tiet),
    foreign key (ma_hop_dong) references hop_dong(ma_hop_dong),
	foreign key (ma_dich_vu_di_kem) references dich_vu_di_kem(ma_dich_vu_di_kem)
);
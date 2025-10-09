create table kullanicilar (
	kullanici_no int auto_increment primary key,
    kullanici_adi varchar(100),
    parola varchar(30),
    eposta varchar(100)
);

create table roller(
	rol_no int auto_increment,
    rol_adi varchar(100),
    primary key(rol_no)
);
-- çoktan çoğa

create table kullanici_rolleri(
	rol_no int,
    kullanici_no int,
    primary key(rol_no,kullanici_no),
    foreign key(rol_no)
		references roller(rol_no),
	foreign key(kullanici_no)
		references kullanicilar(kullanici_no)
);
create database ogrencikayit;
use ogrencikayit;

create table ogrenci(
 ogrNo int primary key not null unique,
 ogrAd varchar(40),
 ogrSoyad varchar(40),
 bolum varchar(40) 
);
insert into ogrenci(ogrNo,ogrAd,ogrSoyad,bolum)
values(1,"Mustafa Emir","Ata","Bilgisayar Mühendisliği"),
	  (2,"Hasan","Kaya","Makine Mühendisliği");
select * from ogrenci;

create table ders(
	dersKodu varchar(4) primary key not null unique,
    dersAdi varchar(30),
    ogretmen varchar(30)
);
insert into ders(dersKodu,dersAdi,ogretmen)
values('D1',"Veri Yap)lar","Ali Demir"),
("D2","Veritabani","Asli Dinc"),
("D3","Devreler","Ayse Ak"),
("D4","Elektronik","Ayse Ak");

create table kayit(
ogrNo int,
dersKodu varchar(4),
primary key(ogrNo,dersKodu),
foreign key(ogrNo) references ogrenci(ogrNo),
foreign key(dersKodu) references ders(dersKodu)
);

insert into kayit(ogrNo,dersKodu) 
values("1","D1"),
("1","D2"),
("2","D3"),
("2","D4");

-- Güncelleme işlemi

update ders set ogretmen="Fatma Yildiz" where dersKodu="D3";
select * from ders;

delete from kayit where ogrNo=2;
delete from ogrenci where ogrNo=2;











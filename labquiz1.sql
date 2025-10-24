create database kitaplık;
use kitaplık;

create table yazar(
YazarID int primary key,
Ad varchar(50),
Soyad varchar(50),
DogumTarihi date,
Ulke varchar(50)
);

insert into yazar(YazarID, Ad, Soyad, DogumTarihi, Ulke) values
(1,'Ahmet', 'Yılmaz','1980-05-10','Türkiye'),
(2, 'Ayşe', 'Demir','1970-05-10','Türkiye'),
(3, 'John', 'Doe', '1985-05-10','Amerika'),
(4,'Maria', 'Gonzalez','1990-05-10','İspanya');

select * from yazar;

create table kitap(
KitapID int primary key,
KitapAdi varchar(100),
YayinTarihi date,
SayfaSayisi int,
YazarID int,
foreign key (YazarID) references yazar(YazarID)
);

insert into kitap(KitapID, KitapAdi, YayinTarihi, SayfaSayisi, YazarID) values
(101, 'Kitap A', '2020-01-10',250,1),
(102, 'Kitap B', '2018-01-10',300,1),
(103, 'Kitap C', '2022-01-10',150,2),
(104, 'Kitap D', '2023-01-10',400,3),
(105, 'Kitap E', '2019-01-10',200,4);

select * from kitap;

insert into yazar(YazarID, Ad, Soyad, DogumTarihi, Ulke) values
(5,'Oguz', 'Atay','1980-05-10','Türkiye');

insert into kitap(KitapID, KitapAdi, YayinTarihi, SayfaSayisi, YazarID) values
(106, 'Tutunamayanlar', '2020-01-10',724,5);

-- 3
select yazar.Ad, yazar.Soyad, kitap.KitapAdi, kitap.SayfaSayisi
from yazar 
join kitap 
on yazar.YazarID = kitap.YazarID
where kitap.SayfaSayisi >= 300;

-- 4
select yazar.Ad,yazar.Soyad,kitap.SayfaSayisi
from yazar
join kitap
on yazar.YazarID=kitap.YazarID
where kitap.KitapAdi="Tutunamayanlar";




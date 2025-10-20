create database siparis_join;
use siparis_join;
create table musteriler(
	 musteri_id int primary key,
     musteri_ad varchar(50) not null,
     telefon varchar(10) unique
);
alter table musteriler
	modify telefon varchar(15) unique;


create table urun(
	 urun_id int primary key,
     urun_adi varchar(80) unique,
     urun_fiyat decimal(18,2) not null

);
create table siparisler(
	siparis_id int primary key,
    siparis_tarihi date not null,
	Musteri_id int,
    Urun_id int,
    foreign key(Urun_id)references urun(urun_id),
    foreign key(Musteri_id) references musteriler(musteri_id)

);
INSERT INTO musteriler (musteri_id,musteri_ad, telefon) VALUES
(1,'Ahmet Yılmaz', '05001112233'),
(2,'Ayşe Demir', '05002223344'),
(3,'Mehmet Kaya', '05003334455');
INSERT INTO urun (urun_id,urun_adi, urun_fiyat) VALUES
(1,'Tavuk Döner', 80),
(2,'İskender', 150),
(3,'Kola', 30);
INSERT INTO siparisler (siparis_id,musteri_id, urun_id, siparis_tarihi) VALUES
(1,1, 2, '2025-10-20'),
(2,2, 1, '2025-10-19'),
(3,3, 3, '2025-10-18'),
(4,1, 3, '2025-10-18');
select * from siparisler;

-- join sorgusu -> Müşteri adı, ürün adı, ürün fiyatı ve sipariş tarihini birlikte göster.
-- Sadece fiyatı 100 TL’den büyük olan ürünleri sipariş eden müşterileri listele.

SELECT 
    m.musteri_ad,
    u.urun_adi,
    u.urun_fiyat,
    s.siparis_tarihi
FROM siparisler s
JOIN musteriler m ON s.musteri_id = m.musteri_id
JOIN urun u ON s.urun_id = u.urun_id where m.musteri_ad="Ahmet Yılmaz" and u.urun_fiyat>=150;
-- koşulla çeğrme 




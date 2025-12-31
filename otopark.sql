create database otopark;
use otopark;


create table parkyeri(
	park_id int auto_increment primary key,
    konumkod varchar(5) not null,
    dolumu tinyint default 0,
    kat int
	

);


create table musteriler(
	musteri_id int primary key auto_increment,
    adsoyad varchar(70),
    plaka varchar(20) unique,
    bakiye decimal(10,2)
);
create index idx_plaka on Musteriler(Plaka);

create table GirisCikis(
	islem_id int primary key auto_increment,
    plaka varchar (20),
    park_id int,
    giris_saati datetime default current_timestamp,
    cikis_saati datetime null,
    ucret decimal(10,2) default 0,
    foreign key(park_id) references parkyeri(park_id)
    
);

create table logtablosu(
	log_id int auto_increment primary key,
    olay varchar(100),
    tarih datetime default current_timestamp
);

delimiter //
create trigger AracGirisTetikleyicisi
after insert on GirisCikis
for each row
begin
	update parkyeri
    set dolumu=1
    where park_id=NEW.park_id;
    insert into logtablosu(olay)
    values(concat (NEW.plaka, "plakali arac giris yapti"));
    end //
    delimiter ;

-- ucret tarifesi için stored procedure => ilk saat 20, sonras için her saat için 5 ekle

delimiter //
create procedure  ucrethesapla(in p_islem_id int)
begin
	declare icerideki_saat int;
    declare toplam_tutar decimal(10,2);
    declare giris_zamani datetime;
    
    select giris_saat into giris_zamani
    from GirisCikis
    where islem_id=p_islem_id;
    
    -- ne kadardir icerde sorgulayalim
    set icerideki_saat = timestampdiff(hour,giris_saat,now());
    if icerideki_saat<1 then
    set toplam_tutar=20;
    else
    set toplam_tutar=20+(icerideki_saat *5);
    end if;
    
    update GirisCikis
    set cikis_saati= now(),ucret=toplam_tutar
    where islem_id=p_islem_id;
    
    update parkyeri
    set dolumu=0
    where park_id=(select park_id from GirisCikis where islem_id=p_islem_id);
    select toplam_ucret as odenecek_tahsilat;
    
end //
delimiter ;

delimiter //
create procedure bakiyeyleode(in p_musteri_id int,in p_islem_id int, in p_tutar decimal(10,2))
begin
declare mevcut_bakiye decimal (10,2);

declare exit handler for sqlexception
begin
	rollback;
    select "Hata oldu, islem iptal!" as UYARI;
end;
start transaction;
-- bakiye ogrenilmesi lazim
select bakiye into mevcut_bakiye from musteriler where musteri_id=p_musteri_id;
if mevcut_bakiye>=p_tutar then
-- islem basarili olacak
update musteriler
set bakiye=bakiye-p_tutar
where musteri_id=p_musteri_id;
call ucrethesapla(p_islem_id);
-- islemleri onayla
commit;
select "Odeme basarili!" as UYARI;
else
rollback;
select "Yetersiz Bakiye" as  UYARI;
end if ;


end//
delimiter ;

-- view raporlamasi

create view iceridekiler as
select 
g.plaka,
p.konumkod,
g.giris_saati,
timestampdiff(hour,g.giris_saati,now())as gecen_saat_suresi
from GirisCikis g
join parkyeri p
on g.park_id=p.park_id
where g.cikis_saati is null;

INSERT INTO parkyeri (konumkod, kat) VALUES 
('A1', 1), 
('A2', 1), 
('B1', 2);


INSERT INTO musteriler (adsoyad, plaka, bakiye) VALUES 
('Ahmet Yılmaz', '34 KM 123', 100.00),
('Mehmet Demir', '06 ANK 999', 15.00);

SELECT * FROM parkyeri;
SELECT * FROM musteriler;

INSERT INTO GirisCikis (plaka, park_id) VALUES ('34 KM 123', 1);

INSERT INTO GirisCikis (plaka, park_id) VALUES ('06 ANK 999', 2);

SELECT * FROM parkyeri; 

SELECT * FROM logtablosu;
SELECT * FROM iceridekiler;


CALL bakiyeyleode(2, 2, 20.00);

SELECT * FROM musteriler WHERE musteri_id = 2;

SELECT * FROM GirisCikis WHERE islem_id = 2;




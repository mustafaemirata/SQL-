create database triggerdb;
use triggerdb;

create table musteriler(
	id int primary key auto_increment,
    isim varchar(40),
    bakiye int
);
create table islemler(
	islem_id int primary key auto_increment,
    musteri_id int,
    islem varchar(50),
    tutar int,
    tahsilat int
);

select * from islemler;
select * from musteriler;

create trigger insert_bakiye_sifirla before
 insert on musteriler 
 for each row 
 set new.isim=0;



create trigger beforeUpdate before update
 on musteriler 
 for each row 
 set new.bakiye=5;
 

 
 update musteriler set isim="Hüseyin" where id=1;
 select * from musteriler;


drop trigger beforeUpdate;
drop trigger insert_bakiye_sifirla;

Delimiter $$
create trigger afterInsert after insert
on islemler
for each row 
begin 
	update musteriler set bakiye =(bakiye + new.tutar-new.tahsilat)
    where id=new.musteri_id;
end$$
Delimiter ;

insert into musteriler (isim,bakiye) 
values ('Hasan',0),('Mehmet',0),('Yusuf',0),('Mete',0),('Mustafa',0);

select * from musteriler;
select * from islemler;

insert into islemler (musteri_id,islem,tutar,tahsilat)
values
(3,"Fayans Bakimi",100,50);

insert into islemler (musteri_id,islem,tutar,tahsilat)
values
(3,"tahsilar",0,50);

insert into islemler (musteri_id,islem,tutar,tahsilat)
values
(3,"tahsilat",0,50)








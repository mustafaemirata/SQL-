use  foreign_demo;
create table parcalar(
	parca_no varchar(18) primary key,
    tanim varchar(50),
    maaliyet decimal(10,2) not null check(maaliyet>=0),
    fiyat decimal(10,2) not null check(fiyat>=0)
    
    
);
-- veritabanna eklenmez
insert into parcalar(parca_no,tanim,maaliyet,fiyat)
values('A-001','Soğutucu',0,-100);

select *from parcalar;

insert into parcalar(parca_no,tanim,maaliyet,fiyat)
values('A-001','Soğutucu',0,100);

create table parcalar(
	parca_no varchar(18) primary key,
    tanim varchar(50),
    maaliyet decimal(10,2) not null check(maaliyet>=0),
    fiyat decimal(10,2) not null check(fiyat>=0),
    constraint chk_fiyat_buyuk_maaliyet check(fiyat>maaliyet)
    
    
);
drop table parcalar;
-- kst sağlanmadğndan veritabanna kaydedilmez
insert into parcalar(parca_no,tanim,maaliyet,fiyat)
values('B-003','Antifriz',50,49);
USE foreign_demo;
create table kategoriler(
	kategori_no int auto_increment primary key,
    kategori_adi varchar(255) not null
    
);
create table urunler(
	urun_no int auto_increment primary key,
    urun_adi varchar(200) not null,
    kategori_numarasi int,
    constraint fk_kategori
		foreign key (kategori_numarasi)
			references kategoriler(kategori_no)
    
);
insert into kategoriler(kategori_adi)
	values("Akilli Telefon"),
		  ("Akilli Saat");
insert into urunler(urun_adi,kategori_numarasi)
	values("iPhone",1);

update kategoriler set kategori_no=100 where kategori_no=1;
update kategoriler set kategori_no=1 where kategori_no=100;


drop table urunler ;
create table urunler(
	urun_no int auto_increment primary key,
    urun_adi varchar(200) not null,
    kategori_numarasi int,
    constraint fk_kategori
		foreign key (kategori_numarasi)
			references kategoriler(kategori_no)
            -- güncelleme yapldğdna bunlari yap (tüm tablolarda)
            on update cascade
            on delete cascade
            
    
);
insert into urunler(urun_adi,kategori_numarasi)
	values("iPhone",1),
    ("Galaxy Note",1),
    ("Air Watch",2),
    ("Samsung Galaxy Watch",2);
    update kategoriler set kategori_no=100 where kategori_no=1;
    delete from kategoriler where kategori_no=2

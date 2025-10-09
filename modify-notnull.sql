create table gorevler(
	gorev_no int auto_increment primary key,
    ad varchar(50) not null,
    baclangic_tarihi date not null,
    bitis_tarihi date
);

insert into gorevler(ad,baclangic_tarihi,bitis_tarihi)
values('Mustafa Emir Ata','2025-10-09','2025-11-09'),
('mustafa emir ata','2025-10-09',null);

-- sadece null değerleri getirme
select *from gorevler where bitis_tarihi is null;

-- null değerleri güncelleme
update gorevler
set
 bitis_tarihi=baclangic_tarihi+7
where
bitis_tarihi is null;

select*from gorevler;
insert into gorevler(ad,baclangic_tarihi,bitis_tarihi)
values('MySql Test','2025-10-19','2025-11-09'),
('mustafa emir ata','2025-10-09',null);
insert into gorevler(ad,baclangic_tarihi,bitis_tarihi)
values('MySql Null Test','2025-10-16','2025-11-09'),
('mustafa emir ata','2025-10-09',null);

-- tabloda değişiklik yapmak içic
alter table gorevler
change bitis_tarihi
	bitis_tarihi date not null;

-- change ile değeri değiştirdiğimiz için veritabanna kaydedilmez
insert into gorevler(ad,baclangic_tarihi,bitis_tarihi)
values('Change sonrasi deneme','2025-10-16','2025-11-09'),
('mustafa emir ata','2025-10-09',null);

-- nul değerleri modify kullanarak tekrar güncelledik
alter table gorevler
	modify
        bitis_tarihi date ;
        
-- veritabanna eklenir (modify ile null zorunluluğunu kaldirdik.)
INSERT INTO gorevler(ad,baclangic_tarihi,bitis_tarihi)
VALUES('mustafa emir ata modify','2025-10-09', null);

			



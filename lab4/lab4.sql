create database sinemaDB;
use sinemaDB;

create table sinema(
	sinemaNo int primary key,
    ad varchar(50),
    il varchar(50)
);

create table film(
	filmNo int primary key,
    ad varchar(50)
);

create table oyuncu(
	oyuncuNo int primary key,
    ad varchar(50)
);

create table yonetmen(
	yonetmenNo int primary key,
    ad varchar(50)
);

create table gosterir(
	sinemaNo int,
    filmNo int,
    primary key(sinemaNo,filmno),
    foreign key(sinemaNo)references sinema(sinemaNo),
	foreign key(filmno)references film(filmno)
);

create table oynar(
	filmNo int,
    oyuncuNo int,
    primary key(filmNo,oyuncuNo),
	foreign key(filmno)references film(filmno),
	foreign key(oyuncuNo)references oyuncu(oyuncuNo)

    
);

create table yonetir(
	filmNo int,
    yonetmenNo int,
    yonetmenTuru varchar(50),
    primary key (filmNo,yonetmenNo),
	foreign key(filmno)references film(filmno),
	foreign key(yonetmenNo)references yonetmen(yonetmenNo)
);

insert into sinema(sinemaNo,ad,il)values
(1,"Atlas Sinemasi","İstanbul"),
(2,"Beyaz Perde","Ankara"),
(3,"Gosteri Evi","İzmir");

select * from sinema;

insert into film(filmNo,ad)values
(1,"Bir zamanlar anadolu"),
(2,"Ayla"),
(3,"Inception");

select * from film;

insert into yonetmen(yonetmenNo,ad)values
(1,"Nuri Bilge Ceylan"),
(2,"Can Ülkay"),
(3,"Christopher Nolan");

select * from yonetmen;

insert into oyuncu(oyuncuNo,ad)values
(1,"Haluk Bilginer"),
(2,"Çetin Tekindor"),
(3,"Leonardo Dicaprio");

select * from oyuncu;

insert into gosterir(sinemaNo,filmNo)values
(1,1),
(2,2),
(3,3);

insert into yonetir(filmNo,yonetmenNo,yonetmenTuru)values
(1,1,"Baş yönetmen"),
(2,2,"Yardimci yönetmen"),
(3,3,"Baş yönetmen");

insert into oynar(filmNo,oyuncuNo)values
(1,1),
(2,2),
(3,3);

select * from oynar;
select filmNo from film where ad="Bir zamanlar anadolu";
update film set ad="Harry Potter" where filmno=1;
select * from film;

select * from yonetmen;
update yonetmen set ad="J.K Rowling" where yonetmenNo=1;
select * from yonetmen;

update oyuncu set ad="Daniel Radcliffe" where oyuncuNo=1;

select filmNo from film where ad="Ayla";
delete from gosterir where filmNo=2;
delete from yonetir where filmNo=2;
delete from oynar where filmNo=2;
delete from film where filmNo=2;

-- quiz

	update film set ad="Sherlock Holmes" where filmNo=3;
    update yonetmen set ad="Arthur Conan Doyle" where yonetmenNo=3;
    update oyuncu set ad="Benedict Cumberbatch" where oyuncuNo=3;
    select * from film;
	select * from yonetmen;
    select * from oyuncu;

    
    





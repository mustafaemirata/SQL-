create table if not exists kontrol_listesi(
	yapilacak_gorev int auto_increment,
    gorev_no int,
    aciklama varchar(255) not null,
    tamamlandi boolean not null default false,
    primary key(yapilacak_gorev,gorev_no),
		foreign key(gorev_no)
		references gorevler(gorev_no)
		on update restrict 
		on delete cascade
)
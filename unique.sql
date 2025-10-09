USE foreign_demo;
CREATE TABLE IF NOT EXISTS tedarikciler(
    tedarikci_no INT AUTO_INCREMENT,
    adi VARCHAR(200) NOT NULL,
    telefon VARCHAR(12) NOT NULL UNIQUE,
    adres VARCHAR(255) NOT NULL,
    PRIMARY KEY(tedarikci_no),
    -- ad ve adres aynn olmayacak
    CONSTRAINT uk_adi_adresi UNIQUE(adi,adres)
);
insert into tedarikciler(adi,telefon,adres)
	values("ABC Sirketi","05522220634","İstanbul, kagithane");
    
select * from tedarikciler;
insert into tedarikciler(adi,telefon,adres)
	values("DEF Sirketi","05522220534","İstanbul, kagithane");
show index from tedarikciler;

-- kst kalkt
drop index uk_adi_adresi on tedarikciler;
show index from tedarikciler;

alter table tedarikciler add constraint uk_adi_adresi unique(adi,adres);
show index from tedarikciler;



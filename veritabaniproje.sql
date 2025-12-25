CREATE DATABASE sporkulubu;
USE sporkulubu;
-- kulübün böllge bilgisini tutan bolgeler tablosu
CREATE TABLE bolgeler (
    bolge_id INT AUTO_INCREMENT PRIMARY KEY,
    bolge_adi VARCHAR(100)
);
-- maçlarin neredne oynanacağn gösteren mekan tablosu
CREATE TABLE mekanlar (
    mekan_id INT AUTO_INCREMENT PRIMARY KEY,
    mekan_adi VARCHAR(100)
);
-- takimlarin brans bilgisi
CREATE TABLE branslar (
    brans_id INT AUTO_INCREMENT PRIMARY KEY,
    brans_adi VARCHAR(100)
);
-- maçlarda karşlaşlan takmlarin bilgisi
CREATE TABLE rakip_takimlar (
    rakip_id INT AUTO_INCREMENT PRIMARY KEY,
    rakip_adi VARCHAR(100)
);

-- odeme id lerinin ne anlama geldiğini tutan tanim tablosu -> normalizasyon için.
CREATE TABLE odeme_tanimlari (
    tanim_id INT AUTO_INCREMENT PRIMARY KEY,
    odeme_tarihi DATE NOT NULL,
    aciklama VARCHAR(150) NOT NULL
);

-- oyunculara işlenecek pozisyon tablosu
CREATE TABLE pozisyonlar (
    pozisyon_id INT AUTO_INCREMENT PRIMARY KEY,
    pozisyon_adi VARCHAR(50) NOT NULL
);
-- kulübün ait olduğu bölge yabanc anahtarla getirilerek tablo oluşturulur.
CREATE TABLE kulup_bilgileri (
    kulup_id INT AUTO_INCREMENT PRIMARY KEY,
    kulup_adi VARCHAR(100),
    baskan_adi VARCHAR(100),
    kurulus_yili INT,
    bolge_id INT, 
    telefon VARCHAR(20),
    FOREIGN KEY (bolge_id) REFERENCES bolgeler(bolge_id)
);
-- takimin ait olduğu brans id değeri yabanci anahtarla tabloya gelerek takim tablosu oluşturulur.
CREATE TABLE takimlar (
    takim_id INT AUTO_INCREMENT PRIMARY KEY,
    takim_adi VARCHAR(100),
    brans_id INT,
    FOREIGN KEY (brans_id) REFERENCES branslar(brans_id) ON DELETE CASCADE
);
-- oyuncunun takim id ve pozisyon id yabanc anahtar olarak tabloya geçirilerek oluşturulur.
CREATE TABLE oyuncular(
    oyuncu_id INT PRIMARY KEY, 
    oyuncu_adi VARCHAR(50),
    yas INT,
    pozisyon_id INT, -- Artık yazı değil ID tutuyoruz
    takim_id INT,
    forma_numarasi INT,
    FOREIGN KEY (takim_id) REFERENCES takimlar(takim_id),
    FOREIGN KEY (pozisyon_id) REFERENCES pozisyonlar(pozisyon_id) ON DELETE SET NULL
);
-- yedek tablo tutmak için revizyon tablosu oluşturuyoruz. Değişim tarihini de otomatik sistem tarhi olarak kaydediyoruz.
CREATE TABLE oyuncular_revision (
    yedek_id INT AUTO_INCREMENT PRIMARY KEY, 
    oyuncu_id INT,
    oyuncu_adi VARCHAR(50),
    yas INT,
    pozisyon_id INT,
    takim_id INT,
    forma_numarasi INT,
    degisim_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    islem_turu VARCHAR(20) 
);
-- antrenorun brans id si yabanc anahtarla çekilerek otomatik artan antrenor id ye sahip tablo oluşturuyoruz.
CREATE TABLE antrenorler (
    antrenor_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(100),
    soyad VARCHAR(100),
    brans_id INT,
    deneyim_yili INT,
    maas DECIMAL(10,2),
    FOREIGN KEY (brans_id) REFERENCES branslar(brans_id) ON DELETE SET NULL
);
-- tesisin ait olduğu brans ve bolge bilgileri yabanc anahtarla çekilerek tesis tablosu oluşturuyoruz.
CREATE TABLE tesisler (
    tesis_id INT AUTO_INCREMENT PRIMARY KEY,
    tesis_adi VARCHAR(100),
    brans_id INT,
    kapasite INT,
    bolge_id INT,
    FOREIGN KEY (brans_id) REFERENCES branslar(brans_id) ON DELETE SET NULL,
    FOREIGN KEY (bolge_id) REFERENCES bolgeler(bolge_id)
);
-- yapilan odemelerin cinsini, miktarini oyuncu tablosundan ve tanimlar tablosundan yabanc anahtarla çekip tablo oluşturuyoruz.
CREATE TABLE odeme_kayitlari (
    odeme_id INT AUTO_INCREMENT PRIMARY KEY,
    oyuncu_id INT NOT NULL,
    tanim_id INT NOT NULL, 
    miktar DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (oyuncu_id) REFERENCES oyuncular(oyuncu_id) ON DELETE CASCADE,
    FOREIGN KEY (tanim_id) REFERENCES odeme_tanimlari(tanim_id) ON DELETE RESTRICT
);
-- maç bilgisi oluşturma. Bu tabloda takim id rakip id ve mekan id ilgili tablolardan çekilerek yabanci anahtar olarak kullanildi.
CREATE TABLE maclar (
    mac_id INT AUTO_INCREMENT PRIMARY KEY,
    takim_id INT,
    rakip_id INT, 
    mac_tarihi DATE,
    mekan_id INT,
    FOREIGN KEY (takim_id) REFERENCES takimlar(takim_id),
    FOREIGN KEY (rakip_id) REFERENCES rakip_takimlar(rakip_id),
    FOREIGN KEY (mekan_id) REFERENCES mekanlar(mekan_id)
);
-- fikstir tablosuyla program oluşturma. Burada maclar tablosundan mac id yabanc anahtar olarak kullanildi.
CREATE TABLE fikstur (
    fikstur_id INT AUTO_INCREMENT PRIMARY KEY,
    mac_id INT,
    hafta INT,
    FOREIGN KEY (mac_id) REFERENCES maclar(mac_id)
);
-- kayit tablosu oluşturarak değişiklik izleme
CREATE TABLE sistem_loglari (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    islem_tipi VARCHAR(50),
    islem_zamani DATETIME DEFAULT CURRENT_TIMESTAMP,
    aciklama VARCHAR(255)
);
-- kulüp kasasna ait tablo tanimlamai
CREATE TABLE kulup_kasa (
    kasa_id INT PRIMARY KEY,
    toplam_bakiye DECIMAL(15,2),
    son_guncelleme DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- kasaya başlangiç değer tanimlamas
INSERT INTO kulup_kasa (kasa_id, toplam_bakiye) VALUES (1, 5000000.00);
-- bolgeler tablosuna veri girişi
INSERT INTO bolgeler (bolge_id, bolge_adi) VALUES (1, 'Kadıköy'), (2, 'Ataşehir'), (3, 'Dereağzı'), (4, 'Acıbadem'), (5, 'Pendik'), (6, 'Üsküdar'), (7, 'Ümraniye'), (8, 'Erciyes');
-- mekan tablosuna veri girişi
INSERT INTO mekanlar (mekan_id, mekan_adi) VALUES (1, 'Ülker Stadyumu'), (2, 'Deplasman'), (3, 'Ülker Spor Salonu'), (4, 'Burhan Felek Salonu'), (5, 'Ev Sahibi Salon'), (6, 'Olimpik Havuz'), (7, 'Kadıköy Kortları'), (8, 'Olimpiyat Stadı'), (9, 'Deplasman Pisti'), (10, 'Dereağzı Tesisleri'), (11, 'Fikirtepe Sahası'), (12, 'Ev Sahibi Saha'), (13, 'Tırmanış Duvarı'), (14, 'Erciyes Pisti'), (15, 'Uludağ'), (16, 'Sarıkamış'), (17, 'Lokal Salon');
-- branş tablosuna veri girişi
INSERT INTO branslar (brans_adi) VALUES ('Futbol'),('Basketbol'),('Voleybol'),('Hentbol'),('Yüzme'),('Tenis'),('Atletizm'),('Boks'),('Karate'),('Judo'),('Güreş'),('Ragbi'),('Masa Tenisi'),('Badminton'),('Okçuluk'),('Halter'),('Eskrim'),('Dağcılık'),('Kayak'),('Dart');

-- branşlardaki oyuncularn pozisyon bilgisini tanimlama
INSERT INTO pozisyonlar (pozisyon_id, pozisyon_adi) VALUES
(1, 'Forvet'), (2, 'Orta Saha'), (3, 'Kanat'), (4, 'Bek'), (5, 'Kaleci'), (6, 'Stoper'), 
(7, 'Guard'), (8, 'Pivot'), 
(9, 'Libero'), (10, 'Smaçör'), (11, 'Pasör'), (12, 'Orta Oyuncu'), 
(13, 'Sol Kanat'), (14, 'Sağ Oyun Kurucu'), 
(15, 'Serbest Stil'), (16, 'Kelebek'), (17, 'Sırtüstü'), (18, 'Kurbağalama'),
(19, 'Tek Erkekler'), (20, 'Çift Erkekler'), 
(21, '100m Koşu'), (22, 'Uzun Atlama'), (23, 'Yüksek Atlama'), (24, 'Maraton'), 
(25, 'Ağır Sıklet'), (26, 'Orta Sıklet'), (27, 'Hafif Sıklet'), (28, 'Tüy Sıklet'), 
(29, 'Kumite'), (30, 'Kata'), 
(31, '60kg'), (32, '73kg'), (33, '81kg'), (34, '90kg'), 
(35, 'Serbest 74kg'), (36, 'Grekoromen 87kg'), (37, 'Serbest 97kg'), (38, 'Grekoromen 130kg'), 
(39, 'Hücum'), (40, 'Savunma'), (41, 'Scrum-half'),
(42, 'Sporcu'), 
(43, 'Klasik Yay'), (44, 'Makaralı Yay'), 
(45, '69kg'), (46, '85kg'), (47, '94kg'), (48, '105kg'), 
(49, 'Kılıç'), (50, 'Epe'), (51, 'Flöre'),
(52, 'Lider Tırmanış'), (53, 'Bouldering'),
(54, 'Slalom'), (55, 'Büyük Slalom'), (56, 'İniş');

-- rakip takim tanimlamalari
INSERT INTO rakip_takimlar (rakip_id, rakip_adi) VALUES
(1, 'Galatasaray'), (2, 'Beşiktaş'), (3, 'Trabzonspor'), (4, 'Başakşehir FK'), (5, 'Samsunspor'), (6, 'Anadolu Efes'), (7, 'Real Madrid'), (8, 'Panathinaikos'), (9, 'Galatasaray Ekmas'), (10, 'Olympiacos'), (11, 'Eczacıbaşı'), (12, 'Vakıfbank'), (13, 'Galatasaray Daikin'), (14, 'THY'), (15, 'Kuzeyboru'), (16, 'Beşiktaş Hentbol'), (17, 'Beykoz Bld.'), (18, 'Sakarya Bşb.'), (19, 'Spor Toto'), (20, 'İzmir Bşb.'), (21, 'Enka Spor Kulübü'), (22, 'Ted Ankara Kolejliler'), (23, 'Fmv Işık Spor'), (24, 'Kınalıada Su Sporları'), (25, 'Ted Spor Kulübü'), (26, 'Pamukspor'), (27, 'Taç Spor'), (28, 'Levent Tenis'), (29, 'Beşiktaş Atletizm'), (30, 'Bursa Bşb.'), (31, 'Ankara Bşb.'), (32, 'Ankara Boks İhtisas'), (33, 'Kocaeli Boks'), (34, 'Mersin Boks'), (35, 'Kağıthane Karate'), (36, 'Pendik Karate'), (37, 'İBB Spor Kulübü'), (38, 'Gaziantep Bşb.'), (39, 'İzmir Bşb. Judo'), (40, 'Manisa Judo'), (41, 'ASKİ Spor'), (42, 'İstanbul Bşb.'), (43, 'Tedaş Spor'), (44, 'ODTÜ Ragbi'), (45, 'Hacettepe Ragbi'), (46, 'Çukurova Üniversitesi'), (47, 'Sarkuysan'), (48, 'Erzincan Türk Telekom'), (49, 'Ankara EGO'), (50, 'Okçular Vakfı'), (51, 'Antalya Okçuluk'), (52, 'Ankara Halter'), (53, 'Konya Halter'), (54, 'Altınyurt'), (55, 'Bursa Eskrim'), (56, 'Zirve Dağcılık'), (57, 'Akut Spor'), (58, 'Erzurum Kayak'), (59, 'Bursa Uludağ'), (60, 'Bursa Dart'), (61, 'Ankara Dart');

-- odeme islemlerinde kullanilan id'ye ait durum tanimlamalari
INSERT INTO odeme_tanimlari (tanim_id, odeme_tarihi, aciklama) VALUES (1, '2025-09-15', 'Eylül 2025 Maaş'), (2, '2025-09-15', 'Eylül Ödemesi'), (3, '2025-09-15', 'Maaş'), (4, '2025-09-15', 'Maaş + Prim'), (5, '2025-09-15', 'Hentbol Maaş'), (6, '2025-09-15', 'Müsabaka Desteği'), (7, '2025-09-15', 'Burs ve Maaş'), (8, '2025-09-15', 'Turnuva Primi Dahil'), (9, '2025-09-15', 'Maraton Özel Ödemesi'), (10, '2025-09-15', 'Başarı Primi Dahil'), (11, '2025-09-15', 'Milli Takım Desteği');

-- kulübün bilgilerini tanimlama
INSERT INTO kulup_bilgileri (kulup_adi, baskan_adi, kurulus_yili, bolge_id, telefon) VALUES ('Fenerbahçe Spor Kulübü', 'Saadettin Saran', 1907, 1, '0216 216 1907');
-- 20 bransa ait takimlarin taimlanmasi
INSERT INTO takimlar (takim_adi, brans_id) VALUES ('Fenerbahçe Futbol Takımı',1), ('Fenerbahçe Beko',2), ('Fenerbahçe Medicana',3), ('Fenerbahçe Hentbol Takımı',4), ('Fenerbahçe Yüzme Takımı',5), ('Fenerbahçe Tenis Takımı',6), ('Fenerbahçe Atletizm Takımı',7), ('Fenerbahçe Boks Takımı',8), ('Fenerbahçe Karate Takımı',9), ('Fenerbahçe Judo Takımı',10), ('Fenerbahçe Güreş Takımı',11), ('Fenerbahçe Ragbi Takımı',12), ('Fenerbahçe Masa Tenisi Takımı',13), ('Fenerbahçe Badminton Takımı',14), ('Fenerbahçe Okçuluk Takımı',15), ('Fenerbahçe Halter Takımı',16), ('Fenerbahçe Eskrim Takımı',17), ('Fenerbahçe Dağcılık Ekibi',18), ('Fenerbahçe Kayak Takımı',19), ('Fenerbahçe Dart Takımı',20);
-- antrenor bilgisi kayitlari
INSERT INTO antrenorler (ad, soyad, brans_id, deneyim_yili, maas) VALUES ('Bayram','Sanat',1,12,45000), ('Mehmet','Demir',2,10,42000), ('Selçuk','Kaya',3,8,38000), ('Emre','Aydın',4,6,36000), ('Uğur','Bozkurt',5,15,50000), ('Kerem','Öztürk',6,9,39000), ('Suat','Deniz',7,7,35000), ('Harun','Tok',8,11,41000), ('Mert','Karaca',9,5,32000), ('Yasin','Güler',10,10,40000), ('Bilal','Arslan',11,9,37000), ('Ufuk','Korkmaz',12,4,30000), ('Okan','Şahin',13,6,34000), ('Serkan','Bulut',14,8,36000), ('İlker','Sarp',15,12,43000), ('Furkan','Boz',16,7,35000), ('Taylan','Yıldırım',17,10,38000), ('Cem','Ekinci',18,6,31000), ('Baran','Dursun',19,5,30000), ('Recep','Altun',20,9,34000);

-- tesis bilgisi kayitlari
INSERT INTO tesisler (tesis_adi, brans_id, kapasite, bolge_id) VALUES ('Can Bartu Tesisleri',1,50000, 1), ('Ülker Spor Salonu',2,15000, 2), ('Metro Enerji Salonu',3,8000, 2), ('Fenerbahçe Hentbol Antrenman Salonu',4,3000, 1), ('Fenerbahçe Yüzme Havuzu',5,2000, 3), ('Fenerbahçe Tenis Kortları',6,1500, 1), ('Fenerbahçe Atletizm Sahası',7,5000, 2), ('Fenerbahçe Boks Salonu',8,1200, 1), ('Fenerbahçe Karate Dojo',9,400, 4), ('Fenerbahçe Judo Salonu',10,600, 4), ('Fenerbahçe Güreş Salonu',11,900, 1), ('Fenerbahçe Ragbi Sahası',12,3000, 5), ('Fenerbahçe Masa Tenisi Salonu',13,500, 2), ('Fenerbahçe Badminton Kortu',14,400, 1), ('Fenerbahçe Okçuluk Sahası',15,2000, 6), ('Fenerbahçe Halter Salonu',16,350, 1), ('Fenerbahçe Eskrim Salonu',17,250, 1), ('Fenerbahçe Dağcılık Merkezi',18,150, 7), ('Fenerbahçe Kayak Merkezi',19,800, 8), ('Fenerbahçe Dart Salonu',20,150, 1);
-- oyuncular tablosuna veri girişleri
INSERT INTO oyuncular (oyuncu_id, oyuncu_adi, yas, pozisyon_id, takim_id, forma_numarasi) VALUES
(1, 'Jhon Duran', 22, 1, 1, 9), (2, 'Fred', 31, 2, 1, 35), (3, 'Kerem Aktürkoğlu', 26, 3, 1, 17), (4, 'Youssef En Nesyri', 29, 1, 1, 19), (5, 'Dorgeles Nene', 21, 3, 1, 11), (6, 'Szymanski', 25, 2, 1, 53), (7, 'Nelson Semedo', 24, 4, 1, 2), (8, 'Livakovic', 29, 5, 1, 40), (9, 'Archie Brown', 24, 4, 1, 3), (10, 'Alexander Djiku', 29, 6, 1, 6), (11, 'Edson Alvarez', 28, 2, 1, 4), (12, 'Mert Hakan', 28, 2, 1, 8), (13, 'Serdar Aziz', 33, 6, 1, 90), (14, 'Lincoln', 25, 2, 1, 10), (15, 'İrfan Can Kahveci', 28, 2, 1, 7), (16, 'Oosterwolde', 23, 4, 1, 24), (17, 'King', 32, 1, 1, 15), (18, 'Samuel', 27, 3, 1, 21), (19, 'Yusuf Akçiçek', 21, 2, 1, 99), (20, 'Arda Güler', 19, 2, 1, 10),
(21, 'Scottie Wilbekin', 31, 7, 2, 3), (22, 'Nick Calathes', 35, 7, 2, 33), (23, 'Marko Guduric', 29, 1, 2, 23), (24, 'Motley', 28, 8, 2, 5), (25, 'Dorsey', 28, 7, 2, 22), (26, 'Booker', 30, 1, 2, 1), (27, 'Hayes', 29, 1, 2, 11), (28, 'Papagiannis', 26, 8, 2, 9), (29, 'Tarık Biberovic', 23, 1, 2, 13), (30, 'Metecan Birsen', 28, 1, 2, 15), (31, 'Sestina', 27, 1, 2, 77), (32, 'Yam Madar', 23, 7, 2, 41),
(33, 'Melih İnan', 24, 9, 3, 1), (34, 'Derya Çetin', 22, 10, 3, 12), (35, 'Selin Uslu', 25, 11, 3, 7), (36, 'Gülce Nur', 23, 12, 3, 5), (37, 'Elif Ada', 21, 10, 3, 4), (38, 'Ece Su', 24, 11, 3, 10), (39, 'Simge Koral', 26, 9, 3, 2), (40, 'Nazlı Çay', 22, 10, 3, 9), (41, 'Aslı Akar', 25, 12, 3, 14), (42, 'Eylül Çetin', 21, 11, 3, 18), (43, 'Sude Kara', 23, 10, 3, 6), (44, 'Duru Akman', 22, 12, 3, 8),
(45, 'Yiğit Kaan', 25, 5, 4, 1), (46, 'Selim Talu', 27, 13, 4, 5), (47, 'Eren Dural', 24, 8, 4, 10), (48, 'Oğuz Alp', 26, 14, 4, 7),
(49, 'Mert Günay', 20, 15, 5, 101), (50, 'Kerem Acar', 19, 16, 5, 102), (51, 'Selçuk Aras', 21, 17, 5, 103), (52, 'Nuri Ünlü', 22, 18, 5, 104),
(53, 'Emirhan Kaya', 24, 19, 6, 201), (54, 'Hasan Şimşek', 23, 19, 6, 202), (55, 'Timuçin Avcı', 25, 20, 6, 203), (56, 'Rıza Altun', 22, 20, 6, 204),
(57, 'Baran Aslan', 21, 21, 7, 301), (58, 'Efe Sönmez', 23, 22, 7, 302), (59, 'Sami Öztürk', 22, 23, 7, 303), (60, 'Alihan Yalçın', 24, 24, 7, 304),
(61, 'Tolga Yılmaz', 25, 25, 8, 401), (62, 'Umut Karaca', 24, 26, 8, 402), (63, 'Atakan Kılıç', 26, 27, 8, 403), (64, 'Furkan Kalkan', 23, 28, 8, 404),
(65, 'Musa Yıldırım', 22, 29, 9, 501), (66, 'Taha Kaya', 24, 30, 9, 502), (67, 'Harun Kavak', 21, 29, 9, 503), (68, 'Bekir Arslan', 23, 30, 9, 504),
(69, 'Hüseyin Çolak', 25, 31, 10, 601), (70, 'Ömer Polat', 24, 32, 10, 602), (71, 'Hakan Karadağ', 26, 33, 10, 603), (72, 'Orhan Ergin', 22, 34, 10, 604),
(73, 'Kaan Saç', 24, 35, 11, 701), (74, 'Ercan Öztürk', 27, 36, 11, 702), (75, 'Yasin Dal', 23, 37, 11, 703), (76, 'Oğuzhan Yurt', 25, 38, 11, 704),
(77, 'Mertcan Soylu', 26, 39, 12, 10), (78, 'Mustafa Arda', 24, 3, 12, 15), (79, 'Serkan Yıldız', 25, 40, 12, 5), (80, 'Oktay Gül', 23, 41, 12, 9),
(81, 'Deniz Güler', 20, 42, 13, 801), (82, 'Selçuk Erbaş', 22, 42, 13, 802), (83, 'Efe Baran', 21, 42, 13, 803), (84, 'Hamza Korkmaz', 23, 42, 13, 804),
(85, 'Yunus Eren', 22, 42, 14, 901), (86, 'Mert Taş', 24, 42, 14, 902), (87, 'Fırat Aksoy', 21, 42, 14, 903), (88, 'Sami Dursun', 23, 42, 14, 904),
(89, 'Kerem Kurt', 25, 43, 15, 1001), (90, 'Murat Kar', 22, 44, 15, 1002), (91, 'Battal Açıkgöz', 26, 43, 15, 1003), (92, 'Ufuk Üner', 24, 44, 15, 1004),
(93, 'Okan Demir', 27, 45, 16, 1101), (94, 'Bora Yiğit', 25, 46, 16, 1102), (95, 'Sinan Kara', 23, 47, 16, 1103), (96, 'Aras Bilgin', 26, 48, 16, 1104),
(97, 'Ege Akman', 21, 49, 17, 1201), (98, 'Oğuzhan Kır', 22, 50, 17, 1202), (99, 'Yiğit Efe', 23, 51, 17, 1203), (100, 'Tunahan Sönmez', 20, 49, 17, 1204),
(101, 'Enes Sarı', 28, 52, 18, 1301), (102, 'Ulaş Arı', 26, 53, 18, 1302), (103, 'Samet Kurt', 27, 52, 18, 1303), (104, 'Hüseyin Kar', 29, 53, 18, 1304),
(105, 'Burak Civelek', 22, 54, 19, 1401), (106, 'Mert Yalın', 24, 55, 19, 1402), (107, 'Ertan Keskin', 23, 56, 19, 1403), (108, 'Sinan Faydalı', 21, 54, 19, 1404),
(109, 'Hakan Demir', 35, 42, 20, 1501), (110, 'Mehmet Koz', 33, 42, 20, 1502), (111, 'Yusuf Korkut', 29, 42, 20, 1503), (112, 'Tuna Özkan', 31, 42, 20, 1504);

-- 20 tane bransa ait maç bilgisi tanmlaöa
INSERT INTO maclar (takim_id, rakip_id, mac_tarihi, mekan_id) VALUES
(1, 1, '2025-08-10', 1), (1, 2, '2025-08-17', 2), (1, 3, '2025-08-24', 1), (1, 4, '2025-08-31', 2), (1, 5, '2025-09-07', 1),
(2, 6, '2025-10-05', 3), (2, 7, '2025-10-12', 2), (2, 8, '2025-10-19', 3), (2, 9, '2025-10-26', 2), (2, 10, '2025-11-02', 3),
(3, 11, '2025-10-10', 4), (3, 12, '2025-10-17', 2), (3, 13, '2025-10-24', 4), (3, 14, '2025-10-31', 2), (3, 15, '2025-11-07', 4),
(4, 16, '2025-09-15', 5), (4, 17, '2025-09-22', 2), (4, 18, '2025-09-29', 5), (4, 19, '2025-10-06', 2), (4, 20, '2025-10-13', 5),
(5, 21, '2025-06-01', 6), (5, 9, '2025-06-08', 2), (5, 22, '2025-06-15', 6), (5, 23, '2025-06-22', 2), (5, 24, '2025-06-29', 6),
(6, 25, '2025-05-10', 7), (6, 26, '2025-05-17', 2), (6, 27, '2025-05-24', 7), (6, 21, '2025-05-31', 2), (6, 28, '2025-06-07', 7),
(7, 21, '2025-07-05', 8), (7, 29, '2025-07-12', 9), (7, 13, '2025-07-19', 8), (7, 30, '2025-07-26', 9), (7, 31, '2025-08-02', 8),
(8, 30, '2025-09-05', 10), (8, 32, '2025-09-12', 2), (8, 3, '2025-09-19', 10), (8, 33, '2025-09-26', 2), (8, 34, '2025-10-03', 10),
(9, 35, '2025-10-01', 5), (9, 36, '2025-10-08', 2), (9, 37, '2025-10-15', 5), (9, 38, '2025-10-22', 2), (9, 18, '2025-10-29', 5),
(10, 13, '2025-11-01', 5), (10, 39, '2025-11-08', 2), (10, 33, '2025-11-15', 5), (10, 3, '2025-11-22', 2), (10, 40, '2025-11-29', 5),
(11, 41, '2025-04-05', 5), (11, 42, '2025-04-12', 2), (11, 43, '2025-04-19', 5), (11, 2, '2025-04-26', 2), (11, 4, '2025-05-03', 5),
(12, 44, '2025-03-01', 11), (12, 44, '2025-03-08', 2), (12, 45, '2025-03-15', 11), (12, 21, '2025-03-22', 2), (12, 45, '2025-03-29', 11),
(13, 46, '2025-10-10', 5), (13, 29, '2025-10-17', 2), (13, 30, '2025-10-24', 5), (13, 47, '2025-10-31', 2), (13, 31, '2025-11-07', 5),
(14, 48, '2025-09-01', 5), (14, 49, '2025-09-08', 2), (14, 30, '2025-09-15', 5), (14, 5, '2025-09-22', 2), (14, 40, '2025-09-29', 5),
(15, 50, '2025-06-10', 12), (15, 20, '2025-06-17', 2), (15, 51, '2025-06-24', 12), (15, 20, '2025-07-01', 2), (15, 5, '2025-07-08', 12),
(16, 52, '2025-11-05', 5), (16, 53, '2025-11-12', 2), (16, 38, '2025-11-19', 5), (16, 30, '2025-11-26', 2), (16, 51, '2025-12-03', 5),
(17, 54, '2025-02-01', 5), (17, 31, '2025-02-08', 2), (17, 20, '2025-02-15', 5), (17, 55, '2025-02-22', 2), (17, 38, '2025-03-01', 5),
(18, 56, '2025-05-15', 13), (18, 57, '2025-05-22', 2), (18, 44, '2025-05-29', 13), (18, 44, '2025-06-05', 2), (18, 45, '2025-06-12', 13),
(19, 58, '2025-12-15', 14), (19, 59, '2025-12-22', 15), (19, 38, '2025-12-29', 14), (19, 16, '2026-01-05', 16), (19, 53, '2026-01-12', 14),
(20, 60, '2025-04-01', 17), (20, 61, '2025-04-08', 2), (20, 20, '2025-04-15', 17), (20, 51, '2025-04-22', 2), (20, 21, '2025-04-29', 17);

-- ödeme kayitlarini tanim id leri belirterek oluşturma
INSERT INTO odeme_kayitlari (oyuncu_id, miktar, tanim_id) VALUES
-- Tanım 1: 'Eylül 2025 Maaş'
(1, 250000.00, 1), (2, 350000.00, 1), (3, 200000.00, 1), (4, 280000.00, 1), (5, 150000.00, 1), (6, 220000.00, 1), (7, 180000.00, 1), (8, 210000.00, 1), (9, 140000.00, 1), (10, 190000.00, 1), (11, 230000.00, 1), (12, 120000.00, 1), (13, 110000.00, 1), (14, 130000.00, 1), (15, 175000.00, 1), (16, 145000.00, 1), (17, 160000.00, 1), (18, 170000.00, 1), (19, 50000.00, 1), (20, 250000.00, 1),
-- Tanım 2: 'Eylül Ödemesi'
(21, 180000.00, 2), (22, 160000.00, 2), (23, 150000.00, 2), (24, 140000.00, 2), (25, 135000.00, 2), (26, 130000.00, 2), (27, 145000.00, 2), (28, 125000.00, 2), (29, 90000.00, 2), (30, 85000.00, 2), (31, 100000.00, 2), (32, 95000.00, 2),
-- Tanım 3: 'Maaş'
(33, 45000.00, 3), (35, 48000.00, 3), (36, 42000.00, 3), (37, 60000.00, 3), (38, 40000.00, 3), (39, 44000.00, 3), (40, 38000.00, 3), (41, 46000.00, 3), (42, 35000.00, 3), (43, 37000.00, 3), (44, 39000.00, 3), (51, 14000.00, 3), (52, 13000.00, 3), (54, 18000.00, 3), (55, 19000.00, 3), (56, 17500.00, 3), (57, 22000.00, 3), (58, 21000.00, 3), (59, 20500.00, 3), (61, 25000.00, 3), (62, 24000.00, 3), (63, 22000.00, 3), (64, 21000.00, 3), (65, 16000.00, 3), (66, 15000.00, 3), (67, 15500.00, 3), (68, 14500.00, 3), (69, 17000.00, 3), (70, 16500.00, 3), (71, 18000.00, 3), (72, 16000.00, 3), (73, 28000.00, 3), (75, 26000.00, 3), (76, 29000.00, 3), (77, 14000.00, 3), (78, 13500.00, 3), (79, 13000.00, 3), (80, 12500.00, 3), (81, 11000.00, 3), (82, 10500.00, 3), (83, 10000.00, 3), (84, 10500.00, 3), (85, 11500.00, 3), (86, 12000.00, 3), (87, 11000.00, 3), (88, 11500.00, 3), (90, 20000.00, 3), (91, 21000.00, 3), (92, 19500.00, 3), (93, 22000.00, 3), (94, 21000.00, 3), (95, 20000.00, 3), (96, 23000.00, 3), (97, 18000.00, 3), (98, 17500.00, 3), (99, 18500.00, 3), (100, 17000.00, 3), (101, 13000.00, 3), (102, 12500.00, 3), (103, 12000.00, 3), (104, 13500.00, 3), (105, 15000.00, 3), (106, 16000.00, 3), (107, 15500.00, 3), (108, 14500.00, 3), (109, 9000.00, 3), (110, 8500.00, 3), (111, 8000.00, 3), (112, 8500.00, 3),
-- Özel Durumlar
(34, 55000.00, 4), (45, 30000.00, 5), (46, 28000.00, 5), (47, 25000.00, 5), (48, 32000.00, 5), (49, 15000.00, 6), (50, 12000.00, 7), (53, 20000.00, 8), (60, 23000.00, 9), (74, 30000.00, 10), (89, 24000.00, 11);

-- fikstür tablosuna veri girişi
INSERT INTO fikstur (mac_id, hafta) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 1), (7, 2), (8, 3), (9, 4), (10, 5), (11, 1), (12, 2), (13, 3), (14, 4), (15, 5), (16, 1), (17, 2), (18, 3), (19, 4), (20, 5), (21, 1), (22, 2), (23, 3), (24, 4), (25, 5), (26, 1), (27, 2), (28, 3), (29, 4), (30, 5), (31, 1), (32, 2), (33, 3), (34, 4), (35, 5), (36, 1), (37, 2), (38, 3), (39, 4), (40, 5), (41, 1), (42, 2), (43, 3), (44, 4), (45, 5), (46, 1), (47, 2), (48, 3), (49, 4), (50, 5), (51, 1), (52, 2), (53, 3), (54, 4), (55, 5), (56, 1), (57, 2), (58, 3), (59, 4), (60, 5), (61, 1), (62, 2), (63, 3), (64, 4), (65, 5), (66, 1), (67, 2), (68, 3), (69, 4), (70, 5), (71, 1), (72, 2), (73, 3), (74, 4), (75, 5), (76, 1), (77, 2), (78, 3), (79, 4), (80, 5), (81, 1), (82, 2), (83, 3), (84, 4), (85, 5), (86, 1), (87, 2), (88, 3), (89, 4), (90, 5), (91, 1), (92, 2), (93, 3), (94, 4), (95, 5), (96, 1), (97, 2), (98, 3), (99, 4), (100, 5);





-- maçlari id, brans, rakip adi, mekan bilgisine göre her birinin ilgili tablosundan join kullanarak id eşitleyerek getiren view
CREATE VIEW vw_mac_programi AS
SELECT 
    m.mac_id,
    b.brans_adi,
    t.takim_adi,
    rt.rakip_adi AS rakip,
    m.mac_tarihi,
    mek.mekan_adi AS yer
FROM maclar m
JOIN takimlar t ON m.takim_id = t.takim_id
JOIN branslar b ON t.brans_id = b.brans_id
JOIN rakip_takimlar rt ON m.rakip_id = rt.rakip_id
JOIN mekanlar mek ON m.mekan_id = mek.mekan_id;

-- view örneği. oyuncular tablosundan ve pozisyonlar tablosundan oyunculara ait bilgileri takimlar tablosundaki idleri eşleyerek getirme
CREATE VIEW vw_oyuncu_detay AS
SELECT 
    o.oyuncu_id,
    o.oyuncu_adi,
    o.yas,
    p.pozisyon_adi,
    t.takim_adi,
    o.forma_numarasi
FROM oyuncular o
LEFT JOIN pozisyonlar p ON o.pozisyon_id = p.pozisyon_id
JOIN takimlar t ON o.takim_id = t.takim_id;

-- oyuncular tablosundaki oyuncu ad ve maclar tablosundaki mac tarihi kisimlarindan index yaratma.
CREATE INDEX idx_oyuncu_adi ON oyuncular(oyuncu_adi);
CREATE INDEX idx_mac_tarihi ON maclar(mac_tarihi);

-- trigger örneği: burada oyuncular tablosunda bir veri silindiğinde revisionda bu değer saklanr.
DELIMITER //
CREATE TRIGGER trg_oyuncu_yedekle_silme
AFTER DELETE ON oyuncular
FOR EACH ROW
BEGIN
    INSERT INTO oyuncular_revision (oyuncu_id, oyuncu_adi, yas, pozisyon_id, takim_id, forma_numarasi, islem_turu)
    VALUES (OLD.oyuncu_id, OLD.oyuncu_adi, OLD.yas, OLD.pozisyon_id, OLD.takim_id, OLD.forma_numarasi, 'SİLİNDİ');
END //
DELIMITER ;

-- trigger örneğinde oyuncular tablosunda bir güncelleme yapldğnda oyucnular_revision tablosunda eski değerleri saklanarak
-- arşiv oluşturulur.
DELIMITER //
CREATE TRIGGER trg_oyuncu_yedekle_guncelleme
AFTER UPDATE ON oyuncular
FOR EACH ROW
BEGIN
    INSERT INTO oyuncular_revision (oyuncu_id, oyuncu_adi, yas, pozisyon_id, takim_id, forma_numarasi, islem_turu)
    VALUES (OLD.oyuncu_id, OLD.oyuncu_adi, OLD.yas, OLD.pozisyon_id, OLD.takim_id, OLD.forma_numarasi, 'GÜNCELLENDİ (ESKİ)');
END //
DELIMITER ;

-- stored procedure: antrenor bransi ve zamn orani bilgileri girilerek antrenor maasi , brans id değerine göre update edilir.
DELIMITER //
CREATE PROCEDURE sp_antrenor_maas_zam(IN p_brans_id INT, IN p_zam_orani DECIMAL(5,2))
BEGIN
    UPDATE antrenorler
    SET maas = maas + (maas * p_zam_orani / 100)
    WHERE brans_id = p_brans_id;
END //
DELIMITER ;

DELIMITER //
-- bu transactionda oyuncu id ve gönderilecek maaş tutar alnr. Daha önce ödenen maşş bilgisi var m kontrol edilir,
CREATE PROCEDURE oyuncumaasgonderme(
    IN p_oyuncu_id INT,             
    INOUT p_miktar DECIMAL(10,2),  
    OUT p_mesaj VARCHAR(100)       
)
BEGIN
    DECLARE v_mevcut_bakiye DECIMAL(15,2);
    DECLARE v_eski_odeme_var_mi INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mesaj = 'KRİTİK HATA: İşlem geri alındı!';
    END;

    START TRANSACTION;

        SELECT toplam_bakiye INTO v_mevcut_bakiye FROM kulup_kasa WHERE kasa_id = 1;

		-- girilen id değerinde oyuncu kontrolü burada yaplr.
        
        IF NOT EXISTS (SELECT 1 FROM oyuncular WHERE oyuncu_id = p_oyuncu_id) THEN
            SET p_mesaj = 'HATA: Oyuncu bulunamadı!';
            ROLLBACK;
        -- if komutlaryla kasa miktar kontrlü yapilir.
        ELSEIF v_mevcut_bakiye < p_miktar THEN
            SET p_mesaj = 'HATA: Kasada yeterli bakiye yok!';
            ROLLBACK;

        ELSE
			-- girilen miktar 50000'den büyükse üst sinir 50000'e çekeriz.
            IF p_miktar > 50000 THEN
                SET p_miktar = 50000; 
            END IF;

			-- yapilan işlemle beraber kasadan, oyuncuya ödenen para eksilir ve güncelleriz.
            UPDATE kulup_kasa 
            SET toplam_bakiye = toplam_bakiye - p_miktar 
            WHERE kasa_id = 1;

          
          -- başka kayt var m kontrol edilir.
            SELECT COUNT(*) INTO v_eski_odeme_var_mi 
            FROM odeme_kayitlari 
            WHERE oyuncu_id = p_oyuncu_id AND tanim_id = 3;

			-- eğer varsa odeme kayitlari tablosunda güncelleme yapilir ve log olarak girilen bilgiler sisteme işlenir.
            IF v_eski_odeme_var_mi > 0 THEN
                UPDATE odeme_kayitlari
                SET miktar = miktar + p_miktar
                WHERE oyuncu_id = p_oyuncu_id AND tanim_id = 3;
                
                SET p_mesaj = CONCAT('GÜNCELLEME: Oyuncunun hesabına ', p_miktar, ' TL daha eklendi.');
            ELSE
                INSERT INTO odeme_kayitlari (oyuncu_id, tanim_id, miktar)
                VALUES (p_oyuncu_id, 3, p_miktar);
                
                SET p_mesaj = CONCAT('YENİ KAYIT: Oyuncuya ilk kez ', p_miktar, ' TL ödendi.');
            END IF;
			
            -- işlem tamamlanr.
            COMMIT;
        END IF;

END //
DELIMITER ;

-- oyuncular tablosunda id değeri 122 olan kayit silinir.
DELETE FROM oyuncular WHERE oyuncu_id = 112;

-- silinen değer kontrol edilir.
SELECT * FROM oyuncular WHERE oyuncu_id = 112;
-- çooklu sorgular

-- branslar ve antrenorler tablolarndan antrenör ad ve bras adiyla beraber gruplanarak antrenör sayilari ve 
-- bunlara ödenen paralar birleştirerek sorgulanir. -> maaliyet değeri 40000'den fazla olanlar çağiririz.
SELECT 
    b.brans_adi, 
    COUNT(a.antrenor_id) AS antrenor_sayisi,
    SUM(a.maas) AS toplam_maaliyet
FROM antrenorler a
JOIN branslar b ON a.brans_id = b.brans_id
GROUP BY b.brans_adi
HAVING toplam_maaliyet > 40000
ORDER BY toplam_maaliyet DESC;


SELECT * FROM kulup_kasa;

-- transaction sorgusunda ödenecek para örnek olarak 34 değeri girilir.
SET @sonuc = '';
SET @para = 34;
CALL oyuncumaasgonderme(1, @para, @sonuc);

-- Sonuçları Gör
SELECT @sonuc AS Mesaj, @para AS Odenen;
SELECT * FROM kulup_kasa; 
SELECT * FROM odeme_kayitlari ORDER BY odeme_id DESC LIMIT 1;

-- odeme kayitlari tablosudnan sralanir ve daha önce ödemesi olduğundan üstüne eklenerek hesaplama yapilir.
    
-- oyuncular tablosunda oyuncu id'si 20 olanin pozisyonunu değiştirme
UPDATE oyuncular 
SET pozisyon_id = 3 
WHERE oyuncu_id = 20;

select * from oyuncular_revision;
select * from oyuncular;




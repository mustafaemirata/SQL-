CREATE DATABASE TeknolojiMagazasi;
USE TeknolojiMagazasi;

CREATE TABLE Urunler (
    urun_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(100),
    kategori VARCHAR(50),
    fiyat DECIMAL(10,2),
    stok_adedi INT
);

CREATE TABLE IslemLoglari (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    urun_id INT,
    islem_turu VARCHAR(50),
    tarih DATETIME DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE PROCEDURE UrunEkle(
    IN p_ad VARCHAR(100),
    IN p_kategori VARCHAR(50),
    IN p_fiyat DECIMAL(10,2),
    IN p_stok INT
)
BEGIN
    INSERT INTO Urunler (ad, kategori, fiyat, stok_adedi) 
    VALUES (p_ad, p_kategori, p_fiyat, p_stok);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE SatisYap(
    IN p_urun_id INT,
    IN p_adet INT
)
BEGIN
    UPDATE Urunler 
    SET stok_adedi = stok_adedi - p_adet 
    WHERE urun_id = p_urun_id;

    INSERT INTO IslemLoglari (urun_id, islem_turu) 
    VALUES (p_urun_id, 'Satış Yapıldı - Stok Düştü');
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE KDVHesapla(INOUT p_fiyat DECIMAL(10,2))
BEGIN
    SET p_fiyat = p_fiyat * 1.20;
END //

DELIMITER ;

CALL UrunEkle('iPhone 15', 'Telefon', 50000, 100);
CALL UrunEkle('MacBook Air M2', 'Bilgisayar', 35000, 50);
CALL UrunEkle('AirPods Pro', 'Kulaklık', 8000, 200);

SELECT * FROM Urunler;


CALL SatisYap(2, 5);

SELECT * FROM Urunler;
SELECT * FROM IslemLoglari;

SET @fiyat = 1000;
CALL KDVHesapla(@fiyat); 
SELECT @fiyat; 
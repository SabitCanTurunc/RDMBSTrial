use kutuphane;
DELIMITER //

CREATE FUNCTION KontrolKitapDurumu(
    p_KitapAdi VARCHAR(100)
) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE v_Durum VARCHAR(255);

    -- Kitaplar tablosundan kitap durumunu al
    SELECT 
        CASE
            WHEN Durum = 0 THEN 'Kitap raflarda.'
            WHEN Durum = 1 THEN 'Kitap ödünçte.'
            ELSE 'Bilinmeyen durum.'
        END INTO v_Durum
    FROM Kitaplar
    WHERE Baslik = p_KitapAdi;

    RETURN v_Durum;
END //

DELIMITER ;




SELECT KontrolKitapDurumu("Suç ve Ceza") AS Durum;
DELIMITER //

CREATE FUNCTION GetKategoriByKitap(KitapAdi VARCHAR(100)) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE kategoriAdi VARCHAR(50);
    
    SELECT k.Ad INTO kategoriAdi
    FROM Kategoriler k
    JOIN KitapKategorileri kk ON k.KategoriID = kk.KategoriID
    JOIN Kitaplar kt ON kk.KitapID = kt.KitapID
    WHERE kt.Baslik = KitapAdi
    LIMIT 1;
    
    RETURN kategoriAdi;
END//

DELIMITER ;




SELECT GetKategoriByKitap('Suç ve Ceza') AS Kategori;

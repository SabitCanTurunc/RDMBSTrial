-- Kitap Ekle Procedure


-- Kitap Ekle Procedure
DROP PROCEDURE IF EXISTS KitapEkle;




DELIMITER //
CREATE PROCEDURE KitapEkle(
    IN p_Baslik VARCHAR(100),
    IN p_YazarAd VARCHAR(50),
    IN p_KategoriAd VARCHAR(50)
)
BEGIN
    DECLARE v_YazarID INT;
    DECLARE v_KategoriID INT;
    DECLARE v_KitapID INT;

    -- Yazarı kontrol et ve varsa ID'sini al, yoksa ekle ve ID'sini al
    INSERT INTO Yazarlar (Ad) VALUES (p_YazarAd)
    ON DUPLICATE KEY UPDATE YazarID = LAST_INSERT_ID(YazarID);

    SELECT YazarID INTO v_YazarID FROM Yazarlar WHERE Ad = p_YazarAd LIMIT 1;

    -- Kategoriyi kontrol et ve ekle
    INSERT IGNORE INTO Kategoriler (Ad) VALUES (p_KategoriAd);
    SELECT KategoriID INTO v_KategoriID FROM Kategoriler WHERE Ad = p_KategoriAd LIMIT 1;

    -- Kitabı kontrol et, eğer varsa tekrar ekleme
    IF NOT EXISTS (SELECT 1 FROM Kitaplar WHERE Baslik = p_Baslik AND YazarID = v_YazarID) THEN
        -- Kitabı ekle
        INSERT INTO Kitaplar (Baslik, YazarID, Durum) VALUES (p_Baslik, v_YazarID, FALSE);
        SELECT LAST_INSERT_ID() INTO v_KitapID;

        -- Kitap-Kategori ilişkisini ekle
        INSERT INTO KitapKategorileri (KitapID, KategoriID) VALUES (v_KitapID, v_KategoriID);
    END IF;
END //
DELIMITER ;


DELIMITER //
-- OduncKitapVer Prosedürü
CREATE PROCEDURE OduncKitapVer(
    IN p_KitapAd VARCHAR(100),
    IN p_UserID INT,
    IN p_OduncTarihi DATE,
    IN p_TeslimTarihi DATE
)
BEGIN
    DECLARE v_UserID INT;
    DECLARE v_KitapID INT;
    DECLARE v_KitapDurum TINYINT;

    -- Kullanıcıyı kontrol et
    IF NOT EXISTS (SELECT 1 FROM Users WHERE UserID = p_UserID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Belirtilen kullanıcı bulunamadı.';
    END IF;

    -- Kitabı kontrol et ve ID'sini ve durumunu al
    SELECT KitapID, Durum INTO v_KitapID, v_KitapDurum FROM Kitaplar WHERE Baslik = p_KitapAd;

    -- Eğer kitap bulunamazsa hata dönebilirsiniz
    IF v_KitapID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Belirtilen isimde bir kitap bulunamadı.';
    END IF;

    -- Eğer kitap ödünçteyse başkasına ödünç verme
    IF v_KitapDurum = 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Belirtilen kitap şu anda ödünçte ve başkasına verilemez.';
    END IF;

    -- OduncKitaplar tablosuna ekle
    INSERT INTO OduncKitaplar (UserID, KitapID, OduncTarihi, TeslimTarihi, Durum)
    VALUES (p_UserID, v_KitapID, p_OduncTarihi, p_TeslimTarihi, 1); -- 1: True (Odunc durumu)

    -- Kitaplar tablosundaki durumu güncelle
    UPDATE Kitaplar SET Durum = 1 WHERE KitapID = v_KitapID;
    
END //



-- KitapTeslimEt Prosedürü

DELIMITER //

CREATE PROCEDURE KitapTeslimEt(
    IN p_KitapAd VARCHAR(100),
    IN p_TeslimTarihi DATE
)
BEGIN
    DECLARE v_KitapDurum BOOL;
    DECLARE v_UserID INT;
    DECLARE v_KitapID INT;

    -- Kitap durumunu kontrol et ve kullanıcı ID'sini al
    SELECT o.Durum, o.UserID, o.KitapID INTO v_KitapDurum, v_UserID, v_KitapID
    FROM OduncKitaplar o
    JOIN Kitaplar k ON o.KitapID = k.KitapID
    WHERE k.Baslik = p_KitapAd AND o.Durum = TRUE
    LIMIT 1; -- Yalnızca bir satır al

    -- Eğer kitap ödünçteyse (Durum = TRUE), teslim tarihini güncelle ve Durum'u FALSE olarak ayarla
    IF v_KitapDurum THEN
        UPDATE OduncKitaplar
        SET TeslimTarihi = p_TeslimTarihi, Durum = FALSE
        WHERE KitapID = v_KitapID AND OduncTarihi <= p_TeslimTarihi; -- Güvenli WHERE şartı

        -- Kitaplar tablosundaki durumu güncelle
        UPDATE Kitaplar SET Durum = FALSE WHERE KitapID = v_KitapID;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Belirtilen kitap ödünçte değil veya bulunamadı.';
    END IF;
END //
DELIMITER ;




-- ornek cagrilar
CALL KitapEkle("Beyaz Diş", "Jack London", "roman");
CALL KitapEkle("Suç ve Ceza", "Fyodor Dostoyevsky", "roman");
CALL KitapEkle("1984", "George Orwell", "bilim kurgu");
CALL KitapEkle("Sefiller", "Victor Hugo", "roman");
CALL KitapEkle("Küçük Kadınlar", "Louisa May Alcott", "roman");
CALL KitapEkle("Kayıp Zamanın İzinde", "Marcel Proust", "roman");
CALL KitapEkle("Yeraltından Notlar", "Fyodor Dostoyevsky", "roman");
CALL KitapEkle("To Kill a Mockingbird", "Harper Lee", "roman");
CALL KitapEkle("Satranç", "Stefan Zweig", "roman");
CALL KitapEkle("One Hundred Years of Solitude", "Gabriel Garcia Marquez", "roman");


CALL OduncKitapVer('Suç ve Ceza', 1, '2023-01-01', '2023-02-01');

CALL KitapTeslimEt('Suç ve Ceza','20231222');
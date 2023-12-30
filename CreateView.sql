-- view and masking

USE kutuphane;
CREATE VIEW VW_TumKitaplar AS
SELECT 
   Kitaplar.KitapID,
   Kitaplar.Baslik,
   Yazarlar.Ad AS YazarAdi
FROM Kitaplar
INNER JOIN Yazarlar ON Kitaplar.YazarID = Yazarlar.YazarID;


SELECT * FROM VW_TumKitaplar;

CREATE VIEW VW_OdunctekiKitaplar AS
SELECT 
   OduncKitaplar.OduncID,
   Kitaplar.Baslik,
   Musteriler.Ad AS MusteriAdi,
   Musteriler.Telefon,
   OduncKitaplar.OduncTarihi,
   OduncKitaplar.TeslimTarihi
FROM OduncKitaplar
INNER JOIN Kitaplar ON OduncKitaplar.KitapID = Kitaplar.KitapID
INNER JOIN Musteriler ON OduncKitaplar.MusteriID = Musteriler.MusteriID
WHERE OduncKitaplar.Durum = 1; -- Ödünçteki kitaplar

SELECT * FROM VW_OdunctekiKitaplar;


CREATE VIEW VW_AktifKategoriler AS
SELECT 
   Kategoriler.KategoriID,
   Kategoriler.Ad
FROM Kategoriler
INNER JOIN KitapKategorileri ON Kategoriler.KategoriID = KitapKategorileri.KategoriID
GROUP BY Kategoriler.KategoriID, Kategoriler.Ad
HAVING COUNT(KitapKategorileri.KitapID) > 0;

SELECT * FROM VW_AktifKategoriler;


CREATE VIEW VW_EnCokOduncAlanMusteriler AS
SELECT 
   Musteriler.MusteriID,
   Musteriler.Ad,
   Musteriler.Soyad,
   Musteriler.Telefon,
   COUNT(OduncKitaplar.OduncID) AS OduncSayisi
FROM Musteriler
LEFT JOIN OduncKitaplar ON Musteriler.MusteriID = OduncKitaplar.MusteriID
GROUP BY Musteriler.MusteriID, Musteriler.Ad, Musteriler.Soyad, Musteriler.Telefon
ORDER BY OduncSayisi DESC; 


SELECT * FROM VW_EnCokOduncAlanMusteriler;

CREATE VIEW VW_AktifOduncAlinabilecekKitaplar AS
SELECT
   Kitaplar.KitapID,
   Kitaplar.Baslik,
   Yazarlar.Ad AS YazarAdi
FROM Kitaplar
LEFT JOIN OduncKitaplar ON Kitaplar.KitapID = OduncKitaplar.KitapID AND OduncKitaplar.Durum = 1
LEFT JOIN Yazarlar ON Kitaplar.YazarID = Yazarlar.YazarID
WHERE OduncKitaplar.KitapID IS NULL OR OduncKitaplar.Durum = 0;

SELECT * FROM VW_AktifOduncAlinabilecekKitaplar;

CREATE VIEW VW_MusterilerMaskeleme AS
SELECT
    MusteriID,
    Ad,
    Soyad,
    CONCAT('XXX-XXX-', RIGHT(Telefon, 4)) AS MaskeTelefon
FROM
    Musteriler;
    
SELECT * FROM VW_MusterilerMaskeleme;



USE kutuphane;

-- Tüm Kitaplar View
CREATE VIEW VW_TumKitaplar AS
SELECT 
   Kitaplar.KitapID,
   Kitaplar.Baslik,
   Yazarlar.Ad AS YazarAdi
FROM Kitaplar
INNER JOIN Yazarlar ON Kitaplar.YazarID = Yazarlar.YazarID;

-- Odünçteki Kitaplar View
CREATE VIEW VW_OdunctekiKitaplar AS
SELECT 
   OduncKitaplar.OduncID,
   Kitaplar.Baslik,
   Users.Ad AS MusteriAdi,
   Users.Telefon,
   OduncKitaplar.OduncTarihi,
   OduncKitaplar.TeslimTarihi
FROM OduncKitaplar
INNER JOIN Kitaplar ON OduncKitaplar.KitapID = Kitaplar.KitapID
INNER JOIN Users ON OduncKitaplar.UserID = Users.UserID
WHERE OduncKitaplar.Durum = 1; -- Ödünçteki kitaplar

-- Aktif Kategoriler View
CREATE VIEW VW_AktifKategoriler AS
SELECT 
   Kategoriler.KategoriID,
   Kategoriler.Ad
FROM Kategoriler
INNER JOIN KitapKategorileri ON Kategoriler.KategoriID = KitapKategorileri.KategoriID
GROUP BY Kategoriler.KategoriID, Kategoriler.Ad
HAVING COUNT(KitapKategorileri.KitapID) > 0;

-- En Çok Ödünç Alan Müşteriler View
CREATE VIEW VW_EnCokOduncAlanMusteriler AS
SELECT 
   Users.UserID,
   Users.Ad,
   Users.Soyad,
   Users.Telefon,
   COUNT(OduncKitaplar.OduncID) AS OduncSayisi
FROM Users
LEFT JOIN OduncKitaplar ON Users.UserID = OduncKitaplar.UserID
GROUP BY Users.UserID, Users.Ad, Users.Soyad, Users.Telefon
ORDER BY OduncSayisi DESC; 

-- Aktif Ödünç Alınabilecek Kitaplar View
CREATE VIEW VW_AktifOduncAlinabilecekKitaplar AS
SELECT
   Kitaplar.KitapID,
   Kitaplar.Baslik,
   Yazarlar.Ad AS YazarAdi
FROM Kitaplar
LEFT JOIN OduncKitaplar ON Kitaplar.KitapID = OduncKitaplar.KitapID AND OduncKitaplar.Durum = 1
LEFT JOIN Yazarlar ON Kitaplar.YazarID = Yazarlar.YazarID
WHERE OduncKitaplar.KitapID IS NULL OR OduncKitaplar.Durum = 0;

-- Müşteriler Maskeleme View
CREATE VIEW VW_MusterilerMaskeleme AS
SELECT
    Users.UserID AS MusteriID,
    Users.Ad,
    Users.Soyad,
    CONCAT('XXX-XXX-', RIGHT(Users.Telefon, 4)) AS MaskeTelefon
FROM
    Users;


-- Tüm Kitaplar View'ı çağırma
SELECT * FROM VW_TumKitaplar;
-- Ödünçteki Kitaplar View'ı çağırma
SELECT * FROM VW_OdunctekiKitaplar;
-- Aktif Kategoriler View'ı çağırma
SELECT * FROM VW_AktifKategoriler;
-- En Çok Ödünç Alan Müşteriler View'ı çağırma
-- Aktif Ödünç Alınabilecek Kitaplar View'ı çağırma
SELECT * FROM VW_AktifOduncAlinabilecekKitaplar;
-- Müşteriler Maskeleme View'ı çağırma
SELECT * FROM VW_MusterilerMaskeleme;





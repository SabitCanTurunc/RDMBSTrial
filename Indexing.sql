use kutuphane;
-- Email sütunu için UNIQUE indeksleme ekleniyor.
CREATE UNIQUE INDEX idx_Users_Email ON Users(Email);

-- Telefon sütunu için UNIQUE indeksleme ekleniyor.
CREATE UNIQUE INDEX idx_Users_Telefon ON Users(Telefon);

-- YazarID sütunu için indeksleme ekleniyor.
CREATE INDEX idx_Kitaplar_YazarID ON Kitaplar(YazarID);

-- KitapID sütunu için indeksleme ekleniyor.
CREATE INDEX idx_KitapKategorileri_KitapID ON KitapKategorileri(KitapID);

-- KategoriID sütunu için indeksleme ekleniyor.
CREATE INDEX idx_KitapKategorileri_KategoriID ON KitapKategorileri(KategoriID);

-- UserID sütunu için indeksleme ekleniyor.
CREATE INDEX idx_OduncKitaplar_UserID ON OduncKitaplar(UserID);

-- KitapID sütunu için indeksleme ekleniyor.
CREATE INDEX idx_OduncKitaplar_KitapID ON OduncKitaplar(KitapID);


-- ındexleme
use kutuphane;
-- Yazarlar tablosunda Ad sütununu indeksleme
CREATE INDEX idx_ad ON Yazarlar(Ad);

-- Musteriler tablosunda Ad ve Soyad sütunlarını içeren bir indeks oluşturma
CREATE INDEX idx_ad_soyad ON Musteriler(Ad, Soyad);

-- Kitaplar tablosunda Baslik sütununu indeksleme
CREATE INDEX idx_baslik ON Kitaplar(Baslik);

-- Kitaplar tablosunda YazarID sütununu indeksleme
CREATE INDEX idx_yazar_id ON Kitaplar(YazarID);

-- KitapKategorileri tablosunda KitapID ve KategoriID sütunlarını içeren bir bileşik indeks oluşturma
CREATE INDEX idx_kitap_kategorileri ON KitapKategorileri(KitapID, KategoriID);

-- OduncKitaplar tablosunda MusteriID, KitapID ve OduncTarihi sütunlarını içeren bir bileşik indeks oluşturma
CREATE INDEX idx_odunc_kitaplar ON OduncKitaplar(MusteriID, KitapID, OduncTarihi);

-- OduncKitaplar tablosunda TeslimTarihi sütununu indeksleme
CREATE INDEX idx_teslim_tarihi ON OduncKitaplar(TeslimTarihi);

-- OduncKitaplar tablosunda Durum sütununu indeksleme
CREATE INDEX idx_durum ON OduncKitaplar(Durum);

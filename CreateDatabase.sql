-- Veritabanı Tasarımı
create database kutuphane;
USE  kutuphane;

CREATE TABLE Yazarlar(
YazarID INT  PRIMARY KEY AUTO_INCREMENT,
Ad varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Musteriler (
    MusteriID INT  PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL
);

CREATE TABLE Kategoriler (
    KategoriID INT PRIMARY KEY AUTO_INCREMENT,
    Ad VARCHAR(50) UNIQUE NOT NULL
);


CREATE TABLE Kitaplar (
    KitapID INT PRIMARY KEY AUTO_INCREMENT,
    Baslik VARCHAR(100) NOT NULL,
	Durum BOOL DEFAULT FALSE,
    YazarID INT,
    FOREIGN KEY (YazarID) REFERENCES Yazarlar(YazarID)
);
create TABLE KitapKategorileri (
    KitapID INT ,
    KategoriID INT,
    PRIMARY KEY (KitapID, KategoriID),
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID),
    FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);

CREATE TABLE OduncKitaplar (
    OduncID INT PRIMARY KEY AUTO_INCREMENT,
    MusteriID INT,
    KitapID INT,
    OduncTarihi DATE NOT NULL,
    TeslimTarihi DATE,
    Durum BOOL DEFAULT TRUE,
    
    CONSTRAINT CHK_Tarih CHECK (OduncTarihi <= TeslimTarihi),
    CONSTRAINT CHK_TeslimTarihi CHECK (TeslimTarihi >= OduncTarihi),
    FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID),
	CONSTRAINT FK_KitapDurum FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID)
);


DROP DATABASE KUTUPHANE;





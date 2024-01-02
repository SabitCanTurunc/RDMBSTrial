-- Veritabanı Tasarımı
CREATE DATABASE kutuphane;
USE kutuphane;

CREATE TABLE Yazarlar (
    YazarID INT PRIMARY KEY AUTO_INCREMENT,
    Ad VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50),
    PasswordHash VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    AktifMi BOOL NOT NULL,
    Telefon VARCHAR(20) NOT NULL UNIQUE,
    UserRole ENUM('admin', 'regular_user') DEFAULT 'regular_user'
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

CREATE TABLE KitapKategorileri (
    KitapID INT,
    KategoriID INT,
    PRIMARY KEY (KitapID, KategoriID),
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID),
    FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);

CREATE TABLE OduncKitaplar (
    OduncID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    KitapID INT,
    OduncTarihi DATE NOT NULL,
    TeslimTarihi DATE,
    Durum BOOL DEFAULT TRUE,
    CONSTRAINT CHK_Tarih CHECK (OduncTarihi <= TeslimTarihi),
    CONSTRAINT CHK_TeslimTarihi CHECK (TeslimTarihi >= OduncTarihi),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID),
    CONSTRAINT FK_KitapDurum FOREIGN KEY (KitapID) REFERENCES Kitaplar(KitapID)
);
DROP DATABASE KUTUPHANE;
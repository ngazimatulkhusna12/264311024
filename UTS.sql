CREATE DATABASE IF NOT EXISTS posyandu_stunting
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE posyandu_stunting;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS EDUKASI_GIZI;
DROP TABLE IF EXISTS PEMBERIAN_IMUNISASI;
DROP TABLE IF EXISTS NOTIFIKASI;
DROP TABLE IF EXISTS REKAP_BULANAN;
DROP TABLE IF EXISTS RUJUKAN;
DROP TABLE IF EXISTS STATUS_GIZI;
DROP TABLE IF EXISTS PEMBERIAN_SUPLEMEN;
DROP TABLE IF EXISTS KUNJUNGAN;
DROP TABLE IF EXISTS PENUGASAN_KADER;
DROP TABLE IF EXISTS JADWAL_POSYANDU;
DROP TABLE IF EXISTS BALITA;
DROP TABLE IF EXISTS KONTAK_ORTU;
DROP TABLE IF EXISTS PETUGAS_PUSKESMAS;
DROP TABLE IF EXISTS KADER;
DROP TABLE IF EXISTS ORANG_TUA;
DROP TABLE IF EXISTS PENGGUNA;
DROP TABLE IF EXISTS PUSKESMAS;
DROP TABLE IF EXISTS POSYANDU;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE POSYANDU (
  id_posyandu VARCHAR(12) PRIMARY KEY,
  nama_posyandu VARCHAR(120) NOT NULL,
  dusun VARCHAR(80),
  desa VARCHAR(80) NOT NULL,
  kecamatan VARCHAR(80) NOT NULL,
  kabupaten VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE PUSKESMAS (
  id_puskesmas VARCHAR(12) PRIMARY KEY,
  nama_puskesmas VARCHAR(120) NOT NULL,
  jalan VARCHAR(150),
  desa VARCHAR(80),
  kecamatan VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE PENGGUNA (
  id_pengguna VARCHAR(12) PRIMARY KEY,
  nama VARCHAR(120) NOT NULL,
  username VARCHAR(60) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(24) NOT NULL,
  CONSTRAINT ck_pengguna_role CHECK (role IN ('KADER','PETUGAS_PUSKESMAS'))
) ENGINE=InnoDB;

CREATE TABLE ORANG_TUA (
  id_ortu VARCHAR(12) PRIMARY KEY,
  nik CHAR(16) UNIQUE,
  nama VARCHAR(120) NOT NULL,
  hubungan VARCHAR(12) NOT NULL,
  pekerjaan VARCHAR(80),
  rt VARCHAR(3),
  rw VARCHAR(3),
  dusun VARCHAR(80),
  desa VARCHAR(80),
  CONSTRAINT ck_ortu_hubungan CHECK (hubungan IN ('AYAH','IBU','WALI'))
) ENGINE=InnoDB;

CREATE TABLE KONTAK_ORTU (
  id_ortu VARCHAR(12) NOT NULL,
  no_wa VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_ortu, no_wa),
  CONSTRAINT fk_kontak_ortu FOREIGN KEY (id_ortu)
    REFERENCES ORANG_TUA(id_ortu) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE KADER (
  id_pengguna VARCHAR(12) PRIMARY KEY,
  id_posyandu VARCHAR(12) NOT NULL,
  jabatan VARCHAR(30) NOT NULL,
  CONSTRAINT fk_kader_pengguna FOREIGN KEY (id_pengguna)
    REFERENCES PENGGUNA(id_pengguna) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_kader_posyandu FOREIGN KEY (id_posyandu)
    REFERENCES POSYANDU(id_posyandu) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_kader_jabatan CHECK (jabatan IN ('KETUA','ANGGOTA_BKB','KADER'))
) ENGINE=InnoDB;

CREATE TABLE PETUGAS_PUSKESMAS (
  id_pengguna VARCHAR(12) PRIMARY KEY,
  id_puskesmas VARCHAR(12) NOT NULL,
  jabatan VARCHAR(60) NOT NULL,
  CONSTRAINT fk_petugas_pengguna FOREIGN KEY (id_pengguna)
    REFERENCES PENGGUNA(id_pengguna) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_petugas_puskesmas FOREIGN KEY (id_puskesmas)
    REFERENCES PUSKESMAS(id_puskesmas) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE BALITA (
  id_balita VARCHAR(12) PRIMARY KEY,
  nik CHAR(16) UNIQUE,
  nama VARCHAR(120) NOT NULL,
  tgl_lahir DATE NOT NULL,
  jenis_kelamin CHAR(1) NOT NULL,
  berat_lahir DECIMAL(5,2),
  panjang_lahir DECIMAL(5,2),
  id_ortu VARCHAR(12) NOT NULL,
  id_posyandu VARCHAR(12) NOT NULL,
  id_kader VARCHAR(12) NOT NULL,
  CONSTRAINT fk_balita_ortu FOREIGN KEY (id_ortu)
    REFERENCES ORANG_TUA(id_ortu) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_balita_posyandu FOREIGN KEY (id_posyandu)
    REFERENCES POSYANDU(id_posyandu) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_balita_kader FOREIGN KEY (id_kader)
    REFERENCES KADER(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_balita_jk CHECK (jenis_kelamin IN ('L','P')),
  CONSTRAINT ck_balita_berat_lahir CHECK (berat_lahir IS NULL OR berat_lahir > 0),
  CONSTRAINT ck_balita_panjang_lahir CHECK (panjang_lahir IS NULL OR panjang_lahir > 0)
) ENGINE=InnoDB;

CREATE TABLE JADWAL_POSYANDU (
  id_jadwal VARCHAR(12) PRIMARY KEY,
  id_posyandu VARCHAR(12) NOT NULL,
  tanggal DATE NOT NULL,
  jam_mulai TIME NOT NULL,
  jenis_kegiatan VARCHAR(100) NOT NULL,
  CONSTRAINT uq_jadwal_posyandu UNIQUE (id_posyandu, tanggal, jam_mulai, jenis_kegiatan),
  CONSTRAINT fk_jadwal_posyandu FOREIGN KEY (id_posyandu)
    REFERENCES POSYANDU(id_posyandu) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE PENUGASAN_KADER (
  id_jadwal VARCHAR(12) NOT NULL,
  id_kader VARCHAR(12) NOT NULL,
  peran_tugas VARCHAR(40) NOT NULL,
  PRIMARY KEY (id_jadwal, id_kader),
  CONSTRAINT fk_penugasan_jadwal FOREIGN KEY (id_jadwal)
    REFERENCES JADWAL_POSYANDU(id_jadwal) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_penugasan_kader FOREIGN KEY (id_kader)
    REFERENCES KADER(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_penugasan_peran CHECK (peran_tugas IN ('PENDAFTARAN','PENIMBANGAN','PENCATATAN','IMUNISASI','EDUKASI','LAINNYA'))
) ENGINE=InnoDB;

CREATE TABLE KUNJUNGAN (
  id_kunjungan VARCHAR(12) PRIMARY KEY,
  id_balita VARCHAR(12) NOT NULL,
  id_jadwal VARCHAR(12) NOT NULL,
  id_kader VARCHAR(12) NOT NULL,
  tgl_kunjungan DATE NOT NULL,
  berat_badan DECIMAL(5,2) NOT NULL,
  tinggi_badan DECIMAL(5,2) NOT NULL,
  lingkar_kepala DECIMAL(5,2),
  cara_ukur VARCHAR(20) NOT NULL,
  CONSTRAINT uq_kunjungan_balita_jadwal UNIQUE (id_balita, id_jadwal),
  CONSTRAINT fk_kunjungan_balita FOREIGN KEY (id_balita)
    REFERENCES BALITA(id_balita) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_kunjungan_jadwal FOREIGN KEY (id_jadwal)
    REFERENCES JADWAL_POSYANDU(id_jadwal) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_kunjungan_kader FOREIGN KEY (id_kader)
    REFERENCES KADER(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_kunjungan_bb CHECK (berat_badan > 0),
  CONSTRAINT ck_kunjungan_tb CHECK (tinggi_badan > 0),
  CONSTRAINT ck_kunjungan_lk CHECK (lingkar_kepala IS NULL OR lingkar_kepala > 0),
  CONSTRAINT ck_kunjungan_cara CHECK (cara_ukur IN ('BERDIRI','TERLENTANG','LAINNYA'))
) ENGINE=InnoDB;

CREATE TABLE PEMBERIAN_SUPLEMEN (
  id_kunjungan VARCHAR(12) NOT NULL,
  jenis_suplemen VARCHAR(40) NOT NULL,
  dosis VARCHAR(60) NOT NULL,
  PRIMARY KEY (id_kunjungan, jenis_suplemen),
  CONSTRAINT fk_suplemen_kunjungan FOREIGN KEY (id_kunjungan)
    REFERENCES KUNJUNGAN(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ck_suplemen_jenis CHECK (jenis_suplemen IN ('VITAMIN_A','OBAT_CACING','LAINNYA'))
) ENGINE=InnoDB;

CREATE TABLE STATUS_GIZI (
  id_status VARCHAR(12) PRIMARY KEY,
  id_kunjungan VARCHAR(12) NOT NULL UNIQUE,
  kategori VARCHAR(30) NOT NULL,
  sumber_penilai VARCHAR(20) NOT NULL,
  tgl_penilaian DATE,
  zscore_tb_u DECIMAL(6,3),
  zscore_bb_pb DECIMAL(6,3),
  CONSTRAINT fk_status_kunjungan FOREIGN KEY (id_kunjungan)
    REFERENCES KUNJUNGAN(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT ck_status_kategori CHECK (kategori IN ('GIZI_BAIK','BERISIKO_STUNTING','STUNTING')),
  CONSTRAINT ck_status_sumber CHECK (sumber_penilai IN ('SISTEM','PUSKESMAS'))
) ENGINE=InnoDB;

CREATE TABLE RUJUKAN (
  id_rujukan VARCHAR(12) PRIMARY KEY,
  id_status VARCHAR(12) NOT NULL UNIQUE,
  id_puskesmas VARCHAR(12) NOT NULL,
  tgl_rujukan DATE NOT NULL,
  alasan TEXT NOT NULL,
  rekomendasi TEXT,
  tgl_surat DATE,
  status_tindak_lanjut VARCHAR(30) NOT NULL DEFAULT 'MENUNGGU',
  CONSTRAINT fk_rujukan_status FOREIGN KEY (id_status)
    REFERENCES STATUS_GIZI(id_status) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rujukan_puskesmas FOREIGN KEY (id_puskesmas)
    REFERENCES PUSKESMAS(id_puskesmas) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_rujukan_status CHECK (status_tindak_lanjut IN ('MENUNGGU','DIPROSES','SELESAI','BATAL'))
) ENGINE=InnoDB;

CREATE TABLE REKAP_BULANAN (
  id_rekap VARCHAR(12) PRIMARY KEY,
  id_posyandu VARCHAR(12) NOT NULL,
  id_kader VARCHAR(12) NOT NULL,
  id_pengguna_petugas VARCHAR(12),
  bulan TINYINT NOT NULL,
  tahun SMALLINT NOT NULL,
  tgl_serah DATE,
  status_serah VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
  CONSTRAINT uq_rekap_posyandu_periode UNIQUE (id_posyandu, bulan, tahun),
  CONSTRAINT fk_rekap_posyandu FOREIGN KEY (id_posyandu)
    REFERENCES POSYANDU(id_posyandu) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rekap_kader FOREIGN KEY (id_kader)
    REFERENCES KADER(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rekap_petugas FOREIGN KEY (id_pengguna_petugas)
    REFERENCES PETUGAS_PUSKESMAS(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_rekap_bulan CHECK (bulan BETWEEN 1 AND 12),
  CONSTRAINT ck_rekap_tahun CHECK (tahun BETWEEN 2000 AND 2200),
  CONSTRAINT ck_rekap_status CHECK (status_serah IN ('DRAFT','DISERAHKAN','DITERIMA')),
  CONSTRAINT ck_rekap_tanggal CHECK ((status_serah = 'DRAFT' AND tgl_serah IS NULL) OR (status_serah IN ('DISERAHKAN','DITERIMA') AND tgl_serah IS NOT NULL))
) ENGINE=InnoDB;

CREATE TABLE NOTIFIKASI (
  id_notif VARCHAR(12) PRIMARY KEY,
  id_ortu VARCHAR(12) NOT NULL,
  id_jadwal VARCHAR(12) NULL,
  jenis ENUM('JADWAL','HASIL') NOT NULL,
  kanal ENUM('WHATSAPP','PUSH') NOT NULL,
  waktu_kirim DATETIME NULL,
  status_kirim ENUM('ANTRI','TERKIRIM','GAGAL') NOT NULL DEFAULT 'ANTRI',
  CONSTRAINT fk_notif_ortu FOREIGN KEY (id_ortu)
    REFERENCES ORANG_TUA(id_ortu) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_notif_jadwal FOREIGN KEY (id_jadwal)
    REFERENCES JADWAL_POSYANDU(id_jadwal) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Aturan bisnis pengganti CHECK yang melibatkan kolom FK id_jadwal.
-- JADWAL wajib memiliki id_jadwal; HASIL tidak boleh memiliki id_jadwal.
DELIMITER $$
CREATE TRIGGER trg_notifikasi_bi
BEFORE INSERT ON NOTIFIKASI
FOR EACH ROW
BEGIN
  IF (NEW.jenis = 'JADWAL' AND NEW.id_jadwal IS NULL)
     OR (NEW.jenis = 'HASIL' AND NEW.id_jadwal IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Notifikasi JADWAL harus memiliki id_jadwal dan notifikasi HASIL harus tanpa id_jadwal';
  END IF;
END$$

CREATE TRIGGER trg_notifikasi_bu
BEFORE UPDATE ON NOTIFIKASI
FOR EACH ROW
BEGIN
  IF (NEW.jenis = 'JADWAL' AND NEW.id_jadwal IS NULL)
     OR (NEW.jenis = 'HASIL' AND NEW.id_jadwal IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Notifikasi JADWAL harus memiliki id_jadwal dan notifikasi HASIL harus tanpa id_jadwal';
  END IF;
END$$
DELIMITER ;

-- ENTITAS TAMBAHAN 1: riwayat imunisasi yang terkait pada kunjungan.
CREATE TABLE PEMBERIAN_IMUNISASI (
  id_pemberian_imunisasi VARCHAR(12) PRIMARY KEY,
  id_kunjungan VARCHAR(12) NOT NULL,
  id_pengguna_petugas VARCHAR(12),
  jenis_vaksin VARCHAR(80) NOT NULL,
  dosis_ke TINYINT UNSIGNED NOT NULL,
  tanggal_pemberian DATE,
  status_pemberian VARCHAR(20) NOT NULL,
  nomor_batch VARCHAR(60),
  keterangan TEXT,
  CONSTRAINT uq_imunisasi_per_kunjungan UNIQUE (id_kunjungan, jenis_vaksin, dosis_ke),
  CONSTRAINT fk_imunisasi_kunjungan FOREIGN KEY (id_kunjungan)
    REFERENCES KUNJUNGAN(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_imunisasi_petugas FOREIGN KEY (id_pengguna_petugas)
    REFERENCES PETUGAS_PUSKESMAS(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_imunisasi_dosis CHECK (dosis_ke >= 1),
  CONSTRAINT ck_imunisasi_status CHECK (status_pemberian IN ('DIBERIKAN','DITUNDA','TIDAK_DIBERIKAN')),
  CONSTRAINT ck_imunisasi_tanggal CHECK (status_pemberian <> 'DIBERIKAN' OR tanggal_pemberian IS NOT NULL)
) ENGINE=InnoDB;

-- ENTITAS TAMBAHAN 2: edukasi gizi yang disampaikan dalam rangkaian kunjungan.
CREATE TABLE EDUKASI_GIZI (
  id_edukasi VARCHAR(12) PRIMARY KEY,
  id_kunjungan VARCHAR(12) NOT NULL,
  id_kader VARCHAR(12) NOT NULL,
  tgl_edukasi DATE NOT NULL,
  topik VARCHAR(100) NOT NULL,
  materi TEXT NOT NULL,
  media_penyampaian VARCHAR(20) NOT NULL DEFAULT 'LISAN',
  hasil_edukasi TEXT,
  CONSTRAINT fk_edukasi_kunjungan FOREIGN KEY (id_kunjungan)
    REFERENCES KUNJUNGAN(id_kunjungan) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_edukasi_kader FOREIGN KEY (id_kader)
    REFERENCES KADER(id_pengguna) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_edukasi_media CHECK (media_penyampaian IN ('LISAN','LEAFLET','DEMONSTRASI','WHATSAPP','LAINNYA'))
) ENGINE=InnoDB;


CREATE OR REPLACE VIEW V_REKAP_KUNJUNGAN AS
SELECT
  jp.id_posyandu,
  YEAR(k.tgl_kunjungan) AS tahun,
  MONTH(k.tgl_kunjungan) AS bulan,
  COUNT(DISTINCT k.id_kunjungan) AS jumlah_ditimbang,
  SUM(CASE WHEN sg.kategori = 'BERISIKO_STUNTING' THEN 1 ELSE 0 END) AS jumlah_berisiko,
  SUM(CASE WHEN sg.kategori = 'STUNTING' THEN 1 ELSE 0 END) AS jumlah_stunting
FROM KUNJUNGAN k
JOIN JADWAL_POSYANDU jp ON jp.id_jadwal = k.id_jadwal
LEFT JOIN STATUS_GIZI sg ON sg.id_kunjungan = k.id_kunjungan
GROUP BY jp.id_posyandu, YEAR(k.tgl_kunjungan), MONTH(k.tgl_kunjungan);



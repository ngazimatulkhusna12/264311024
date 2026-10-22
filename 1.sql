-- 1. Tabel Master: posyandu
CREATE TABLE posyandu (
    id_posyandu INT PRIMARY KEY,
    nama_posyandu VARCHAR(100) NOT NULL,
    lokasi VARCHAR(255) NOT NULL
);

-- 2. Tabel Master: balita
CREATE TABLE balita (
    id_balita INT PRIMARY KEY,
    id_posyandu INT NOT NULL,
    id_pengguna INT NOT NULL,
    nik VARCHAR(16) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    tgl_lahir DATE NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    nama_ortu VARCHAR(100) NOT NULL,
    no_wa_ortu VARCHAR(20),
    CONSTRAINT fk_balita_posyandu FOREIGN KEY (id_posyandu) REFERENCES posyandu(id_posyandu)
);

-- 3. Tabel Transaksi: rujukan (terhubung ke kunjungan/balita)
CREATE TABLE rujukan (
    id_rujukan INT PRIMARY KEY,
    id_kunjungan INT UNIQUE NOT NULL,
    rekomendasi TEXT NOT NULL,
    puskesmas_tujuan VARCHAR(100) NOT NULL,
    tgl_rujukan DATE NOT NULL,
    status_tindak_lanjut VARCHAR(50) NOT NULL
);

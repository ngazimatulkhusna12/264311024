A. INSERT (SEMUA TABEL)

-- Insert data ke tabel master: posyandu (3 baris)
INSERT INTO posyandu (id_posyandu, nama_posyandu, lokasi) VALUES
(1, 'Posyandu Mawar', 'Dusun Krajan, Desa Sukamaju, Kecamatan Sumberrejo'),
(2, 'Posyandu Melati', 'Dusun Sidomulyo, Desa Sukamaju, Kecamatan Sumberrejo'),
(3, 'Posyandu Anggrek', 'Dusun Karang asem, Desa Mekarsari, Kecamatan Sumberrejo');

-- Insert data ke tabel master: balita (3 baris)
INSERT INTO balita (id_balita, id_posyandu, id_pengguna, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu) VALUES
(1, 1, 101, '3201123456780001', 'Ahmad Zaki', '2024-05-10', 'L', 'Budi Santoso', '081234567890'),
(2, 1, 101, '3201123456780002', 'Siti Aminah', '2024-07-15', 'P', 'Joko Widodo', '081298765432'),
(3, 2, 102, '3201123456780003', 'Rian Pratama', '2023-11-20', 'L', 'Asep Saepudin', '081345678901');

-- Insert data ke tabel transaksi: rujukan (3 baris)
INSERT INTO rujukan (id_rujukan, id_kunjungan, rekomendasi, puskesmas_tujuan, tgl_rujukan, status_tindak_lanjut) VALUES
(1, 501, 'Rujukan penanganan gizi buruk dan pemantauan berat badan intensif', 'Puskesmas Sumberrejo', '2026-03-01', 'Belum Ditangani'),
(2, 502, 'Konsultasi lanjutan tumbuh kembang anak', 'Puskesmas Sumberrejo', '2026-03-05', 'Dalam Proses'),
(3, 503, 'Penanganan demam pasca imunisasi lanjutan', 'Puskesmas Mekarsari', '2026-03-10', 'Selesai');

B.SELECT (TABEL INDUK=POSYANDU)

SELECT * FROM posyandu;

C. UPDATE (TABEL TRANSAKSI=RUJUKAN)

UPDATE rujukan 
SET status_tindak_lanjut = 'Selesai' 
WHERE id_rujukan = 1;

D. DELETE TABEL TRANSAKSI=RUJUKAN)

DELETE FROM rujukan 
WHERE id_rujukan = 3;

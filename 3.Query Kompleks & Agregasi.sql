SELECT p.nama_posyandu, COUNT(r.id_rujukan) AS total_rujukan
FROM posyandu p
JOIN balita b ON p.id_posyandu = b.id_posyandu
JOIN rujukan r ON b.id_balita = r.id_rujukan
WHERE r.status_tindak_lanjut = 'Selesai'
GROUP BY p.id_posyandu, p.nama_posyandu;

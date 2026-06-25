/*
Ini kelanjutan langsung dari soal 3.1 — 
kali ini Anda kerjakan masalah yang sama persis 
(cari entitas yang tidak punya pasangan), 
tapi dengan teknik berbeda: NOT EXISTS. 
Tujuannya supaya Anda punya dua alat di toolkit dan paham kapan masing-masing 
lebih cocok dipakai.
NOT EXISTS bekerja dengan logika berbeda 
dari LEFT JOIN ... WHERE ... IS NULL: dia tidak menggabungkan tabel sama sekali. 
Dia cuma bertanya, untuk setiap baris di tabel utama, 
"apakah ada baris di tabel lain yang memenuhi kondisi ini?" — 
kalau tidak ada satu pun, baris itu lolos filter.
Tugas:
Kerjakan ulang soal yang identik dengan 3.1 
(cari seller_id yang belum pernah menjual satu item pun), 
tapi sekarang wajib pakai NOT EXISTS, bukan LEFT JOIN.
*/

-- approach 1 
SELECT ori.seller_id, ori.seller_city, ori.seller_state
FROM sellers AS ori
WHERE NOT EXISTS (
    SELECT *
    FROM order_items AS reff
    WHERE ori.seller_id = reff.seller_id
)
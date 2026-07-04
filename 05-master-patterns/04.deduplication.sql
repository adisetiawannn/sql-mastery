/*
Deduplication = proses menghapus baris duplikat dari data, tapi dengan logika yang tepat 
— bukan sekadar DISTINCT.

jenis-jenis deduplication:
a.Tipe 1: EXACT DUPLICATE : Semua kolom identik — boleh buang salah satu, tidak peduli mana
→ Solusi: DISTINCT atau GROUP BY semua kolom  
b. Tipe 2 : PARTIAL DUPLICATE : Sebagian kolom sama, sebagian beda — harus pilih MANA yang dipakai│
c. Tipe 3 : LOGICAL DUPLICATE : Data berbeda tapi secara bisnis merepresentasikan hal yang sama
contoh: review_id yang muncul di dua order berbeda

Tugas: Cek dulu — apakah order_reviews punya order_id yang muncul lebih dari sekali? 
Kalau ya, ambil hanya review terbaru (review_creation_date paling besar) per order_id.

Output: order_id, review_id, review_score, review_creation_date

*/


-- cek order_id yang muncul lebih dari satu kali dari order_reviews
SELECT order_id, count(*) AS order_id_count
FROM order_reviews
GROUP BY order_id
HAVING count(*) >1;

-- ambil review terbaru per order_id
WITH latest_reviews AS(
    SELECT order_id, review_id, review_score, review_creation_date,
              ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY review_creation_date DESC) AS rn
    FROM order_reviews
)

SELECT order_id, review_id, review_score, review_creation_date
FROM latest_reviews
WHERE rn=1
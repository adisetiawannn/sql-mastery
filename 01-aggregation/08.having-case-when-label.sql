/*
Soal ini gabungan HAVING (filter agregat) + CASE WHEN (label kategori) 
— dua hal yang sudah Anda kuasai terpisah, sekarang digabung dalam satu query.
Tugas:

1. Hitung jumlah transaksi (COUNT(*)) per product_category_name 
(perlu JOIN products ↔ order_items).
2. Filter (HAVING) hanya kategori dengan lebih dari 50 transaksi.
3. Tambahkan kolom label: 'High Volume' jika jumlah transaksi di atas 500, 
'Medium Volume' jika 50–500 (inklusif kedua batas).
Urutkan dari transaksi terbanyak.

Output: product_category_name, transaction_count, volume_label
*/

-- approach 1 : personal approach

SELECT  reff.product_category_name,
        COUNT(*) AS transaction_count,
        CASE 
        WHEN COUNT (*) > 500 THEN 'High Volume'
        ELSE 'Medium Volume'
        END AS volume_label
FROM order_items as ori
JOIN products as reff ON ori.product_id = reff.product_id

GROUP BY reff.product_category_name
HAVING COUNT(ori.product_id) >50
ORDER BY transaction_count DESC;


-- approach 2 : CTE approach

WITH category_counts AS (
    SELECT product_category_name, COUNT(*) AS transaction_count
    FROM order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    GROUP BY product_category_name
    HAVING COUNT(*) > 50
)

SELECT product_category_name,
       transaction_count,
       CASE 
           WHEN transaction_count > 500 THEN 'High Volume'
           ELSE 'Medium Volume'
       END AS volume_label
FROM category_counts
ORDER BY transaction_count DESC;
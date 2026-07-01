/*
Anda sudah pakai ROWS BETWEEN di 4.8. Sekarang bandingkan dengan RANGE BETWEEN 
— terlihat mirip, tapi mekanismenya beda fundamental.

* ROWS — menghitung berdasarkan posisi fisik baris 
(literal: "2 baris sebelum ini"), tidak peduli nilainya sama atau beda.

* RANGE — menghitung berdasarkan nilai di kolom ORDER BY 
(literal: "semua baris dengan nilai dalam rentang tertentu"). 
Kalau ada beberapa baris dengan nilai ORDER BY yang sama persis, 
RANGE akan memperlakukan mereka sebagai satu kelompok, bukan baris terpisah.

Kasus yang menunjukkan perbedaan nyata: kalau ada tie di kolom ORDER BY, 
ROWS dan RANGE bisa menghasilkan angka berbeda untuk frame yang 
"kelihatannya sama".

Tugas: Pakai data (seller_id, sales_count) dari soal 4.1 
(ranked CTE: COUNT(*) per seller_id, product_id).
Untuk satu seller yang Anda tahu punya tie 
(dari soal 4.1, seller 004c9cd9d87a3c30c522c48c4fc07416), 
hitung running total sales_count dengan dua cara: rows dan range window function

Output: product_id, sales_count, running_rows, running_range, 
filter hanya untuk seller itu.

*/

WITH sales_count AS (
    SELECT
        A.seller_id,
        A.product_id,
        COUNT(*) AS sales_count
    FROM order_items AS A
        WHERE A.seller_id = '004c9cd9d87a3c30c522c48c4fc07416'
    GROUP BY A.seller_id, A.product_id
), running_total AS (
    SELECT 
        *,
        SUM(sales_count) OVER (ORDER BY sales_count DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_rows,
        SUM(sales_count) OVER (ORDER BY sales_count DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_range
    FROM sales_count
)

select * 
FROM running_total;
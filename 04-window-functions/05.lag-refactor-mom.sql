/*
Brief: LAG() mengambil nilai dari baris sebelumnya dalam urutan 
yang ditentukan ORDER BY — tanpa perlu self-join

Mengambil nilai kolom dari 1 baris sebelumnya (dalam partisi yang sama, 
menurut urutan ORDER BY). Baris pertama dalam tiap partisi akan 
menghasilkan NULL (karena tidak ada "sebelumnya").

Tugas : untuk setiap seller_id, cari bulan-bulan di mana revenue 
turun dibanding bulan sebelumnya.

Output: seller_id, month, revenue, prev_month_revenue
*/

WITH revenue_total AS (
    SELECT A.seller_id, 
           DATE_TRUNC('month', B.order_purchase_timestamp) AS bulan,
           SUM(A.price) AS revenue
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
    GROUP BY A.seller_id, bulan
), lag_revenue AS (
    SELECT *, LAG(revenue,1,NULL) OVER (PARTITION BY seller_id ORDER BY bulan) AS last_revenue
    FROM revenue_total
)

SELECT * 
FROM lag_revenue 
WHERE revenue < last_revenue
ORDER BY seller_id DESC, bulan ASC;
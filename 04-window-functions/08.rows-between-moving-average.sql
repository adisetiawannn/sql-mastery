/*
brief : frame clause :  Frame clause membiarkan Anda membatasi window 
itu secara eksplisit — misal "cuma 3 baris terakhir", 
bukan "semua dari awal". -> tanpa frame clause window function hitung semua dari awal

General syntax :
AVG(revenue) OVER (
    PARTITION BY seller_id 
    ORDER BY month 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS moving_avg_3m

penjelasan : 
- 2 PRECEDING = mulai dari 2 baris sebelum baris ini
- CURRENT ROW = sampai baris ini sendiri
Total: window bergerak mencakup 3 baris (2 sebelumnya + baris sekarang) — 
itu sebabnya disebut "3-month moving average"

Tugas: Hitung 3-month moving average revenue per seller 
(rata-rata revenue bulan ini + 2 bulan sebelumnya).

Output: seller_id, month, revenue, moving_avg_3m

*/

WITH revenue AS (
    SELECT A.seller_id, DATE_TRUNC('month', B.order_purchase_timestamp) AS bulan,
           SUM (A.price) AS revenue
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
    GROUP BY A.seller_id, bulan
), moving_avg AS (
    SELECT *, AVG(revenue) OVER (PARTITION BY seller_id ORDER BY bulan
                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3m
    FROM revenue
)

SELECT * FROM moving_avg;
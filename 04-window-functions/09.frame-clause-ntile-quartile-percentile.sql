/*
Brief: NTILE(n) membagi baris dalam satu partisi jadi n kelompok 
dengan ukuran sama rata (atau semirip mungkin), berdasarkan urutan ORDER BY. 
Beda dari ranking biasa — NTILE tidak peduli nilai aktual, 
dia cuma peduli posisi urut untuk membagi rata jadi N grup.

general syntax :
NTILE(4) OVER (ORDER BY total_revenue DESC) AS quartile
penjelasan : 
- Kalau ada 100 baris, NTILE(4) akan beri label 1-25 = quartile 1, 
26-50 = quartile 2, dst (kira-kira — pembagian otomatis disesuaikan 
kalau jumlah baris tidak habis dibagi rata).

Tugas: Bagi seluruh seller (bukan per grup, jadi tanpa PARTITION BY) 
jadi 4 kuartil berdasarkan total_revenue — kuartil 1 = revenue tertinggi.

Output: seller_id, total_revenue, quartile

*/

WITH revenue AS (
    SELECT A.seller_id, SUM (A.price) AS total_revenue
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
    GROUP BY A.seller_id
), kuartil AS (
    SELECT *, NTILE(4) OVER (ORDER BY total_revenue DESC) AS kuartil
    FROM revenue
)

SELECT * FROM kuartil;
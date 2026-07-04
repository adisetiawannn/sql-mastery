/*
Tugas: Untuk setiap seller_id, cari bulan-bulan di mana revenue-nya turun
dibanding bulan sebelumnya (bulan harus berurutan/konsekutif, 
bukan sembarang bulan lampau — 
ingat teknik "tidak ada yang menyela di antaranya" dari soal 2.9).

Output: seller_id, month, revenue, prev_month_revenue

*/

WITH revenue_seller AS (
    SELECT A.seller_id, SUM(A.price) AS revenue, 
    DATE_TRUNC('MONTH',B.order_purchase_timestamp) AS periode
    FROM order_items AS A
    JOIN orders AS B On A.order_id = B.order_id
    GROUP BY A.seller_id, periode
    ORDER BY periode DESC
)

SELECT B.seller_id, B.periode, B.revenue AS current_revenue,
        A.revenue AS prev_revenue
FROM revenue_seller AS A
JOIN revenue_seller AS B ON A.seller_id = B.seller_id AND
                            A.periode < B.periode
WHERE NOT EXISTS (
    SELECT * FROM revenue_seller AS C
    WHERE C.seller_id = A.seller_id AND 
            C.periode > A.periode AND
            C.periode < B.periode
) AND B.revenue < A.revenue;

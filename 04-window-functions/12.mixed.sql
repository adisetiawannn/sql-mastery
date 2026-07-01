/*
Tugas: Untuk setiap seller_id, per bulan, tampilkan:

1. Revenue bulan itu
2. Ranking seller tersebut dibanding seller lain pada bulan yang sama 
(siapa revenue tertinggi bulan itu — pakai RANK(), partition by bulan)
3. Running total revenue seller itu dari bulan pertama sampai bulan ini
4. Revenue bulan sebelumnya (pakai LAG)
5. Status: label 'Naik' kalau revenue lebih tinggi dari bulan lalu, 
'Turun' kalau lebih rendah, 'Bulan Pertama' kalau tidak ada data bulan 
sebelumnya (NULL)

Output: seller_id, month, revenue, rank_in_month, 
running_total, prev_month_revenue, status

*/

WITH monthly_revenue AS (
    SELECT 
        oi.seller_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS bulan,
        SUM(oi.price) AS revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY oi.seller_id, DATE_TRUNC('month', o.order_purchase_timestamp)
), ranked_revenue_seller AS (
    SELECT *,
        RANK() OVER (PARTITION BY bulan ORDER BY revenue DESC) AS rank_in_month,
        SUM(revenue) OVER (PARTITION BY seller_id ORDER BY bulan ASC) AS running_total,
        LAG(revenue) OVER (PARTITION BY seller_id ORDER BY bulan ASC) AS prev_month_revenue
    FROM monthly_revenue
), ranked_status AS (
    SELECT *,
        CASE
            WHEN prev_month_revenue IS NULL THEN 'Bulan Pertama'
            WHEN revenue > prev_month_revenue THEN 'Naik'
            WHEN revenue < prev_month_revenue THEN 'Turun'
            ELSE 'Tetap'
        END AS status
    FROM ranked_revenue_seller
)

SELECT *
FROM ranked_status
ORDER BY seller_id, bulan;
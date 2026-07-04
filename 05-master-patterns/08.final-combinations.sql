/*

Tugas: Bangun laporan kesehatan seller yang menggabungkan:

1. Gaps & Islands (5.1) — deteksi apakah seller punya periode tidak aktif (gap) dalam histori jualannya
2. Percentile (5.5) — bandingkan total_revenue seller terhadap median seluruh seller (apakah di atas atau di bawah)
3. Pivot (5.2) — tampilkan jumlah order per status (delivered, canceled, dll) sebagai kolom terpisah

Output: seller_id, total_revenue, above_median, longest_gap_months, delivered_count, canceled_count
*/

--cte 1 : total revenue per seller
WITH seller_revenue AS (
    SELECT seller_id, SUM(price) AS total_revenue
    FROM order_items
    GROUP BY seller_id
), 
--cte 2: gaps & island : hitung apakah ada gap dalam histori penjualan seller dan berapa lama gap tersebut
seller_gaps AS (
    SELECT  DISTINCT B.seller_id,
            DATE_TRUNC('month', A.order_purchase_timestamp) AS bulan
    FROM orders AS A
    JOIN order_items AS B ON A.order_id = B.order_id
),
seller_gaps_numbered AS (
    SELECT  *,
            EXTRACT(YEAR FROM bulan) * 12 + EXTRACT(MONTH FROM bulan) AS island_id,
            ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY bulan) rnk
    FROM seller_gaps
), 
seller_islands AS (
    SELECT seller_id, island_id - rnk AS island_group,
           MIN(bulan) AS island_start, MAX(bulan) AS island_end
    FROM seller_gaps_numbered
    GROUP BY seller_id, island_id - rnk
),
seller_gap_calc AS (
    SELECT  seller_id, island_end,
            LEAD(island_start) OVER (PARTITION BY seller_id ORDER BY island_start) AS next_island_start,
            (EXTRACT(YEAR FROM LEAD(island_start) OVER (PARTITION BY seller_id ORDER BY island_start)) * 12 +
            EXTRACT(MONTH FROM LEAD(island_start) OVER (PARTITION BY seller_id ORDER BY island_start))) -
            (EXTRACT(YEAR FROM island_end) * 12 + EXTRACT(MONTH FROM island_end)) AS gap_months
    FROM seller_islands
),
seller_gaps_final AS (
    SELECT seller_id, MAX(gap_months) AS longest_gap_months
    FROM seller_gap_calc
    WHERE gap_months IS NOT NULL
    GROUP BY seller_id
),
--cte 3: pivot table
pivot_table AS (
    SELECT  B.seller_id,
            COUNT(CASE WHEN order_status='delivered' THEN 1 END) AS delivered_count,
            COUNT(CASE WHEN order_status='canceled' THEN 1 END) AS canceled_count
    FROM orders AS A
    JOIN order_items AS B ON A.order_id = B.order_id
    GROUP BY B.seller_id
)

-- checking
SELECT A.seller_id, 
       A.total_revenue,
       A.total_revenue > (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue) FROM seller_revenue) AS above_median,
       COALESCE(B.longest_gap_months, 0) AS longest_gap_months, 
       C.delivered_count, 
       C.canceled_count
FROM seller_revenue AS A
LEFT JOIN seller_gaps_final AS B ON A.seller_id = B.seller_id
LEFT JOIN pivot_table AS C ON A.seller_id = C.seller_id
ORDER BY A.total_revenue DESC;


/*
Brief: Gabungan semua skill: JOIN multi-tabel, 
agregasi berjenjang (CTE), dan filter. Tidak ada teknik baru, ini tes integrasi.

Tugas: Cari seller terbaik per state — untuk setiap seller_state, 
cari 1 seller dengan total_revenue (dari order_items.price) tertinggi.

Output: seller_state, seller_id, total_revenue

Catatan: "1 seller per state" berarti perlu rank di level state, 
tapi karena sudah sepakat window function disimpan untuk Tier 5, 
kerjakan dengan pendekatan subquery yang sudah Anda kuasai 
(mirip pola 2.8: hitung revenue per seller dulu di CTE, 
lalu cari max per state pakai subquery/self-comparison).
*/

-- CTE : sub-main-table
WITH sellers_revenue AS (
    SELECT A.seller_state, A.seller_id,SUM(B.price) AS total_revenue
    FROM sellers AS A
    JOIN order_items AS B ON A.seller_id = B.seller_id
    GROUP BY A.seller_id, A.seller_state
)

-- main query
SELECT ori.seller_state AS seller_state, ori.seller_id AS seller_id, ori.total_revenue AS total_revenue
FROM sellers_revenue AS ori
WHERE NOT EXISTS (
    SELECT *
    FROM sellers_revenue AS subquery
    WHERE   ori.seller_state = subquery.seller_state AND
            ori.total_revenue < subquery.total_revenue
) AND NOT EXISTS(
    SELECT *
    FROM sellers_revenue AS subquery
    WHERE       ori.seller_state = subquery.seller_state AND
                ori.total_revenue = subquery.total_revenue AND
                ori.seller_id > subquery.seller_id
)
ORDER BY total_revenue DESC
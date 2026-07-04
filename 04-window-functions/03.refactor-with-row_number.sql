/*
Tugas : Cari seller dengan total_revenue tertinggi di tiap seller_state — 
tepat 1 seller per state 
(kalau ada tie, tie-breaker pakai seller_id terkecil, sama seperti 2.10).

Output: seller_state, seller_id, total_revenue

*/

-- approach - windows function

WITH ranked AS (
    SELECT B.seller_state, A.seller_id,
           SUM(A.price) AS total_revenue
    FROM order_items AS A
    JOIN sellers AS B ON A.seller_id = B.seller_id
    GROUP BY B.seller_state, A.seller_id
), ranked_filtered AS (
    SELECT *, ROW_NUMBER () OVER (PARTITION BY seller_state
                            ORDER BY total_revenue DESC, seller_id ASC) AS rnk
    FROM ranked
)

SELECT *
FROM ranked_filtered
WHERE rnk = 1
ORDER BY total_revenue DESC, seller_id ASC

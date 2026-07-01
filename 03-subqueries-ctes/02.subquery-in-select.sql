/*
Tugas: Per order, tampilkan total_order_value-nya dan 
selisihnya dari rata-rata keseluruhan order.

Output: order_id, total_order_value, diff_from_avg

Catatan: diff_from_avg = total_order_value - rata-rata keseluruhan. 
Tampilkan semua order (tidak difilter seperti 3.1) — 
termasuk yang di bawah rata-rata (nilainya akan negatif).

*/

-- CTE
WITH total_order_value AS (
    SELECT order_id, SUM(price) AS total_order_value
    FROM order_items
    GROUP BY order_id
)
-- main query
SELECT  order_id, total_order_value,
        total_order_value - (SELECT AVG(total_order_value) FROM total_order_value) AS diff_from_avg
FROM total_order_value
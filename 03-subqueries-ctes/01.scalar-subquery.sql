/*
Tugas: Cari order dengan total_order_value di atas rata-rata semua order.
Output: order_id, total_order_value

- Struktur yang dibutuhkan:

1.  Hitung total_order_value per order 
    (SUM dari order_items.price, GROUP BY order_id) — bisa pakai CTE.
2.  Bandingkan ke rata-rata dari semua total_order_value itu 
    (bukan rata-rata price mentah per item — beda level).
*/

-- CTE
WITH total_order_value AS (
    SELECT order_id, SUM(price) as total_order_value
    FROM order_items
    GROUP BY order_id
)

-- main query
SELECT order_id, total_order_value
FROM total_order_value
WHERE total_order_value > (
    SELECT AVG(total_order_value) FROM total_order_value
)
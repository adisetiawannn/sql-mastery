/*
Per order_status (dari tabel orders), hitung berapa banyak order yang 
freight value-nya (ongkos kirim, dari order_items.freight_value, 
di-SUM per order dulu) lebih besar dari price-nya sendiri 
(order yang ongkir-nya lebih mahal dari barangnya — sinyal customer experience buruk).
Ini butuh subquery atau CTE ringan untuk agregasi per order dulu sebelum dibandingkan — 
kerjakan dengan pendekatan apa pun yang menurut Anda paling masuk akal, 
saya akan review approach-nya, bukan cuma syntax-nya.
*/

WITH bad_orders AS (
    SELECT order_id,
    CASE WHEN SUM (order_items.freight_value) > SUM(order_items.price) THEN 1 ELSE 0 END AS bad_order_flag
    FROM order_items
    GROUP BY order_id
)
SELECT order_status, SUM(bad_orders.bad_order_flag) AS bad_order_count,
COUNT(*) AS total_orders
FROM orders
JOIN bad_orders ON orders.order_id = bad_orders.order_id
GROUP BY orders.order_status


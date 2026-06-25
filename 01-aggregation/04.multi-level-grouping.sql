/*
Hitung total revenue per kombinasi customer_state (dari customers, perlu JOIN)
dan tahun (EXTRACT(YEAR FROM order_purchase_timestamp)). 
Output: customer_state, year, total_revenue, urutkan by state lalu year.
*/

SELECT A.customer_state, EXTRACT(YEAR FROM B.order_purchase_timestamp) AS tahun,
SUM (price) as product_revenue, COUNT(DISTINCT B.order_id) AS jumlah_order
FROM customers AS A
JOIN orders AS B ON A.customer_id = B.customer_id
JOIN order_items AS C ON B.order_id = C.order_id
GROUP BY customer_state, tahun
ORDER BY customer_state, tahun;
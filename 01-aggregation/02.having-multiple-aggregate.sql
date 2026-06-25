/*
Dari hasil 01.group-by.sql, filter cuma seller yang punya rata-rata harga item (AVG(price)) 
di atas 100, dan total transaksi minimal 20. 
(Latihan: dua kondisi HAVING sekaligus.)
*/

SELECT seller_id, SUM(price) AS total_revenue, COUNT(*) AS total_items
FROM order_items
GROUP BY seller_id
HAVING AVG(price) > 100 AND COUNT(*) > 20
ORDER BY total_revenue DESC;

/*
Hitung total revenue (SUM(price) dari order_items) dan jumlah item terjual 
(COUNT(*)) per seller_id. 
Urutkan dari revenue tertinggi. Tampilkan 10 seller teratas.
*/

SELECT seller_id, sum(price) as total_revenue, count(*) as total_items
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;


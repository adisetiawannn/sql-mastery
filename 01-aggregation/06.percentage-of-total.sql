/*
Hitung persentase kontribusi revenue tiap product_category_name 
terhadap total revenue keseluruhan. 
(Catatan: ini sengaja mengintip window function — 
kalau Anda belum nyaman, boleh pakai subquery untuk ambil grand total dulu, 
baru dibagi.)
*/

WITH revenue_total AS (
    SELECT SUM(price) AS product_revenue
    FROM order_items
)
SELECT  A.product_category_name,
        SUM(B.price) AS category_revenue,
        ROUND(100.0*SUM(B.price)/(SELECT product_revenue FROM revenue_total),2) AS percent
FROM products AS A
JOIN order_items AS B ON  A.product_id = B.product_id
GROUP BY A.product_category_name
ORDER BY percent DESC;

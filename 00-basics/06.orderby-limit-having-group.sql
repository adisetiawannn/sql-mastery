/*
Cari 10 produk dengan harga rata-rata 
(price dari order_items, di-join ke products lewat product_id) tertinggi, 
hanya untuk kategori produk yang punya minimal 5 transaksi (HAVING). 
Ini sengaja sedikit "bocor" ke depan (JOIN + GROUP BY + HAVING) — anggap bonus kalibrasi
*/

SELECT A.product_id, AVG(A.price) AS avg_price
FROM order_items as A
JOIN products as B ON A.product_id = B.product_id
GROUP BY A.product_id
HAVING COUNT(*) > 5
ORDER BY avg_price DESC
LIMIT 10;
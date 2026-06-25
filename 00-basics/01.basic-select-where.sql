/*
Konteks tabel utama yang kepakai: 
orders, customers, order_items, products, order_payments, order_reviews.

case : 

Ambil semua order dengan order_status = 'delivered' 
yang order_purchase_timestamp jatuh di tahun 2018. 
Output: order_id, customer_id, order_purchase_timestamp, order_status.
*/

SELECT order_id, customer_id, order_purchase_timestamp, order_status
FROM orders
WHERE order_status = 'delivered' AND order_purchase_timestamp BETWEEN ('2018-01-01') AND ('2019-01-01');


/*
alternative query
SELECT order_id, customer_id, order_purchase_timestamp, order_status
FROM orders
WHERE order_status = 'delivered' AND EXTRACT(YEAR FROM order_purchase_timestamp) = 2018;
*/


/*
Tampilkan daftar unik order_status yang ada di tabel orders — 
berapa status berbeda yang mungkin terjadi pada sebuah order?
*/

SELECT DISTINCT order_status
from orders;

SELECT order_status, COUNT(order_status) as count
from orders
GROUP BY order_status;

SELECT COUNT(DISTINCT(order_status)) as jumlah_order
from orders;
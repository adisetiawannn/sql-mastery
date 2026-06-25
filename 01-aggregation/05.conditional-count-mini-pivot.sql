/*
Dalam satu query, hitung: jumlah order delivered, jumlah order canceled, 
dan jumlah order shipped, masing-masing sebagai kolom terpisah 
(bukan baris terpisah seperti GROUP BY biasa).
 Gunakan COUNT(*) FILTER (WHERE ...) 
*/

SELECT COUNT(*) FILTER (WHERE order_status = 'delivered') AS Delivered,
       COUNT(*) FILTER (WHERE order_status = 'canceled') AS Canceled,
       COUNT(*) FILTER (WHERE order_status = 'shipped') AS Shipped
FROM orders;
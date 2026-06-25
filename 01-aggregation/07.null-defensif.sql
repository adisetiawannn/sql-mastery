/*
Hitung rata-rata payment_value per payment_type dari tabel order_payments, 
menggunakan AVG() bawaan SQL (bukan pembagian manual SUM/COUNT).
kedua dari query yang sama menggunakan pembagian manual 
SUM(payment_value) / COUNT(payment_value), dengan NULLIF 
diterapkan pada bagian COUNT(...)

Output untuk kedua versi: payment_type, avg_payment_value

*/


 -- approach 1 : null defensive
SELECT payment_type, 
       SUM(payment_value) / NULLIF(COUNT(payment_value), 0) AS avg_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC;

-- approach 2 : manual
SELECT payment_type, AVG(payment_value) AS avg_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY avg_payment_value DESC;

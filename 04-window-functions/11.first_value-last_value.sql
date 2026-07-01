/*
Brief: Dua fungsi untuk mengambil nilai pertama atau terakhir dalam 
suatu window — berguna untuk "tempelkan" nilai dari ujung window ke 
setiap baris, tanpa perlu LAG/LEAD berkali-kali.

general syntax : 
FIRST_VALUE(kolom) OVER (PARTITION BY grup ORDER BY urutan) AS pertama,
LAST_VALUE(kolom) OVER (PARTITION BY grup ORDER BY urutan 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS terakhir

Catatan penting (jebakan umum): LAST_VALUE butuh frame clause eksplisit 
(ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
untuk benar-benar mengambil baris terakhir dalam partisi. 
Tanpa itu, default frame (UNBOUNDED PRECEDING AND CURRENT ROW)
membuat LAST_VALUE selalu mengembalikan baris saat ini, 
bukan baris terakhir sungguhan — ini jebakan yang sangat umum

Tugas: Untuk setiap customer_unique_id, tampilkan order pertama 
dan order terakhir mereka (timestamp-nya) dalam satu baris per order 
(jadi tiap order si customer itu akan menampilkan info pertama/terakhir
yang sama, ditempelkan).

Output: customer_unique_id, order_id, order_purchase_timestamp, 
first_order_date, last_order_date

*/

WITH customer_order AS (
    SELECT B.customer_unique_id, A.order_id, A.order_purchase_timestamp AS periode
    FROM orders AS A
    JOIN customers AS B ON A.customer_id = B.customer_id
), customer_order_info AS (
    SELECT *,
        FIRST_VALUE(periode) OVER (PARTITION BY customer_unique_id ORDER BY periode) AS first_order_date,
        LAST_VALUE(periode) OVER (PARTITION BY customer_unique_id ORDER BY periode ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_order_date
    FROM customer_order
)

SELECT *
FROM customer_order_info;
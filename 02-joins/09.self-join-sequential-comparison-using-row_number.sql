/*
Brief: Self-join lagi (seperti 2.2), 
tapi sekarang untuk membandingkan urutan waktu — bukan mencari pasangan kategori sama, 
tapi mencari selisih antar kejadian dalam tabel yang sama

Tugas : 
Untuk setiap customer yang melakukan lebih dari satu order, 
cari selisih hari antara order pertama dan order keduanya 
(berdasarkan order_purchase_timestamp).

Output: customer_id, first_order_date, second_order_date, days_between

Catatan : customer_id di Olist unik per order (sudah kita bahas di awal — ingat soal row count customers=orders). 
Jadi untuk soal ini, anggap "customer" yang sama itu diidentifikasi 
lewat kombinasi lain — gunakan customer_unique_id dari tabel customers 
(bukan customer_id) untuk mengelompokkan order yang benar-benar milik orang yang sama.

Pikirkan: untuk self-join "order pertama vs order kedua", 
kondisi apa yang menjamin B adalah order setelah A, dan tidak ada order lain 
di antaranya?
*/

-- approach 1
--- Table CTE
WITH customer_order AS -- CTE 1
    (
        SELECT orders.customer_id, orders.order_id, 
            orders.order_purchase_timestamp, customers.customer_unique_id
        FROM orders
        JOIN customers ON orders.customer_id = customers.customer_id
        ),
    customer_order_final AS  -- CTE 2
    (
        SELECT customer_order.*, 
            ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) AS order_number
        FROM customer_order
    )

--- main query
SELECT A.customer_unique_id AS customer_id,
    MIN(A.order_purchase_timestamp) AS first_order_date,
    MAX(A.order_purchase_timestamp) AS second_order_date,
    EXTRACT(DAY FROM(MAX(A.order_purchase_timestamp)- MIN(A.order_purchase_timestamp))) AS days_between
FROM customer_order_final AS A
WHERE A.order_number = 1 OR A.order_number = 2
GROUP BY A.customer_unique_id
HAVING MAX(A.order_number) >=2
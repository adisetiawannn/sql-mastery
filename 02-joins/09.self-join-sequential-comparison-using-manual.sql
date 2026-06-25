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

-- approach 2 : manual row_number method

--- CTE 1 : for taking customer_unique_id
WITH customer_order AS ( 
    SELECT B.customer_unique_id, A.order_id, A.order_purchase_timestamp, A.customer_id
    FROM orders as A
    JOIN customers as B ON A.customer_id = B.customer_id
)

SELECT  ori.customer_unique_id AS customer_id, 
        ori.order_purchase_timestamp AS first_order_date, 
        reff.order_purchase_timestamp AS second_order_date, 
        EXTRACT (DAY FROM (reff.order_purchase_timestamp - ori.order_purchase_timestamp)) AS days_between
FROM customer_order AS ori
JOIN customer_order AS reff ON  ori.customer_unique_id = reff.customer_unique_id AND
                                ori.order_purchase_timestamp < reff.order_purchase_timestamp
WHERE NOT EXISTS(
    SELECT * FROM customer_order AS subquery
    WHERE   ori.customer_unique_id = subquery.customer_unique_id AND 
            ori.order_purchase_timestamp < subquery.order_purchase_timestamp AND
            reff.order_purchase_timestamp > subquery.order_purchase_timestamp
) AND NOT EXISTS(
    SELECT * FROM customer_order AS subquery
    WHERE   ori.customer_unique_id = subquery.customer_unique_id AND 
            ori.order_purchase_timestamp > subquery.order_purchase_timestamp
)
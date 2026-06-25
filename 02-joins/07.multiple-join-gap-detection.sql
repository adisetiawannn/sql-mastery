/*
Brief: JOIN dengan multiple kondisi di ON clause (bukan hanya satu kolom).
Deteksi order yang missing payment data 
(ada di orders, tapi tidak ada/tidak lengkap di order_payments).

Tugas:

Cari semua order yang tidak ada payment record sama sekali, 
atau payment value-nya kurang dari total order value (underpaid).

Hitung total_order_value dari order_items per order, 
lalu LEFT JOIN dengan order_payments (aggregated per order).

Output: order_id, order_status, total_order_value, 
paid_amount, gap_amount

Filter: hanya tampilkan yang paid_amount IS NULL atau gap_amount > 0.
*/

-- approach 1

-- # hitung total_order_value per order
WITH total_order_value AS (
    SELECT ori.order_id, reff.order_status, SUM(price) AS total_order_value
    FROM order_items AS ori
    JOIN orders AS reff ON ori.order_id = reff.order_id
    GROUP BY ori.order_id, reff.order_status
)

SELECT  A.order_id AS order_id, A.order_status AS order_status, A.total_order_value AS total_order_value, 
        C.paid_amount AS paid_amount, (A.total_order_value - C.paid_amount) AS gap_amount
FROM total_order_value AS A
LEFT JOIN (
    SELECT order_id, SUM(payment_value) AS paid_amount
    FROM order_payments
    GROUP BY order_id
) AS C ON A.order_id = C.order_id
WHERE C.paid_amount IS NULL OR (A.total_order_value - C.paid_amount) > 0
/*
Brief : Cohort analysis mengelompokkan customer berdasarkan kapan mereka pertama 
kali bertransaksi (cohort month), lalu melacak perilaku mereka di bulan-bulan berikutnya. 
Ini fondasi retention analysis

struktur dasar : 
Cohort Jan'18 (customer yang FIRST order-nya di Januari 2018):
- Bulan ke-0 (Jan'18): 100 customer aktif (100%)
- Bulan ke-1 (Feb'18): 60 customer masih order (60% retained)
- Bulan ke-2 (Mar'18): 45 customer masih order (45% retained)

Key Steps :
1. Tentukan cohort — cari MIN(order_purchase_timestamp) per customer → itu "cohort month"-nya.
2. Hitung "month number" — untuk tiap order customer itu, berapa bulan setelah cohort month (0 = bulan pertama, 1 = bulan kedua, dst).
3. Pivot/agregasi — hitung jumlah customer unik per (cohort_month, month_number).

Perbedaan penting dengan Gaps & Islands (5.1): 
- Gaps & Islands mendeteksi periode kontinu tanpa gap. 
- Cohort analysis tidak peduli kontinuitas — 
customer yang order di bulan ke-0 dan ke-3 (skip 1,2) tetap dihitung 
"retained di bulan ke-3", meski ada gap di antaranya.

tugas : Untuk setiap cohort_month 
(bulan pertama customer order — pakai customer_unique_id), 
hitung jumlah customer unik yang masih order di month_number 0, 1, 2, 3 
(0 = bulan cohort itu sendiri).

Output: cohort_month, month_number, active_customers

*/

WITH customer_order AS (
    SELECT  A.customer_unique_id AS customer,
            DATE_TRUNC('month',B.order_purchase_timestamp) AS order_month
    FROM customers AS A
    JOIN orders AS B ON A.customer_id = B.customer_id
), cohort AS (
    SELECT customer, MIN(order_month) AS cohort_month
    FROM customer_order
    GROUP BY customer
), cohort_orders AS (
    SELECT  A.customer, A.order_month, B.cohort_month,
            (EXTRACT(YEAR FROM A.order_month)* 12 + EXTRACT(MONTH FROM A.order_month) - 
            EXTRACT(YEAR FROM B.cohort_month)* 12 - EXTRACT(MONTH FROM B.cohort_month)) AS month_number
    FROM customer_order AS A
    JOIN cohort AS B ON A.customer = B.customer
)

SELECT  cohort_month,
        month_number,
        COUNT(DISTINCT customer) AS active_customers
FROM cohort_orders
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
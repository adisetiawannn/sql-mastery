/*
Kelanjutan langsung dari Cohort Analysis (5.3) — sekarang ubah angka absolut (active_customers)
jadi persentase retention relatif terhadap ukuran cohort awal (month_number=0). 
Ini bentuk laporan yang sebenarnya dipakai di industri (cohort retention table), 
bukan cuma angka mentah.

formula : 
retention_rate = active_customers(month_number=N) / active_customers(month_number=0) * 100
jumlah customer di month_number=0) sekarang levelnya per cohort, bukan grand total keseluruhan.

Tugas: Dari hasil Tier 5.3, hitung retention_rate — persentase customer yang masih aktif 
di tiap month_number, relatif terhadap jumlah customer di month_number = 0 
untuk cohort yang sama.

Output: cohort_month, month_number, active_customers, cohort_size, retention_rate

additional steps :
1. Tambah kolom cohort_size — ambil active_customers khusus di month_number = 0 per cohort, 
lalu tempelkan ke semua baris cohort yang sama (pikirkan: window function tanpa ORDER BY, 
atau self-join/subquery — pilih salah satu).

2. retention_rate = active_customers::NUMERIC / cohort_size * 100, ROUND 2 desimal.
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

), cohort_summary AS (
    SELECT cohort_month,month_number, COUNT(DISTINCT customer) AS active_customers
    FROM cohort_orders
    GROUP BY cohort_month, month_number
)


SELECT *,
    FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY month_number) AS cohort_size,
    ROUND(active_customers::NUMERIC / FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY month_number) * 100, 2) AS retention_rate
FROM cohort_summary;
/*
Brief: LEAD() adalah kebalikan LAG() — mengambil nilai dari baris setelahnya, 
bukan sebelumnya, dalam urutan yang sama.

Tugas: Untuk setiap seller_id, tampilkan revenue bulan ini dan 
revenue bulan berikutnya

Output: seller_id, month, revenue, next_month_revenue

*/


WITH revenue_total AS (
    SELECT A.seller_id, 
           DATE_TRUNC('month', B.order_purchase_timestamp) AS bulan,
           SUM(A.price) AS revenue
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
    GROUP BY A.seller_id, bulan
), lead_revenue AS (
    SELECT *, LEAD(revenue,1,NULL) OVER (PARTITION BY seller_id ORDER BY bulan) AS next_revenue
    FROM revenue_total
)

SELECT * FROM lead_revenue
ORDER BY seller_id
/*
this challenge is a follow-up to the previous one(04.derived-table.sql)

but this time the task is to refactor the query (derived table)
with a CTE

Tugas: Dari rata-rata revenue per kategori produk, 
cari kategori dengan category_revenue di atas rata-rata keseluruhan kategori 
(rata-rata dari rata-rata, bukan rata-rata dari semua item mentah.

Output: product_category_name, category_revenue
*/

WITH revenue_table AS (
    SELECT A.product_category_name, SUM(B.price) AS category_revenue
    FROM products AS A
    JOIN order_items AS B ON A.product_id = B.product_id
    GROUP BY A.product_category_name
)
--main query
SELECT product_category_name, category_revenue
FROM revenue_table
WHERE category_revenue > (SELECT AVG(category_revenue)
                          FROM revenue_table)


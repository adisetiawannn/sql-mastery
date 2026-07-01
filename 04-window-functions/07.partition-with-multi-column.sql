/*
brief : RANK() OVER (PARTITION BY kolom1, kolom2 ORDER BY ...)
- Ranking akan reset setiap kombinasi (kolom1, kolom2) berbeda — 
bukan cuma kolom1 berubah.

tugas : Ranking produk terlaris (berdasarkan COUNT penjualan) per kombinasi 
(product_category_name, tahun) — tahun dari order_purchase_timestamp.

output : product_category_name, tahun, product_id, sale_count, rnk
*/

WITH ranking AS (
    SELECT D.product_category_name_english AS product_category_name,
           B.product_id, COUNT(*) AS sales_count,
           EXTRACT (YEAR FROM A.order_purchase_timestamp) AS tahun
    FROM orders AS A
    JOIN order_items AS B ON A.order_id = B.order_id
    JOIN products AS C ON B.product_id = C.product_id
    JOIN product_category_name_translation AS D ON C.product_category_name = D.product_category_name
    GROUP BY D.product_category_name_english, B.product_id, tahun
), ranking_final AS (
    SELECT *, ROW_NUMBER () OVER (PARTITION BY product_category_name, tahun ORDER BY sales_count DESC) AS rnk
    FROM ranking
)

SELECT * FROM ranking_final;
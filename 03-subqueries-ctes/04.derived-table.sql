/*
put subquery as a derived table - means : a table that is created FROM a query

Tugas: Dari rata-rata revenue per kategori produk, 
cari kategori dengan category_revenue di atas rata-rata keseluruhan kategori 
(rata-rata dari rata-rata, bukan rata-rata dari semua item mentah.

Output: product_category_name, category_revenue
*/

SELECT main_table.product_category_name, main_table.category_revenue
FROM (
    SELECT A.product_category_name AS product_category_name , SUM(b.price) AS category_revenue
    FROM products AS A
    JOIN order_items AS B ON A.product_id = B.product_id
    GROUP BY A.product_category_name
) AS main_table
WHERE
    main_table.category_revenue >
    (SELECT AVG(inner_table.category_revenue)
    FROM 
        (SELECT C.product_category_name AS product_category_name , SUM(D.price) AS category_revenue 
        FROM products AS C
        JOIN order_items AS D ON C.product_id = D.product_id
        GROUP BY C.product_category_name
        ) AS inner_table 
    )
/*
Brief : Tiga fungsi ranking, beda cara 
menangani tie (nilai yang sama).

- ROW_NUMBER()Tetap beda nomor, urutan antar tie sembarang
- RANK()Tie dapat nomor sama, lalu lompat nomor setelahnya (1,2,2,4)
- DENSE_RANK()Tie dapat nomor sama, tidak lompat (1,2,2,3)

syntax dasar : RANK() OVER (PARTITION BY kolom_grup ORDER BY kolom_urutan DESC)

Tugas: Hitung sales_count per (seller_id, product_id) dari order_items. 
Bandingkan ketiga fungsi ranking, 
partition per seller_id, urutkan berdasarkan sale_count DESC.

output : seller_id, product_id, sale_count, row_num, rnk, dense_rnk
*/


WITH ranked AS (
    SELECT A.product_id, A.seller_id, COUNT(*) AS sales_count
    FROM order_items AS A
    GROUP BY A.seller_id, A.product_id
)

SELECT seller_id, product_id, sales_count,
       ROW_NUMBER () OVER (PARTITION BY seller_id ORDER BY sales_count DESC) AS row_num,
       RANK () OVER (PARTITION BY seller_id ORDER BY sales_count DESC) AS rnk,
       DENSE_RANK () OVER (PARTITION BY seller_id ORDER BY sales_count DESC) AS dense_rnk
FROM ranked
/*
Tugas :  Top 3 produk terlaris per seller (berdasarkan COUNT penjualan)
output : seller_id, product_id, sale_count, rnk

Catatan :
a. kerjakan dengan pendekatan window function
b. window function tidak bisa langsung difilter di WHERE yang sama 
(ingat: WHERE dieksekusi sebelum SELECT/window function dalam pipeline) — 
butuh subquery/CTE pembungkus untuk filter rnk <= 3.

* mengapa kita menggunakan row_number() dan bukan ranked() ?
- ROW_NUMBER() → selalu strict N baris. 
sedangkan RANK() → bisa lebih dari N baris kalau ada tie di posisi batas.
: dengan rank, sales_count yang sama dapat ada gap misal 2 -> 4 
jika 2 dan 3 ada tie maka ranked akan menghasilkan nilai 2 untuk keduanya.

*/

-- window function approach
WITH ranked AS (
    SELECT A.product_id, A.seller_id, COUNT(*) AS sales_count
    FROM order_items AS A
    GROUP BY A.seller_id, A.product_id
), ranked_filtered AS (
    SELECT seller_id, product_id, sales_count,
        ROW_NUMBER () OVER (PARTITION BY seller_id ORDER BY sales_count DESC) AS rnk
    FROM RANKED
)

SELECT seller_id, product_id, sales_count,rnk
FROM ranked_filtered
WHERE rnk <= 3
ORDER BY seller_id, rnk
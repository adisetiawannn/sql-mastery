/*
Cari data top-N dari suatu kategori setelah JOIN. 
Di Tier 4 (window function) ada cara lebih elegan, 
tapi sekarang latih dengan subquery + JOIN approach dulu.

Tugas:

Untuk setiap seller_id, cari top 3 produk yang paling sering dijual 
(berdasarkan COUNT jumlah penjualan per produk). 
Tampilkan seller info dan produk infonya.

Output: seller_id, seller_city, product_id, product_name, sale_count

Catatan:
- Hitung jumlah penjualan per (seller_id, product_id) dari order_items
- Ranking top 3 per seller
- JOIN dengan sellers dan products untuk ambil info lengkap
*/

-- approach 1 -> subquery workflow

SELECT ranked.seller_id, sellers.seller_city, 
    ranked.product_id, 
    product_category_name_translation.product_category_name_english AS product_name, 
    ranked.sales_count

-- core of the query 
---- #1 from will be executed first (as sql flow-execution rules)
FROM (
    SELECT A.product_id, A.seller_id, COUNT(*) AS sales_count
    FROM order_items AS A
    GROUP BY A.seller_id, A.product_id
) AS ranked

---- #2 JOIN will be executed second (as sql flow-execution rules)
JOIN sellers ON ranked.seller_id = sellers.seller_id
JOIN products ON ranked.product_id = products.product_id
LEFT JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name

---- #3 where will be executed third (as sql flow-execution rules)
WHERE (
    SELECT COUNT(*)
    FROM ( -- tabel ranked dari #1 tidak bisa diakses di #3, sehingga perlu ditulis ulang
        SELECT A.product_id, A.seller_id, COUNT(*) AS sales_count
        FROM order_items AS A
        GROUP BY A.seller_id, A.product_id
        ) AS other
    WHERE 
    other.seller_id = ranked.seller_id AND
    other.sales_count > ranked.sales_count  
        
) < 3

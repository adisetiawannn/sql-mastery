/*
0.3 — IN / LIKE / BETWEEN

Cari semua produk (products) yang product_category_name-nya mengandung kata "casa" 
(rumah, dalam Bahasa Portugis — dataset Olist berbasis Brasil) 
ATAU termasuk dalam kategori 'beleza_saude' atau 'esporte_lazer'. 
Gunakan kombinasi LIKE dan IN.
*/

SELECT product_id, product_category_name
FROM products
WHERE product_category_name LIKE '%casa%' or product_category_name IN ('beleza_saude','esporte_lazer')
ORDER BY product_id;
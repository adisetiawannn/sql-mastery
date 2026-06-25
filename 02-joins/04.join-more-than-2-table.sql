/*
Cari semua review (order_reviews) dengan review_score rendah (1 atau 2), 
tapi order tersebut statusnya 'delivered' 
(artinya barang sudah sampai, customer kasih review buruk meski prosesnya selesai 
— sinyal kualitas produk/layanan buruk, bukan masalah pengiriman gagal). 
Tampilkan juga seller_id dari order_items yang terlibat di order itu.
Output: order_id, review_score, order_status, seller_id
*/

-- approach 1
SELECT A.order_id, A.review_score, B.order_status
FROM order_reviews AS A
INNER JOIN orders AS B On A.order_id = B.order_id
INNER JOIN order_items AS C ON A.order_id = C.order_id
WHERE A.review_score <=2 AND B.order_status = 'delivered'
ORDER BY A.review_score DESC, A.order_id DESC;

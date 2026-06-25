/*
FULL OUTER JOIN menampilkan semua baris dari 
kedua tabel (matched + unmatched dari keduanya). 
Berguna untuk cek konsistensi/gap data.

Tugas:
Cari anomali data:
Seller ada di sellers tapi tidak punya item di order_items (tidak pernah jual)
Seller_id di order_items tapi tidak ada di sellers (orphan/invalid data)

Gunakan FULL OUTER JOIN. 

Output: seller_id, seller_city (dari sellers), product_id (dari order_items), 
status Dimana, status adalah label: 
1. 'Seller not selling' -> ada di sellers, tidak di order_items, 
2. 'Orphan seller' -> di order_items, tidak di sellers, 
3. 'Valid' -> ada di keduanya
*/

-- approach 1
SELECT COALESCE(A.seller_id, B.seller_id) AS seller_id, A.seller_city, B.product_id, 
    CASE 
        WHEN A.seller_id IS NOT NULL AND B.seller_id IS NULL THEN 'Seller not Selling'
        WHEN A.seller_id IS NULL AND B.seller_id IS NOT NULL THEN 'Orphan Seller'
        ELSE 'Valid'
    END AS status
FROM sellers AS A
FULL OUTER JOIN order_items AS B ON A.seller_id = B.seller_id
ORDER BY status;

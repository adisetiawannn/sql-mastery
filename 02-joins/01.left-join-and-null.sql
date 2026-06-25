/*
Cari semua seller_id dari tabel sellers yang belum pernah menjual satu item pun 
(tidak ada baris terkait di order_items). Gunakan LEFT JOIN, 
bukan NOT EXISTS (itu untuk soal berikutnya — latih dulu versi LEFT JOIN-nya).
*/


-- approach 1
SELECT ori.seller_id, ori.seller_city, ori.seller_state,COUNT(reff.order_id)
FROM sellers AS ori
LEFT JOIN order_items AS reff ON ori.seller_id = reff.seller_id
GROUP BY ori.seller_id
HAVING COUNT(reff.order_id) = 0


--approach 2
SELECT s.seller_id, s.seller_city, s.seller_state
FROM sellers AS s
LEFT JOIN order_items AS oi ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;
/*
Cari pasangan seller yang berada di kota yang sama (seller_city), 
tapi merupakan seller yang berbeda (seller_id berbeda). 
Tampilkan tiap pasangan hanya sekali (jangan tampilkan A-B dan B-A 
sebagai dua baris terpisah — itu pasangan yang sama, cuma dibalik).
Output: seller_id_a, seller_id_b, seller_city
*/

-- approach 1
SELECT ori.seller_id as seller_id_a, reff.seller_id as seller_id_b, ori.seller_city
FROM sellers AS ori
JOIN sellers AS reff ON ori.seller_city = reff.seller_city
                    AND ori.seller_id < reff.seller_id


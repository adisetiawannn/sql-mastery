/*
brief : beberapa CTE berurutan, di mana CTE kedua membaca 
dari CTE pertama, CTE ketiga membaca dari CTE kedua — 
seperti pipeline bertingkat

tugas : Cari customer paling loyal per state — 
customer dengan jumlah order terbanyak di tiap seller_state 
(state dari seller yang dia beli, sebagai proxy lokasi transaksi — 
Olist tidak punya state customer langsung di order_items,
jadi kita pakai state seller sebagai pendekatan).

Output: seller_state, customer_unique_id, order_count
Tabel yang dibutuhkan: orders (customer_id), customers (customer_unique_id), 
order_items (seller_id), sellers (seller_state).

Catatan: Ini butuh JOIN 4 tabel di langkah 1 untuk menghubungkan 
customer ke seller_state lewat order. 

*/

-- CTE
WITH customer_order AS (
    SELECT B.customer_unique_id, A.order_id
    FROM orders AS A
    JOIN customers AS B ON A.customer_id = B.customer_id
    ), 
order_state AS (
    SELECT D.seller_id, C.customer_unique_id, C.order_id
    FROM customer_order AS C
    JOIN order_items AS D ON C.order_id = D.order_id
    ), 
order_state_v2 AS (
    SELECT F.seller_state, E.customer_unique_id, 
            COUNT(DISTINCT E.order_id) AS order_count
    FROM order_state AS E
    JOIN sellers AS F ON E.seller_id = F.seller_id
    GROUP BY F.seller_state, E.customer_unique_id
    ),
order_state_final AS (
    SELECT *
    FROM order_state_v2 AS G
    WHERE NOT EXISTS(
        SELECT * FROM order_state_v2 AS H
        WHERE G.seller_state = H.seller_state AND 
             G.order_count < H.order_count
    )
)

-- main query
SELECT seller_state, customer_unique_id AS customers, order_count
FROM order_state_final
ORDER BY order_count DESC;
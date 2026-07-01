/*
Brief: Dua cara berbeda untuk "cek apakah nilai ini ada di kumpulan hasil subquery." 
Sintaksnya beda, secara konsep mirip,  tapi mekanisme di baliknya berbeda 

-   IN (subquery) — bandingkan satu kolom dengan daftar nilai hasil subquery 
    (subquery harus 1 kolom, boleh banyak baris). | hanya pakai tabel dalam
-   EXISTS (correlated subquery) — cek apakah ada baris yang match sama sekali 
    (subquery merujuk balik ke tabel luar) | bisa reffer / pakai tabel dalam dan luar

Tugas: Cari customer_id yang pernah memberi review dengan review_score = 1.
Output: customer_id
Catatan: review_score ada di order_reviews, terhubung ke orders lewat order_id, 
dan customer_id ada di orders. Tulis dua versi:

Task 1. Pakai IN
Task 2. Pakai EXISTS (correlated, merujuk balik ke orders.order_id)
*/

-- CTE
WITH review_score_1 AS (
    SELECT order_id
    FROM order_reviews
    WHERE review_score = 1
)

-- main query : IN version
SELECT customer_id
FROM orders
WHERE order_id IN (SELECT order_id FROM review_score_1);


-- CTE
WITH review_score_1 AS (
    SELECT order_id
    FROM order_reviews
    WHERE review_score = 1
)
-- main query : EXISTS version
SELECT customer_id
FROM orders
WHERE EXISTS (SELECT order_id FROM review_score_1
              WHERE orders.order_id = review_score_1.order_id);

/*

Short Brief : SUM(...) OVER (PARTITION BY ... ORDER BY ...) 
menjumlahkan dari baris pertama sampai baris saat ini 

Perbedaan penting dengan OVER ()
-   SUM(x) OVER () (tanpa ORDER BY) → jumlahkan semua baris dalam partisi, 
    hasilnya sama untuk setiap baris (grand total).

-   SUM(x) OVER (ORDER BY y) (dengan ORDER BY) → jumlahkan dari baris 
    pertama sampai baris ini saja (running/cumulative), 
    hasilnya berubah tiap baris.

EX : SUM(revenue) OVER (PARTITION BY seller_id ORDER BY month) AS running_total
- ORDER BY month di sini membuat window function bekerja secara 
kumulatif mengikuti urutan waktu — baris bulan Januari cuma jumlahkan Januari,
baris Februari jumlahkan Januari+Februari, dst.

Tugas: Hitung revenue per (seller_id, month), 
lalu tambahkan running total
(cumulative revenue dari bulan pertama sampai bulan itu) per seller.

Output: seller_id, month, revenue, running_total

*/

-- approach : window function
WITH running_total AS (
    SELECT A.seller_id, 
           DATE_TRUNC('month', B.order_purchase_timestamp) AS bulan,
           SUM(A.price) AS revenue
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
    GROUP BY A.seller_id, bulan
), running_total_filtered AS (
    SELECT *, SUM(revenue) OVER (PARTITION BY seller_id ORDER BY bulan) AS running_total
    FROM running_total
)

SELECT * FROM running_total_filtered 
ORDER BY seller_id DESC,bulan ASC;
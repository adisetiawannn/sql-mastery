/*
Brief: Pivot adalah teknik mengubah data dari format baris (vertikal) ke 
format kolom (horizontal). SQL tidak punya syntax PIVOT native di PostgreSQL,
 tapi bisa disimulasikan dengan dua cara: COUNT(*) FILTER (WHERE ...) 
atau SUM(CASE WHEN ... END).

Limitasi : kolom pivot harus diketahui saat menulis query — 
tidak bisa dinamis otomatis di SQL standar. Kalau jumlah bulan/kategorinya
tidak diketahui di awal, butuh dynamic SQL 

Tugas: Buat tabel pivot yang menampilkan jumlah order per order_status 
untuk setiap tahun (2016, 2017, 2018) — satu baris per tahun, 
satu kolom per status.

Output :
year | delivered | shipped | canceled | invoiced | processing | approved | unavailable | created
2016 | ...       | ...     | ...      | ...      | ...        | ...      | ...         | ...
2017 | ...
2018 | ...

*/

WITH order_year AS (
    SELECT EXTRACT (YEAR FROM A.order_purchase_timestamp) AS tahun, A.order_status
    FROM orders AS A
    )

SELECT tahun,
       COUNT (*) FILTER (WHERE order_status = 'delivered') AS delivered,
       COUNT (*) FILTER (WHERE order_status = 'shipped') AS shipped,
       COUNT (*) FILTER (WHERE order_status = 'canceled') AS canceled,
       COUNT (*) FILTER (WHERE order_status = 'invoiced') AS invoiced,
       COUNT (*) FILTER (WHERE order_status = 'processing') AS processing,
       COUNT (*) FILTER (WHERE order_status = 'approved') AS approved,
       COUNT (*) FILTER (WHERE order_status = 'unavailable') AS unavailable,
       COUNT (*) FILTER (WHERE order_status = 'created') AS created
FROM order_year
GROUP BY tahun;
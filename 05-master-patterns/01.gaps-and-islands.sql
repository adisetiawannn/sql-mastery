/*
Brief: Gaps & Islands adalah pattern untuk mendeteksi periode kontinu (islands) 
dan jeda (gaps) dalam data berurutan waktu. Sangat relevan ke telco: 
subscriber yang aktif berbulan-bulan, lalu churn, lalu aktif lagi — 
itu islands yang dipisahkan gaps.

Key Concepts : 
Kunci pattern ini adalah membuat grup identifier untuk tiap island. 
Caranya: bandingkan nomor urut baris (ROW_NUMBER()) 
dengan nilai yang dikelompokkan — selisihnya akan konstan selama masih
dalam island yang sama, dan berubah begitu ada gap.


Tugas: Untuk setiap seller_id, temukan periode aktif berjualan 
(bulan-bulan berturut-turut yang seller itu punya minimal 1 transaksi) — 
tampilkan awal dan akhir tiap periode aktif, serta durasi berapa bulan.

Output: seller_id, island_start, island_end, duration_months

Langkah pengerjaan : 

1. Buat daftar bulan aktif per seller (dari order_items JOIN orders, 
DATE_TRUNC per bulan)
2. Beri ROW_NUMBER() per seller urut bulan
3. Hitung island_id = selisih antara bulan (dalam angka) dan ROW_NUMBER()
4. GROUP BY seller_id, island_id → ambil MIN(bulan) sebagai start, 
MAX(bulan) sebagai end

*/


WITH active_month AS (
    SELECT  DISTINCT A.seller_id,
            DATE_TRUNC('month',B.order_purchase_timestamp) AS active_month
    FROM order_items AS A
    JOIN orders AS B ON A.order_id = B.order_id
), active_month_number AS (
    SELECT  *,
            ROW_NUMBER() OVER (PARTITION BY seller_id ORDER BY active_month) AS rnk,
            EXTRACT(YEAR FROM active_month) * 12 + EXTRACT (MONTH FROM active_month) AS month_number
    FROM active_month
)

SELECT seller_id,
        month_number-rnk AS island_id,
        MIN(active_month) AS island_start,
        MAX(active_month) AS island_end,
        COUNT(*) AS duration_months
FROM active_month_number
GROUP BY seller_id, island_id
ORDER BY seller_id, island_id,island_start;
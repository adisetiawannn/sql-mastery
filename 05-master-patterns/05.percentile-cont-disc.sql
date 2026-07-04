/*
Brief : AVG() bisa menyesatkan kalau distribusi datanya skewed (miring) — 
satu outlier besar bisa menarik rata-rata jauh dari "nilai tipikal". 
Percentile memberi gambaran distribusi yang lebih tahan terhadap outlier: median (P50), P90, P95, dll.

syntax :
1. PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY kolom) AS median
2. PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY kolom) AS p90

Perbedaan dengan window function biasa: PERCENTILE_CONT adalah aggregate function, 
bukan window function murni — dia dipakai dengan GROUP BY biasa 
(mengembalikan satu angka per grup), bukan OVER(). Meski begitu, ada juga versi 
window-nya (PERCENTILE_CONT(...) OVER (...)) untuk kasus tertentu — tapi bentuk paling 
umum adalah versi aggregate.

Tugas: Hitung median dan P90 dari total_order_value (SUM price per order, 
seperti Tier 3.1) di seluruh data. Bandingkan dengan AVG() untuk melihat 
seberapa skewed distribusinya.

Output: avg_value, median_value, p90_value

*/ 


-- hitung median dan P90
WITH order_totals AS (
    SELECT order_id, SUM(price) AS total_order_value
    FROM order_items
    GROUP BY order_id
)

SELECT
    AVG(total_order_value) AS avg_value,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_order_value) AS median_value,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_order_value) AS p90_value
FROM order_totals
/*
Konsep : Sessionization mengelompokkan event/aktivitas jadi "sesi" berdasarkan gap waktu — 
kalau jeda antar aktivitas melebihi threshold tertentu (misal 30 menit), 
dianggap sesi baru dimulai. Ini pattern klasik di web analytics (session browsing),
tapi juga relevan ke telco: usage session data (call, data usage) yang perlu dikelompokkan 
jadi "satu sesi pemakaian". 

Mekanisme: mirip Gaps & Islands (5.1), tapi bedanya:
Gaps & Islands bekerja di level bulan (granularity kasar, threshold implisit = 1 bulan).
Sessionization bekerja di level timestamp presisi tinggi (menit/jam), 
dengan threshold eksplisit yang Anda tentukan (misal 30 menit).

pola standar :
LAG(timestamp) OVER (PARTITION BY user ORDER BY timestamp) AS prev_timestamp,
CASE WHEN timestamp - prev_timestamp > INTERVAL '30 minutes' 
     THEN 1 ELSE 0 END AS new_session_flag


Tugas: Untuk tiap customer_unique_id, kelompokkan review mereka jadi "sesi engagement" — 
kalau jeda antar review lebih dari 90 hari, dianggap sesi baru.

Output: customer_unique_id, session_id, review_id, review_creation_date
*/

WITH review_sessions AS (
    SELECT A.customer_unique_id,C.review_id, C.review_creation_date
    FROM customers AS A
    JOIN orders AS B ON A.customer_id = B.customer_id
    JOIN order_reviews AS C ON B.order_id = C.order_id
), session_gaps AS (
    SELECT  *,
            LAG(review_creation_date) OVER (PARTITION BY customer_unique_id ORDER BY review_creation_date ASC) AS prev_review_date
    FROM review_sessions
), sessions_flag AS (
    SELECT  *,
            CASE WHEN prev_review_date IS NULL OR review_creation_date - prev_review_date > INTERVAL '90 days'
                 THEN 1 ELSE 0 END AS new_session_flag
    FROM session_gaps
), sessions_final AS (
    SELECT  *,
            SUM(new_session_flag) OVER (PARTITION BY customer_unique_id ORDER BY review_creation_date ASC) AS session_id
    FROM sessions_flag
)

SELECT *
FROM sessions_final
ORDER BY customer_unique_id, review_creation_date, session_id DESC;

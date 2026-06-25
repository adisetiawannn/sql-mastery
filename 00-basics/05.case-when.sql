/*
Dari order_reviews, buat kategori kualitatif dari review_score (1-5): 
skor 4-5 = 'Positive', skor 3 = 'Neutral', skor 1-2 = 'Negative'. 
Output: review_id, review_score, sentiment_label, 
lalu hitung jumlah review per sentiment_label.
*/


SELECT  review_id, review_score,
        CASE
            WHEN review_score >= 4 THEN 'Positive'
            WHEN review_score = 3 THEN 'Neutral'
            WHEN review_score <= 2 THEN 'Negative'
            ELSE NULL
        END AS sentiment_label,
        COUNT (*) as review_count
FROM order_reviews
GROUP BY review_id, review_score, sentiment_label
LIMIT 15;


-- hitung total review per sentiment_label
SELECT  CASE
            WHEN review_score >= 4 THEN 'Positive'
            WHEN review_score = 3 THEN 'Neutral'
            WHEN review_score <= 2 THEN 'Negative'
            ELSE NULL
        END AS sentiment_label,
        COUNT (*) as review_count
FROM order_reviews
GROUP BY sentiment_label;
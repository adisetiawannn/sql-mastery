/*
Tabel order_reviews punya kolom review_comment_message yang sering NULL 
(review tanpa komentar tertulis). 
Hitung: (a) berapa total review, (b) berapa yang punya komentar tertulis (non-NULL), 
(c) berapa persen review yang "diam" (cuma kasih skor, tanpa komentar). 
Gunakan COALESCE di salah satu bagian sebagai latihan, meski opsional secara logika.
*/

SELECT
    COUNT(*) AS total_review_with_comment,
    COUNT(*) FILTER(WHERE review_comment_message IS NULL) AS total_review_without_comment,
    round(100.0 * COUNT(*) FILTER (WHERE review_comment_message IS NULL) / COUNT(*), 2) AS pct_review_without_comment
FROM order_reviews;

SELECT review_id, review_score, 
       COALESCE(review_comment_message, '(tidak ada komentar)') AS comment_display
FROM order_reviews
ORDER BY review_id
LIMIT 5;
/*
Soal:
Buat satu kolom review_summary dengan prioritas tampil sebagai berikut:

1. Kalau review_comment_title ada isinya → tampilkan itu.
2. Kalau review_comment_title NULL tapi review_comment_message ada isinya → 
   tampilkan review_comment_message.
3. Kalau keduanya NULL → tampilkan teks '(no feedback text)'.

Lalu, di query yang sama, tambahkan satu kolom lagi bernama has_any_text yang bernilai TRUE 
kalau salah satu dari kedua kolom (title atau message) ada isinya, dan FALSE 
kalau keduanya NULL — tanpa pakai COALESCE untuk kolom ini, 
pakai cara lain (boleh CASE WHEN, boleh kombinasi IS NOT NULL).

Output: review_id, review_score, review_summary, has_any_text. 
Batasi LIMIT 15 saja biar gampang dicek manual.
*/


SELECT  review_id, review_score,
        COALESCE(review_comment_title, review_comment_message, 'no feedback text') as review_summary,
        CASE
            WHEN review_comment_title IS NOT NULL THEN TRUE
            WHEN review_comment_message IS NOT NULL THEN TRUE
            ELSE FALSE
        END as has_any_text
FROM    order_reviews
ORDER BY review_id
LIMIT 15
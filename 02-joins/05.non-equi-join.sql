/*
JOIN dengan kondisi bukan = (misal BETWEEN, >, <). 
Berguna untuk range matching, pricing tier, dll

Hitung total price per order dari order_items, 
lalu JOIN dengan tier — match berdasarkan BETWEEN min_value AND max_value.
Output: order_id, total_order_value, tier_name

dict of tier name : {
    'Economy' : '0-100',
    'Standard' : '100-500',
    'Premium' : '500-100000'}
*/

-- approach 1
-- create CTE tier table dan total order_order before both are joined
WITH tier AS (
    SELECT 'Economy' AS tier_name, 0 AS min_value, 100 AS max_value
    UNION ALL SELECT 'Standard', 100.01, 500
    UNION ALL SELECT 'Premium', 500.01, 100000), 
    
    total_order AS (
    SELECT SUM(price) AS total_order_value, order_id
    FROM order_items
    GROUP BY order_id)

SELECT A.order_id, A.total_order_value, B.tier_name
FROM total_order AS A
JOIN tier AS B ON A.total_order_value BETWEEN b.min_value AND b.max_value
ORDER BY A.total_order_value DESC;
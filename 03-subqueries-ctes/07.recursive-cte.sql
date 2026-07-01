/*
RECUSRSIVE CTE
Tugas: Tulis recursive CTE untuk menampilkan semua kategori 
beserta level kedalamannya 
dalam hierarki (root = level 0, anak root = level 1, dst).

Output: category_id, category_name, level, 
urutkan dari level terkecil, lalu category_id.
*/

CREATE TEMP TABLE category_tree (
    category_id INT PRIMARY KEY,
    category_name TEXT,
    parent_id INT  -- NULL berarti ini kategori root/teratas
);

INSERT INTO category_tree VALUES
(1, 'Electronics', NULL),
(2, 'Computers', 1),
(3, 'Laptops', 2),
(4, 'Desktops', 2),
(5, 'Phones', 1),
(6, 'Smartphones', 5),
(7, 'Gaming Laptops', 3);

WITH RECURSIVE table_hierarchi AS(
    -- base case
    SELECT category_id, category_name, parent_id, 0 AS level
    FROM category_tree
    WHERE parent_id IS NULL

    -- recursive case
    UNION ALL 
    SELECT A.category_id, A.category_name, A.parent_id, B.level + 1
    FROM category_tree AS A
    JOIN table_hierarchi AS B ON A.parent_id = B.category_id
)

SELECT category_id, category_name, level
FROM table_hierarchi
ORDER BY level ASC, category_id ASC;
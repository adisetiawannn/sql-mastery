-- =============================================================
-- import.sql  —  Run this ONCE after placing all 9 CSV files
--                in the same folder as this script (data/).
--
-- How to run (from Terminal, inside the data/ folder):
--   psql -U <your_username> -d sql_mastery -f import.sql
--
-- \copy reads from the CLIENT machine (your laptop), which means
-- it works for any user — no superuser privilege needed.
-- The CSV header row is skipped via HEADER option.
-- =============================================================

-- ── 1. customers ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS customers (
    customer_id              TEXT PRIMARY KEY,
    customer_unique_id       TEXT NOT NULL,
    customer_zip_code_prefix TEXT NOT NULL,
    customer_city            TEXT NOT NULL,
    customer_state           CHAR(2) NOT NULL
);
\copy customers FROM 'olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true);

-- ── 2. geolocation ────────────────────────────────────────────
-- No single-column PK — zip codes repeat with different lat/lng.
CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix TEXT        NOT NULL,
    geolocation_lat             NUMERIC(10,6) NOT NULL,
    geolocation_lng             NUMERIC(10,6) NOT NULL,
    geolocation_city            TEXT        NOT NULL,
    geolocation_state           CHAR(2)     NOT NULL
);
\copy geolocation FROM 'olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true);

-- ── 3. sellers ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sellers (
    seller_id              TEXT PRIMARY KEY,
    seller_zip_code_prefix TEXT NOT NULL,
    seller_city            TEXT NOT NULL,
    seller_state           CHAR(2) NOT NULL
);
\copy sellers FROM 'olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true);

-- ── 4. product_category_name_translation ──────────────────────
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);
\copy product_category_name_translation FROM 'product_category_name_translation.csv' WITH (FORMAT csv, HEADER true);

-- ── 5. products ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
    product_id                 TEXT PRIMARY KEY,
    product_category_name      TEXT REFERENCES product_category_name_translation(product_category_name),
    product_name_lenght        INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty         INTEGER,
    product_weight_g           NUMERIC(10,2),
    product_length_cm          NUMERIC(8,2),
    product_height_cm          NUMERIC(8,2),
    product_width_cm           NUMERIC(8,2)
);
\copy products FROM 'olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- ── 6. orders ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    order_id                      TEXT PRIMARY KEY,
    customer_id                   TEXT NOT NULL REFERENCES customers(customer_id),
    order_status                  TEXT NOT NULL,
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
\copy orders FROM 'olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- ── 7. order_items ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    order_id            TEXT    NOT NULL REFERENCES orders(order_id),
    order_item_id       INTEGER NOT NULL,
    product_id          TEXT    NOT NULL REFERENCES products(product_id),
    seller_id           TEXT    NOT NULL REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2) NOT NULL,
    freight_value       NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id)
);
\copy order_items FROM 'olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- ── 8. order_payments ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_payments (
    order_id             TEXT    NOT NULL REFERENCES orders(order_id),
    payment_sequential   INTEGER NOT NULL,
    payment_type         TEXT    NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value        NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential)
);
\copy order_payments FROM 'olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true);

-- ── 9. order_reviews ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_reviews (
    review_id               TEXT NOT NULL,
    order_id                TEXT NOT NULL REFERENCES orders(order_id),
    review_score            SMALLINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);
\copy order_reviews FROM 'olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

-- ── Verify row counts ─────────────────────────────────────────
SELECT 'customers'                        AS table_name, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'geolocation',               COUNT(*) FROM geolocation
UNION ALL SELECT 'sellers',                   COUNT(*) FROM sellers
UNION ALL SELECT 'products',                  COUNT(*) FROM products
UNION ALL SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation
UNION ALL SELECT 'orders',                    COUNT(*) FROM orders
UNION ALL SELECT 'order_items',               COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments',            COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews',             COUNT(*) FROM order_reviews
ORDER BY table_name;

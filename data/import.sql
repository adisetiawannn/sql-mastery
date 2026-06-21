-- =============================================================
-- import.sql  —  Run this from inside the data/ folder:
--   psql -U <your_username> -d sql_mastery -f import.sql
--
-- Safe to re-run: drops existing tables first in FK-safe order.
-- \copy reads from the client machine — no superuser needed.
-- =============================================================

-- ── Drop in reverse-dependency order ─────────────────────────
DROP TABLE IF EXISTS order_reviews CASCADE;
DROP TABLE IF EXISTS order_payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS sellers CASCADE;
DROP TABLE IF EXISTS geolocation CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS product_category_name_translation CASCADE;

-- ── 1. customers ──────────────────────────────────────────────
CREATE TABLE customers (
    customer_id              TEXT    PRIMARY KEY,
    customer_unique_id       TEXT    NOT NULL,
    customer_zip_code_prefix TEXT    NOT NULL,
    customer_city            TEXT    NOT NULL,
    customer_state           CHAR(2) NOT NULL
);
\copy customers FROM 'olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true)

-- ── 2. geolocation ────────────────────────────────────────────
CREATE TABLE geolocation (
    geolocation_zip_code_prefix TEXT          NOT NULL,
    geolocation_lat             NUMERIC(10,6) NOT NULL,
    geolocation_lng             NUMERIC(10,6) NOT NULL,
    geolocation_city            TEXT          NOT NULL,
    geolocation_state           CHAR(2)       NOT NULL
);
\copy geolocation FROM 'olist_geolocation_dataset.csv' WITH (FORMAT csv, HEADER true)

-- ── 3. sellers ────────────────────────────────────────────────
CREATE TABLE sellers (
    seller_id              TEXT    PRIMARY KEY,
    seller_zip_code_prefix TEXT    NOT NULL,
    seller_city            TEXT    NOT NULL,
    seller_state           CHAR(2) NOT NULL
);
\copy sellers FROM 'olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true)

-- ── 4. product_category_name_translation ──────────────────────
CREATE TABLE product_category_name_translation (
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);
\copy product_category_name_translation FROM 'product_category_name_translation.csv' WITH (FORMAT csv, HEADER true)

-- ── 5. products ───────────────────────────────────────────────
-- No FK to product_category_name_translation: the dataset has categories
-- (e.g. 'pc_gamer') that are missing from the translation table.
CREATE TABLE products (
    product_id                 TEXT PRIMARY KEY,
    product_category_name      TEXT,
    product_name_lenght        INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty         INTEGER,
    product_weight_g           NUMERIC(10,2),
    product_length_cm          NUMERIC(8,2),
    product_height_cm          NUMERIC(8,2),
    product_width_cm           NUMERIC(8,2)
);
\copy products FROM 'olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '')

-- ── 6. orders ─────────────────────────────────────────────────
CREATE TABLE orders (
    order_id                      TEXT PRIMARY KEY,
    customer_id                   TEXT NOT NULL REFERENCES customers(customer_id),
    order_status                  TEXT NOT NULL,
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
\copy orders FROM 'olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '')

-- ── 7. order_items ────────────────────────────────────────────
CREATE TABLE order_items (
    order_id            TEXT          NOT NULL REFERENCES orders(order_id),
    order_item_id       INTEGER       NOT NULL,
    product_id          TEXT          NOT NULL REFERENCES products(product_id),
    seller_id           TEXT          NOT NULL REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2) NOT NULL,
    freight_value       NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id)
);
\copy order_items FROM 'olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '')

-- ── 8. order_payments ─────────────────────────────────────────
CREATE TABLE order_payments (
    order_id             TEXT          NOT NULL REFERENCES orders(order_id),
    payment_sequential   INTEGER       NOT NULL,
    payment_type         TEXT          NOT NULL,
    payment_installments INTEGER       NOT NULL,
    payment_value        NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential)
);
\copy order_payments FROM 'olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true)

-- ── 9. order_reviews ──────────────────────────────────────────
CREATE TABLE order_reviews (
    review_id               TEXT     NOT NULL,
    order_id                TEXT     NOT NULL REFERENCES orders(order_id),
    review_score            SMALLINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
);
\copy order_reviews FROM 'olist_order_reviews_dataset.csv' WITH (FORMAT csv, HEADER true, NULL '')

-- ── Indexes ───────────────────────────────────────────────────
CREATE INDEX idx_geolocation_zip   ON geolocation  (geolocation_zip_code_prefix);
CREATE INDEX idx_orders_customer   ON orders       (customer_id);
CREATE INDEX idx_orders_status     ON orders       (order_status);
CREATE INDEX idx_orders_purchase   ON orders       (order_purchase_timestamp);
CREATE INDEX idx_order_items_prod  ON order_items  (product_id);
CREATE INDEX idx_order_items_seller ON order_items (seller_id);
CREATE INDEX idx_reviews_order     ON order_reviews(order_id);
CREATE INDEX idx_reviews_score     ON order_reviews(review_score);

-- ── Verify row counts ─────────────────────────────────────────
SELECT table_name, rows FROM (
    SELECT 'customers'                        AS table_name, COUNT(*) AS rows FROM customers
    UNION ALL SELECT 'geolocation',               COUNT(*) FROM geolocation
    UNION ALL SELECT 'sellers',                   COUNT(*) FROM sellers
    UNION ALL SELECT 'products',                  COUNT(*) FROM products
    UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_name_translation
    UNION ALL SELECT 'orders',                    COUNT(*) FROM orders
    UNION ALL SELECT 'order_items',               COUNT(*) FROM order_items
    UNION ALL SELECT 'order_payments',            COUNT(*) FROM order_payments
    UNION ALL SELECT 'order_reviews',             COUNT(*) FROM order_reviews
) t ORDER BY table_name;

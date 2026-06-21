-- =============================================================
-- schema.sql  —  DDL for sql_mastery database
-- Dataset: Brazilian E-Commerce Public Dataset by Olist
-- Source:  https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
--
-- To recreate from scratch:
--   psql -U <username> -d sql_mastery -f schema.sql
-- =============================================================

-- ── Lookup / reference tables (no FK dependencies) ────────────

CREATE TABLE customers (
    customer_id              TEXT    PRIMARY KEY,
    customer_unique_id       TEXT    NOT NULL,
    customer_zip_code_prefix TEXT    NOT NULL,
    customer_city            TEXT    NOT NULL,
    customer_state           CHAR(2) NOT NULL
);

-- zip codes repeat (multiple lat/lng per zip), so no single PK
CREATE TABLE geolocation (
    geolocation_zip_code_prefix TEXT          NOT NULL,
    geolocation_lat             NUMERIC(10,6) NOT NULL,
    geolocation_lng             NUMERIC(10,6) NOT NULL,
    geolocation_city            TEXT          NOT NULL,
    geolocation_state           CHAR(2)       NOT NULL
);

CREATE INDEX idx_geolocation_zip ON geolocation (geolocation_zip_code_prefix);

CREATE TABLE sellers (
    seller_id              TEXT    PRIMARY KEY,
    seller_zip_code_prefix TEXT    NOT NULL,
    seller_city            TEXT    NOT NULL,
    seller_state           CHAR(2) NOT NULL
);

CREATE TABLE product_category_name_translation (
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);

-- ── Core entity tables ────────────────────────────────────────

CREATE TABLE products (
    product_id                 TEXT PRIMARY KEY,
    product_category_name      TEXT REFERENCES product_category_name_translation (product_category_name),
    product_name_lenght        INTEGER,       -- typo preserved from source CSV header
    product_description_lenght INTEGER,       -- typo preserved from source CSV header
    product_photos_qty         INTEGER,
    product_weight_g           NUMERIC(10,2),
    product_length_cm          NUMERIC(8,2),
    product_height_cm          NUMERIC(8,2),
    product_width_cm           NUMERIC(8,2)
);

CREATE TABLE orders (
    order_id                      TEXT      PRIMARY KEY,
    customer_id                   TEXT      NOT NULL,
    order_status                  TEXT      NOT NULL,
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_orders_status      ON orders (order_status);
CREATE INDEX idx_orders_purchase_ts ON orders (order_purchase_timestamp);

-- ── Transaction / event tables ────────────────────────────────

CREATE TABLE order_items (
    order_id            TEXT          NOT NULL,
    order_item_id       INTEGER       NOT NULL,   -- 1-based sequence per order
    product_id          TEXT          NOT NULL,
    seller_id           TEXT          NOT NULL,
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10,2) NOT NULL,
    freight_value       NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)   REFERENCES orders   (order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products (product_id),
    CONSTRAINT fk_order_items_seller
        FOREIGN KEY (seller_id)  REFERENCES sellers  (seller_id)
);

CREATE INDEX idx_order_items_product_id ON order_items (product_id);
CREATE INDEX idx_order_items_seller_id  ON order_items (seller_id);

CREATE TABLE order_payments (
    order_id             TEXT          NOT NULL,
    payment_sequential   INTEGER       NOT NULL,  -- multiple payment methods per order
    payment_type         TEXT          NOT NULL,
    payment_installments INTEGER       NOT NULL,
    payment_value        NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_order_payments_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

CREATE TABLE order_reviews (
    review_id               TEXT     NOT NULL,
    order_id                TEXT     NOT NULL,
    review_score            SMALLINT NOT NULL CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    -- composite PK: same review_id can theoretically appear for different orders
    PRIMARY KEY (review_id, order_id),

    CONSTRAINT fk_order_reviews_order
        FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

CREATE INDEX idx_order_reviews_order_id ON order_reviews (order_id);
CREATE INDEX idx_order_reviews_score    ON order_reviews (review_score);

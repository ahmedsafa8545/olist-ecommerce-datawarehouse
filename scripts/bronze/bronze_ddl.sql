-- =============================================================================
-- Script: Create Bronze Layer Tables
-- Purpose: Defines the raw/staging tables for the Olist Brazilian E-Commerce
--          Data Warehouse. Each table mirrors the structure of its source CSV
--          with minimal transformation (Bronze = raw layer).
-- Notes:
--   - Zip code columns are NVARCHAR to preserve leading zeros (e.g., 01310).
--   - Lat/Lng columns are FLOAT to preserve decimal precision.
--   - Column names with typos (e.g., "lenght") are kept as-is to match the
--     original source files; they will be corrected in the Silver layer.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_customers
-- Source: olist_customers_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_customers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_customers;
GO
CREATE TABLE bronze.olist_customers (
    customer_id NVARCHAR(100),                 -- Unique ID per order (changes per order)
    customer_unique_id NVARCHAR(100),           -- Unique ID per actual customer
    customer_zip_code_prefix NVARCHAR(10),      -- Kept as text to preserve leading zeros
    customer_city NVARCHAR(50),
    customer_state NVARCHAR(50)
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_geolocation
-- Source: olist_geolocation_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_geolocation', 'U') IS NOT NULL
    DROP TABLE bronze.olist_geolocation;
GO
CREATE TABLE bronze.olist_geolocation (
    geolocation_zip NVARCHAR(10),               -- Kept as text to preserve leading zeros
    geolocation_lat FLOAT,                      -- Must be FLOAT/DECIMAL, not INT, to keep coordinate precision
    geolocation_lng FLOAT,
    geolocation_city NVARCHAR(50),
    geolocation_state NVARCHAR(50)
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_order_items
-- Source: olist_order_items_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_order_items', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_items;
GO
CREATE TABLE bronze.olist_order_items (
    order_id NVARCHAR(100),
    order_item_id INT,                          -- Sequential item number within an order
    product_id NVARCHAR(100),
    seller_id NVARCHAR(100),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_order_payments
-- Source: olist_order_payments_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_order_payments', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_payments;
GO
CREATE TABLE bronze.olist_order_payments (
    order_id NVARCHAR(100),
    payment_sequential INT,                     -- Order of payment if multiple payments were used
    payment_type NVARCHAR(50),
    payment_installments INT,
    payment_value FLOAT
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_order_reviews
-- Source: olist_order_reviews_dataset.csv
-- Note: Comment fields are in Portuguese and may contain embedded commas/quotes,
--       which requires special handling (FORMAT='CSV') during BULK INSERT.
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_order_reviews', 'U') IS NOT NULL
    DROP TABLE bronze.olist_order_reviews;
GO
CREATE TABLE bronze.olist_order_reviews (
    review_id NVARCHAR(100),
    order_id NVARCHAR(100),
    review_score INT,
    review_comment_title NVARCHAR(500),         -- Free text, Portuguese
    review_comment_message NVARCHAR(500),       -- Free text, Portuguese
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_orders
-- Source: olist_orders_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_orders', 'U') IS NOT NULL
    DROP TABLE bronze.olist_orders;
GO
CREATE TABLE bronze.olist_orders (
    order_id NVARCHAR(100),
    customer_id NVARCHAR(100),
    order_status NVARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,     -- Can be NULL if order wasn't delivered
    order_estimated_delivery_date DATETIME
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_products
-- Source: olist_products_dataset.csv
-- Note: Column names "lenght" (typo) are kept to match the original source file.
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_products', 'U') IS NOT NULL
    DROP TABLE bronze.olist_products;
GO
CREATE TABLE bronze.olist_products (
    product_id NVARCHAR(100),
    product_category_name NVARCHAR(50),         -- Portuguese category name (join to translation table)
    product_name_lenght INT,                    -- [sic] typo preserved from source
    product_description_lenght INT,             -- [sic] typo preserved from source
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.olist_sellers
-- Source: olist_sellers_dataset.csv
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.olist_sellers', 'U') IS NOT NULL
    DROP TABLE bronze.olist_sellers;
GO
CREATE TABLE bronze.olist_sellers (
    seller_id NVARCHAR(100),
    seller_zip_code_prefix NVARCHAR(10),        -- Kept as text to preserve leading zeros
    seller_city NVARCHAR(50),
    seller_state NVARCHAR(50)
);
GO

-- -----------------------------------------------------------------------------
-- Table: bronze.product_category_name_translation
-- Source: product_category_name_translation.csv
-- Purpose: Lookup table to translate Portuguese product category names to English.
-- -----------------------------------------------------------------------------
IF OBJECT_ID('bronze.product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE bronze.product_category_name_translation;
GO
CREATE TABLE bronze.product_category_name_translation (
    product_category_name NVARCHAR(50),         -- Portuguese
    product_category_name_english NVARCHAR(50)  -- English
);
GO

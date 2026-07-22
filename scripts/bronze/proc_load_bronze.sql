-- =============================================================================
-- Stored Procedure: bronze.load_bronze
-- Purpose: Truncates and reloads all Bronze layer tables from source CSV files
--          for the Olist Brazilian E-Commerce Data Warehouse project.
-- Notes:
--   - CODEPAGE = '65001' ensures UTF-8 characters (Portuguese accents: á, ã, ç, é, ô)
--     load correctly instead of becoming garbled text.
--   - olist_order_reviews uses FORMAT = 'CSV' + FIELDQUOTE because its free-text
--     review fields contain embedded commas/quotes that break plain BULK INSERT.
-- =============================================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
    DECLARE @table_start_time DATETIME, @table_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=====================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=====================================================';

        -- ---------------------------------------------------------------
        -- 1. Customers
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_customers';
        TRUNCATE TABLE bronze.olist_customers;

        PRINT '>> Inserting Data Into: bronze.olist_customers';
        BULK INSERT bronze.olist_customers
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_customers_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 2. Geolocation
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_geolocation';
        TRUNCATE TABLE bronze.olist_geolocation;

        PRINT '>> Inserting Data Into: bronze.olist_geolocation';
        BULK INSERT bronze.olist_geolocation
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_geolocation_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 3. Order Items
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_items';
        TRUNCATE TABLE bronze.olist_order_items;

        PRINT '>> Inserting Data Into: bronze.olist_order_items';
        BULK INSERT bronze.olist_order_items
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_order_items_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 4. Order Payments
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_payments';
        TRUNCATE TABLE bronze.olist_order_payments;

        PRINT '>> Inserting Data Into: bronze.olist_order_payments';
        BULK INSERT bronze.olist_order_payments
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_order_payments_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 5. Order Reviews
        -- Uses FORMAT = 'CSV' + FIELDQUOTE to correctly handle embedded
        -- commas/quotes inside free-text Portuguese review comments.
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_order_reviews';
        TRUNCATE TABLE bronze.olist_order_reviews;

        PRINT '>> Inserting Data Into: bronze.olist_order_reviews';
        BULK INSERT bronze.olist_order_reviews
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_order_reviews_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FORMAT = 'CSV',
            FIELDQUOTE = '"',
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 6. Orders
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_orders';
        TRUNCATE TABLE bronze.olist_orders;

        PRINT '>> Inserting Data Into: bronze.olist_orders';
        BULK INSERT bronze.olist_orders
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_orders_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 7. Products
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_products';
        TRUNCATE TABLE bronze.olist_products;

        PRINT '>> Inserting Data Into: bronze.olist_products';
        BULK INSERT bronze.olist_products
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_products_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 8. Sellers
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.olist_sellers';
        TRUNCATE TABLE bronze.olist_sellers;

        PRINT '>> Inserting Data Into: bronze.olist_sellers';
        BULK INSERT bronze.olist_sellers
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\olist_sellers_dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- 9. Product Category Name Translation
        -- ---------------------------------------------------------------
        SET @table_start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.product_category_name_translation';
        TRUNCATE TABLE bronze.product_category_name_translation;

        PRINT '>> Inserting Data Into: bronze.product_category_name_translation';
        BULK INSERT bronze.product_category_name_translation
        FROM 'E:\Olist Brazilian E-Commerce_datawarehouse\source\product_category_name_translation.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @table_end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @table_start_time, @table_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '-----------------------------------------------------';

        -- ---------------------------------------------------------------
        -- Total batch duration
        -- ---------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '=====================================================';
        PRINT 'Bronze Layer Load Completed Successfully';
        PRINT '>> Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '=====================================================';

    END TRY
    BEGIN CATCH
        PRINT '=====================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=====================================================';
    END CATCH
END
GO


EXEC bronze.load_bronze;

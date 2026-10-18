 CREATE DATABASE OlistDW;
GO

USE OlistDW;
GO

CREATE SCHEMA dw;
GO

CREATE TABLE dw.DimDate (
    date_key INT NOT NULL PRIMARY KEY,       -- Format: YYYYMMDD
    full_date DATE NOT NULL UNIQUE,
    [year] INT NOT NULL,
    [quarter] INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    [day] INT NOT NULL
);

CREATE TABLE dw.DimCustomer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL UNIQUE,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_city NVARCHAR(100) NULL,
    customer_state VARCHAR(10) NULL,
    customer_zip_code_prefix INT NULL
);

CREATE TABLE dw.DimProduct (
    product_key INT IDENTITY(1,1) PRIMARY KEY,
    product_id VARCHAR(32) NOT NULL UNIQUE,
    product_category_name NVARCHAR(100) NOT NULL,
    product_category_english NVARCHAR(100) NOT NULL
);

CREATE TABLE dw.DimSeller (
    seller_key INT IDENTITY(1,1) PRIMARY KEY,
    seller_id VARCHAR(32) NOT NULL UNIQUE,
    seller_city NVARCHAR(100) NULL,
    seller_state VARCHAR(10) NULL,
    seller_zip_code_prefix INT NULL
);

CREATE TABLE dw.FactSales (
    sales_key BIGINT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    seller_key INT NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    freight_value DECIMAL(12,2) NOT NULL,
    item_count INT NOT NULL DEFAULT 1,

    CONSTRAINT UQ_FactSales_OrderItem
        UNIQUE (order_id, order_item_id),

    CONSTRAINT FK_FactSales_Date
        FOREIGN KEY (date_key) REFERENCES dw.DimDate(date_key),

    CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY (customer_key) REFERENCES dw.DimCustomer(customer_key),

    CONSTRAINT FK_FactSales_Product
        FOREIGN KEY (product_key) REFERENCES dw.DimProduct(product_key),

    CONSTRAINT FK_FactSales_Seller
        FOREIGN KEY (seller_key) REFERENCES dw.DimSeller(seller_key)
);
GO
USE OlistDW;
GO

SELECT SCHEMA_NAME(schema_id) AS schema_name, name AS table_name
FROM sys.tables
WHERE name LIKE '%Products%';
USE OlistDW;
GO

SELECT COUNT(*) AS imported_products
FROM dbo.stg_Products;
USE OlistDW;
GO

SELECT COUNT(*) AS imported_products
FROM dbo.stg_Sellers;

USE OlistDW;
GO

SELECT COUNT(*) AS imported_products
FROM dbo.stg_CategoryTranslation;

USE OlistDW;
GO

SELECT 'Orders' AS source_name, COUNT(*) AS row_count FROM dbo.stg_Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.stg_OrderItems
UNION ALL
SELECT 'Customers', COUNT(*) FROM dbo.stg_Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.stg_Products
UNION ALL
SELECT 'Sellers', COUNT(*) FROM dbo.stg_Sellers
UNION ALL
SELECT 'CategoryTranslation', COUNT(*) FROM dbo.stg_CategoryTranslation;

USE OlistDW;
GO

SELECT
    SCHEMA_NAME(schema_id) AS schema_name,
    name AS table_name
FROM sys.tables
WHERE name LIKE 'stg_%' OR name LIKE '%customer%'
ORDER BY name;

USE OlistDW;
GO

SELECT COUNT(*) AS imported_customers
FROM dbo.stg_Customers;

USE OlistDW;
GO

SELECT COUNT(*) AS imported_payments
FROM dbo.stg_Payments;
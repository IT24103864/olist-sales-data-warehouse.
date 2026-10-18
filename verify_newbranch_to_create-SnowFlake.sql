 USE OlistDW;
GO

IF OBJECT_ID('dw.DimCategory', 'U') IS NULL
BEGIN
    CREATE TABLE dw.DimCategory (
        category_key INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_DimCategory PRIMARY KEY,
        product_category_name NVARCHAR(255) NOT NULL
            CONSTRAINT UQ_DimCategory_Name UNIQUE,
        product_category_english NVARCHAR(255) NOT NULL
    );
END;
GO

INSERT INTO dw.DimCategory (
    product_category_name,
    product_category_english
)
SELECT
    p.product_category_name,
    MAX(p.product_category_english)
FROM dw.DimProduct AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.DimCategory AS c
    WHERE c.product_category_name = p.product_category_name
)
GROUP BY p.product_category_name;
GO

IF COL_LENGTH('dw.DimProduct', 'category_key') IS NULL
BEGIN
    ALTER TABLE dw.DimProduct
        ADD category_key INT NULL;
END;
GO

UPDATE p
SET p.category_key = c.category_key
FROM dw.DimProduct AS p
JOIN dw.DimCategory AS c
    ON c.product_category_name = p.product_category_name
WHERE p.category_key IS NULL;
GO

SELECT COUNT(*) AS products_without_category
FROM dw.DimProduct
WHERE category_key IS NULL;
GO
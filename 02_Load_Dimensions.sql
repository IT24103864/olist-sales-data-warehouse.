USE OlistDW;
GO

/* 1. Customer dimension */
INSERT INTO dw.DimCustomer (
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    customer_zip_code_prefix
)
SELECT
    LTRIM(RTRIM(c.customer_id)),
    LTRIM(RTRIM(c.customer_unique_id)),
    NULLIF(LTRIM(RTRIM(c.customer_city)), ''),
    NULLIF(UPPER(LTRIM(RTRIM(c.customer_state))), ''),
    TRY_CONVERT(INT, c.customer_zip_code_prefix)
FROM dbo.stg_Customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.DimCustomer AS d
    WHERE d.customer_id = c.customer_id
);


/* 2. Product dimension: handle missing categories and translations */
 INSERT INTO dw.DimProduct (
    product_id,
    product_category_name,
    product_category_english
)
SELECT
    LTRIM(RTRIM(p.product_id)),
    COALESCE(NULLIF(LTRIM(RTRIM(p.product_category_name)), ''), 'Unknown'),
    COALESCE(
        NULLIF(LTRIM(RTRIM(t.column2)), ''),
        NULLIF(LTRIM(RTRIM(p.product_category_name)), ''),
        'Unknown'
    )
FROM dbo.stg_Products AS p
LEFT JOIN dbo.stg_CategoryTranslation AS t
    ON p.product_category_name = t.column1
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.DimProduct AS d
    WHERE d.product_id = p.product_id
);


/* 3. Seller dimension */
INSERT INTO dw.DimSeller (
    seller_id,
    seller_city,
    seller_state,
    seller_zip_code_prefix
)
SELECT
    LTRIM(RTRIM(s.seller_id)),
    NULLIF(LTRIM(RTRIM(s.seller_city)), ''),
    NULLIF(UPPER(LTRIM(RTRIM(s.seller_state))), ''),
    TRY_CONVERT(INT, s.seller_zip_code_prefix)
FROM dbo.stg_Sellers AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.DimSeller AS d
    WHERE d.seller_id = s.seller_id
);


/* 4. Date dimension: one date for each distinct purchase day */
INSERT INTO dw.DimDate (
    date_key,
    full_date,
    [year],
    [quarter],
    month_number,
    month_name,
    [day]
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), dates.purchase_date, 112)),
    dates.purchase_date,
    YEAR(dates.purchase_date),
    DATEPART(QUARTER, dates.purchase_date),
    MONTH(dates.purchase_date),
    DATENAME(MONTH, dates.purchase_date),
    DAY(dates.purchase_date)
FROM (
    SELECT DISTINCT
        TRY_CONVERT(DATE, order_purchase_timestamp) AS purchase_date
    FROM dbo.stg_Orders
) AS dates
WHERE dates.purchase_date IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dw.DimDate AS d
      WHERE d.full_date = dates.purchase_date
  );
GO
USE OlistDW;
GO

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
GO
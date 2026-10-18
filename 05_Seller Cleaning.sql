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
GO
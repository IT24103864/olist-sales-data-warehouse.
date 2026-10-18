  USE OlistDW;
GO

INSERT INTO dw.DimProduct (
    product_id,
    product_category_name,
    product_category_english
)
SELECT
    LTRIM(RTRIM(p.product_id)),
    COALESCE(
        NULLIF(LTRIM(RTRIM(p.product_category_name)), ''),
        'Unknown'
    ),
    COALESCE(
        NULLIF(LTRIM(RTRIM(t.[Column2])), ''),
        NULLIF(LTRIM(RTRIM(p.product_category_name)), ''),
        'Unknown'
    )
FROM dbo.stg_Products AS p
LEFT JOIN dbo.stg_CategoryTranslation AS t
    ON LTRIM(RTRIM(p.product_category_name))
       = LTRIM(RTRIM(t.[Column1]))
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.DimProduct AS d
    WHERE d.product_id = LTRIM(RTRIM(p.product_id))
);
GO
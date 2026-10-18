USE OlistDW;
GO

SELECT 'DimCustomer' AS table_name, COUNT(*) AS row_count FROM dw.DimCustomer
UNION ALL
SELECT 'DimProduct', COUNT(*) FROM dw.DimProduct
UNION ALL
SELECT 'DimSeller', COUNT(*) FROM dw.DimSeller
UNION ALL
SELECT 'DimDate', COUNT(*) FROM dw.DimDate;


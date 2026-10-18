USE OlistDW;
GO

SELECT
    d.[year],
    d.[quarter],
    d.month_number,
    COUNT(DISTINCT f.order_id) AS delivered_orders,
    SUM(f.price) AS delivered_sales
FROM dw.FactSales AS f
JOIN dw.DimDate AS d
    ON d.date_key = f.date_key
WHERE f.order_status = 'delivered'
GROUP BY ROLLUP (
    d.[year],
    d.[quarter],
    d.month_number
)
HAVING GROUPING(d.[year]) = 0
ORDER BY d.[year], d.[quarter], d.month_number;
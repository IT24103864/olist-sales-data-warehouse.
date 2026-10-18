USE OlistDW;
GO

CREATE SCHEMA mart;
GO

CREATE VIEW mart.SalesAnalysis AS
SELECT
    f.sales_key,
    f.order_id,
    f.order_item_id,
    d.full_date AS purchase_date,
    d.[year] AS purchase_year,
    d.[quarter] AS purchase_quarter,
    d.month_number AS purchase_month_number,
    d.month_name AS purchase_month,
    c.customer_city,
    c.customer_state,
    p.product_id,
    p.product_category_english AS product_category,
    s.seller_city,
    s.seller_state,
    f.order_status,
    f.price,
    f.freight_value,
    f.item_count
FROM dw.FactSales AS f
INNER JOIN dw.DimDate AS d
    ON f.date_key = d.date_key
INNER JOIN dw.DimCustomer AS c
    ON f.customer_key = c.customer_key
INNER JOIN dw.DimProduct AS p
    ON f.product_key = p.product_key
INNER JOIN dw.DimSeller AS s
    ON f.seller_key = s.seller_key;
GO
 --Step 1 — Check that every item can connect
USE OlistDW;
GO

SELECT
    COUNT(*) AS source_items,
    COUNT(o.order_id) AS matched_orders,
    COUNT(c.customer_key) AS matched_customers,
    COUNT(p.product_key) AS matched_products,
    COUNT(s.seller_key) AS matched_sellers,
    COUNT(d.date_key) AS matched_dates
FROM dbo.stg_OrderItems AS i
LEFT JOIN dbo.stg_Orders AS o
    ON i.order_id = o.order_id
LEFT JOIN dw.DimCustomer AS c
    ON o.customer_id = c.customer_id
LEFT JOIN dw.DimProduct AS p
    ON i.product_id = p.product_id
LEFT JOIN dw.DimSeller AS s
    ON i.seller_id = s.seller_id
LEFT JOIN dw.DimDate AS d
    ON d.full_date = TRY_CONVERT(DATE, o.order_purchase_timestamp);

     
--Step 2 — Load the fact table

    USE OlistDW;
GO

INSERT INTO dw.FactSales (
    order_id,
    order_item_id,
    date_key,
    customer_key,
    product_key,
    seller_key,
    order_status,
    price,
    freight_value,
    item_count
)
SELECT
    i.order_id,
    TRY_CONVERT(INT, i.order_item_id),
    d.date_key,
    c.customer_key,
    p.product_key,
    s.seller_key,
    o.order_status,
    TRY_CONVERT(DECIMAL(12,2), i.price),
    TRY_CONVERT(DECIMAL(12,2), i.freight_value),
    1
FROM dbo.stg_OrderItems AS i
INNER JOIN dbo.stg_Orders AS o
    ON i.order_id = o.order_id
INNER JOIN dw.DimCustomer AS c
    ON o.customer_id = c.customer_id
INNER JOIN dw.DimProduct AS p
    ON i.product_id = p.product_id
INNER JOIN dw.DimSeller AS s
    ON i.seller_id = s.seller_id
INNER JOIN dw.DimDate AS d
    ON d.full_date = TRY_CONVERT(DATE, o.order_purchase_timestamp)
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.FactSales AS f
    WHERE f.order_id = i.order_id
      AND f.order_item_id = TRY_CONVERT(INT, i.order_item_id)
);
GO
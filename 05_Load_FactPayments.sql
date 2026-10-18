USE OlistDW;
GO

INSERT INTO dw.FactPayments (
    order_id,
    payment_sequential,
    date_key,
    customer_key,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    p.order_id,
    TRY_CONVERT(INT, p.payment_sequential),
    d.date_key,
    c.customer_key,
    LTRIM(RTRIM(p.payment_type)),
    TRY_CONVERT(INT, p.payment_installments),
    TRY_CONVERT(DECIMAL(12,2), p.payment_value)
FROM dbo.stg_Payments AS p
INNER JOIN dbo.stg_Orders AS o
    ON p.order_id = o.order_id
INNER JOIN dw.DimCustomer AS c
    ON o.customer_id = c.customer_id
INNER JOIN dw.DimDate AS d
    ON d.full_date = TRY_CONVERT(DATE, o.order_purchase_timestamp)
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.FactPayments AS f
    WHERE f.order_id = p.order_id
      AND f.payment_sequential = TRY_CONVERT(INT, p.payment_sequential)
);
GO
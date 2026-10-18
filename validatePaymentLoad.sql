USE OlistDW;
GO

SELECT
    COUNT(*) AS payment_rows,
    COUNT(DISTINCT order_id) AS orders_with_payments,
    SUM(payment_value) AS total_payment_value
FROM dw.FactPayments;

SELECT payment_type, COUNT(*) AS payment_rows
FROM dw.FactPayments
GROUP BY payment_type
ORDER BY payment_rows DESC;
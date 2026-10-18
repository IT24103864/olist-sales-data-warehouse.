INSERT INTO dw.DimDate (
    date_key,
    full_date,
    [year],
    [quarter],
    month_number,
    month_name,
    [day]
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), dates.purchase_date, 112)),
    dates.purchase_date,
    YEAR(dates.purchase_date),
    DATEPART(QUARTER, dates.purchase_date),
    MONTH(dates.purchase_date),
    DATENAME(MONTH, dates.purchase_date),
    DAY(dates.purchase_date)
FROM (
    SELECT DISTINCT
        TRY_CONVERT(DATE, order_purchase_timestamp) AS purchase_date
    FROM dbo.stg_Orders
) AS dates
WHERE dates.purchase_date IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dw.DimDate AS d
      WHERE d.full_date = dates.purchase_date
  );
GO
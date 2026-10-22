CREATE OR ALTER VIEW analytics.vw_RecognizedMonthlySales
AS
SELECT
    DATEFROMPARTS(
        YEAR(order_date), MONTH(order_date), 1
    ) AS sales_month_start,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(units_sold) AS units_sold,
    SUM(total_sales) AS total_sales,
    SUM(total_cost) AS total_cost,
    SUM(gross_profit) AS gross_profit
FROM analytics.vw_RecognizedOrderSummary
WHERE order_date IS NOT NULL
GROUP BY
    DATEFROMPARTS(
        YEAR(order_date), MONTH(order_date), 1
    );
GO
CREATE OR ALTER VIEW analytics.vw_RecognizedStorePerformance
AS
SELECT
    s.store_id,
    s.store_name,
    s.region,
    COUNT(DISTINCT r.order_id) AS order_count,
    COUNT(DISTINCT r.customer_id) AS unique_customers,
    SUM(r.quantity) AS units_sold,
    SUM(r.sales_amount) AS total_sales,
    SUM(r.gross_profit) AS gross_profit
FROM dbo.stores AS s
LEFT JOIN analytics.vw_RecognizedSales AS r
    ON s.store_id = r.store_id
GROUP BY
    s.store_id,
    s.store_name,
    s.region;
GO

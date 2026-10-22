CREATE OR ALTER VIEW analytics.vw_RecognizedProductPerformance
AS
SELECT
    product_id,
    product_name,
    category,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS units_sold,
    SUM(sales_amount) AS total_sales,
    SUM(product_cost) AS total_cost,
    SUM(gross_profit) AS gross_profit
FROM analytics.vw_RecognizedSales
GROUP BY
    product_id,
    product_name,
    category;
GO
CREATE OR ALTER VIEW analytics.vw_RecognizedOrderSummary
AS
SELECT
    order_id,
    customer_id,
    store_id,
    order_date,
    order_status,
    COUNT(DISTINCT order_item_id) AS order_line_count,
    SUM(quantity) AS units_sold,
    SUM(sales_amount) AS total_sales,
    SUM(product_cost) AS total_cost,
    SUM(gross_profit) AS gross_profit
FROM analytics.vw_RecognizedSales
GROUP BY
    order_id,
    customer_id,
    store_id,
    order_date,
    order_status;
GO
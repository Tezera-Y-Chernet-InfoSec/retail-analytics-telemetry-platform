CREATE OR ALTER VIEW analytics.vw_RecognizedSales
AS
SELECT *
FROM analytics.vw_SalesDetail
WHERE order_status IN ('Completed', 'Shipped');
GO
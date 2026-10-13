/* ============================================================
   FINAL ROW COUNT VALIDATION
   ============================================================ */

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM dbo.customers

UNION ALL

SELECT 'stores', COUNT(*)
FROM dbo.stores

UNION ALL

SELECT 'products', COUNT(*)
FROM dbo.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM dbo.orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM dbo.order_items

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM dbo.support_tickets

UNION ALL

SELECT 'telemetry_events', COUNT(*)
FROM dbo.telemetry_events;
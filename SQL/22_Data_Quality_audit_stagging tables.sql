
/* Retail Analytics & Telemetry Platform
   Data Quality Audit - Staging Tables
   Read-only: does not modify data
*/

SELECT 'stg.customers' AS TableName,
       'Missing customer_id' AS CheckName,
       COUNT_BIG(*) AS IssueCount
FROM stg.customers
WHERE NULLIF(LTRIM(RTRIM(customer_id)), '') IS NULL
UNION ALL
SELECT 'stg.customers', 'Invalid customer_id',
       COUNT_BIG(*)
FROM stg.customers
WHERE NULLIF(LTRIM(RTRIM(customer_id)), '') IS NOT NULL
  AND TRY_CONVERT(INT, TRIM(customer_id)) IS NULL
UNION ALL
SELECT 'stg.customers', 'Invalid signup_date',
       COUNT_BIG(*)
FROM stg.customers
WHERE NULLIF(TRIM(signup_date), '') IS NOT NULL
  AND TRY_CONVERT(DATE, TRIM(signup_date)) IS NULL
UNION ALL
SELECT 'stg.customers', 'Blank customer_name',
       COUNT_BIG(*)
FROM stg.customers
WHERE NULLIF(TRIM(customer_name), '') IS NULL
UNION ALL
SELECT 'stg.stores', 'Invalid store_id',
       COUNT_BIG(*)
FROM stg.stores
WHERE NULLIF(TRIM(store_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(store_id)) IS NULL
UNION ALL
SELECT 'stg.products', 'Invalid product_id',
       COUNT_BIG(*)
FROM stg.products
WHERE NULLIF(TRIM(product_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(product_id)) IS NULL
UNION ALL
SELECT 'stg.products', 'Invalid unit_cost',
       COUNT_BIG(*)
FROM stg.products
WHERE NULLIF(TRIM(unit_cost), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(unit_cost)) IS NULL
UNION ALL
SELECT 'stg.products', 'Invalid unit_price',
       COUNT_BIG(*)
FROM stg.products
WHERE NULLIF(TRIM(unit_price), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(unit_price)) IS NULL
UNION ALL
SELECT 'stg.orders', 'Invalid order_id',
       COUNT_BIG(*)
FROM stg.orders
WHERE NULLIF(TRIM(order_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(order_id)) IS NULL
UNION ALL
SELECT 'stg.orders', 'Invalid customer_id',
       COUNT_BIG(*)
FROM stg.orders
WHERE NULLIF(TRIM(customer_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(customer_id)) IS NULL
UNION ALL
SELECT 'stg.orders', 'Invalid store_id',
       COUNT_BIG(*)
FROM stg.orders
WHERE NULLIF(TRIM(store_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(store_id)) IS NULL
UNION ALL
SELECT 'stg.orders', 'Invalid order_date',
       COUNT_BIG(*)
FROM stg.orders
WHERE NULLIF(TRIM(order_date), '') IS NOT NULL
  AND TRY_CONVERT(DATETIME2, TRIM(order_date)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Invalid order_item_id',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(order_item_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(order_item_id)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Invalid order_id',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(order_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(order_id)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Invalid product_id',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(product_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(product_id)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Invalid quantity',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(quantity), '') IS NOT NULL
  AND TRY_CONVERT(INT, TRIM(quantity)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Nonpositive quantity',
       COUNT_BIG(*)
FROM stg.order_items
WHERE TRY_CONVERT(INT, TRIM(quantity)) <= 0
UNION ALL
SELECT 'stg.order_items', 'Invalid unit_price',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(unit_price), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(unit_price)) IS NULL
UNION ALL
SELECT 'stg.order_items', 'Invalid unit_cost',
       COUNT_BIG(*)
FROM stg.order_items
WHERE NULLIF(TRIM(unit_cost), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(unit_cost)) IS NULL
UNION ALL
SELECT 'stg.support_tickets', 'Invalid ticket_id',
       COUNT_BIG(*)
FROM stg.support_tickets
WHERE NULLIF(TRIM(ticket_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(ticket_id)) IS NULL
UNION ALL
SELECT 'stg.support_tickets', 'Invalid customer_id',
       COUNT_BIG(*)
FROM stg.support_tickets
WHERE NULLIF(TRIM(customer_id), '') IS NULL
   OR TRY_CONVERT(INT, TRIM(customer_id)) IS NULL
UNION ALL
SELECT 'stg.support_tickets', 'Invalid created_at',
       COUNT_BIG(*)
FROM stg.support_tickets
WHERE NULLIF(TRIM(created_at), '') IS NOT NULL
  AND TRY_CONVERT(DATETIME2, TRIM(created_at)) IS NULL
UNION ALL
SELECT 'stg.support_tickets', 'Invalid resolution_hours',
       COUNT_BIG(*)
FROM stg.support_tickets
WHERE NULLIF(TRIM(resolution_hours), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(resolution_hours)) IS NULL
UNION ALL
SELECT 'stg.support_tickets', 'Negative resolution_hours',
       COUNT_BIG(*)
FROM stg.support_tickets
WHERE TRY_CONVERT(DECIMAL(18,2),
                  TRIM(resolution_hours)) < 0
UNION ALL
SELECT 'stg.telemetry_events', 'Invalid event_id',
       COUNT_BIG(*)
FROM stg.telemetry_events
WHERE NULLIF(TRIM(event_id), '') IS NULL
   OR TRY_CONVERT(BIGINT, TRIM(event_id)) IS NULL
UNION ALL
SELECT 'stg.telemetry_events', 'Invalid timestamp',
       COUNT_BIG(*)
FROM stg.telemetry_events
WHERE NULLIF(TRIM([timestamp]), '') IS NOT NULL
  AND TRY_CONVERT(DATETIME2, TRIM([timestamp])) IS NULL
UNION ALL
SELECT 'stg.telemetry_events', 'Invalid latency_ms',
       COUNT_BIG(*)
FROM stg.telemetry_events
WHERE NULLIF(TRIM(latency_ms), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), TRIM(latency_ms)) IS NULL
UNION ALL
SELECT 'stg.telemetry_events', 'Negative latency_ms',
       COUNT_BIG(*)
FROM stg.telemetry_events
WHERE TRY_CONVERT(DECIMAL(18,2), TRIM(latency_ms)) < 0
ORDER BY TableName, CheckName;





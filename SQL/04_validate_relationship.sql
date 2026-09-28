/* =========================================================
   RETAIL ANALYTICS & TELEMETRY PLATFORM
   Staging Data - Referential Integrity Validation
   ========================================================= */

-- 1. Orders must reference an existing customer
SELECT o.order_id, o.customer_id
FROM stg.orders AS o
LEFT JOIN stg.customers AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 2. Order items must reference an existing order
SELECT oi.order_item_id, oi.order_id
FROM stg.order_items AS oi
LEFT JOIN stg.orders AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 3. Order items must reference an existing product
SELECT oi.order_item_id, oi.product_id
FROM stg.order_items AS oi
LEFT JOIN stg.products AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
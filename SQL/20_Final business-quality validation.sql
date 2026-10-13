--Final business-quality validation

--product price/cost

SELECT *
FROM dbo.products
WHERE unit_price < unit_cost
   OR unit_price < 0
   OR unit_cost < 0;

--Order quantities
SELECT *
FROM dbo.order_items
WHERE quantity <= 0;

--Negative latency
SELECT *
FROM dbo.telemetry_events
WHERE latency_ms < 0;

--Negative resolution time
SELECT *
FROM dbo.support_tickets
WHERE resolution_hours < 0;

--Duplicate primary keys
SELECT customer_id, COUNT(*)
FROM dbo.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*)
FROM dbo.products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*)
FROM dbo.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_item_id, COUNT(*)
FROM dbo.order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;
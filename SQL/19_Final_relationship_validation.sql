--Final relationship validation

--Orders → Customers

SELECT COUNT(*) AS orphan_orders
FROM dbo.orders o
LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Orders → Stores
SELECT COUNT(*) AS orphan_orders
FROM dbo.orders o
LEFT JOIN dbo.stores s
    ON o.store_id = s.store_id
WHERE s.store_id IS NULL;

--Order Items → Orders
SELECT COUNT(*) AS orphan_order_items
FROM dbo.order_items oi
LEFT JOIN dbo.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

--Order Items → Products
SELECT COUNT(*) AS orphan_order_items
FROM dbo.order_items oi
LEFT JOIN dbo.products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

--Tickets → Customers
SELECT COUNT(*) AS orphan_tickets
FROM dbo.support_tickets t
LEFT JOIN dbo.customers c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


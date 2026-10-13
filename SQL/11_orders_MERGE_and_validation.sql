--NOTE: orders must be loaded after customers and store

/* ============================================================
   ORDERS - MERGE
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(order_id), '')) AS order_id,
        TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) AS customer_id,
        TRY_CONVERT(INT, NULLIF(TRIM(store_id), '')) AS store_id,
        TRY_CONVERT(DATETIME2(0),
            NULLIF(TRIM(order_date), '')
        ) AS order_date,
        NULLIF(TRIM(order_status), '') AS order_status
    FROM stg.orders
),
DuplicateKeys AS
(
    SELECT order_id
    FROM Converted
    WHERE order_id IS NOT NULL
    GROUP BY order_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.order_id = d.order_id
    INNER JOIN dbo.customers cu
        ON c.customer_id = cu.customer_id
    INNER JOIN dbo.stores s
        ON c.store_id = s.store_id
    WHERE c.order_id IS NOT NULL
      AND c.customer_id IS NOT NULL
      AND c.store_id IS NOT NULL
      AND c.order_date IS NOT NULL
      AND c.order_status IS NOT NULL
      AND d.order_id IS NULL
)
MERGE dbo.orders AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.order_id = SOURCE.order_id

WHEN MATCHED AND
(
       TARGET.customer_id <> SOURCE.customer_id
    OR TARGET.store_id <> SOURCE.store_id
    OR ISNULL(TARGET.order_date, '19000101')
       <> ISNULL(SOURCE.order_date, '19000101')
    OR ISNULL(TARGET.order_status, '')
       <> ISNULL(SOURCE.order_status, '')
)
THEN UPDATE SET
    TARGET.customer_id = SOURCE.customer_id,
    TARGET.store_id = SOURCE.store_id,
    TARGET.order_date = SOURCE.order_date,
    TARGET.order_status = SOURCE.order_status

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    order_id,
    customer_id,
    store_id,
    order_date,
    order_status
)
VALUES
(
    SOURCE.order_id,
    SOURCE.customer_id,
    SOURCE.store_id,
    SOURCE.order_date,
    SOURCE.order_status
);

--validation
SELECT
    COUNT(*) AS total_orders,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM dbo.orders;


--Relationship validation:


SELECT COUNT(*) AS orphan_orders
FROM dbo.orders o
LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id
LEFT JOIN dbo.stores s
    ON o.store_id = s.store_id
WHERE c.customer_id IS NULL
   OR s.store_id IS NULL;
/* ============================================================
   ORDER ITEMS - MERGE
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(order_item_id), '')) AS order_item_id,
        TRY_CONVERT(INT, NULLIF(TRIM(order_id), '')) AS order_id,
        TRY_CONVERT(INT, NULLIF(TRIM(product_id), '')) AS product_id,
        TRY_CONVERT(INT, NULLIF(TRIM(quantity), '')) AS quantity,
        TRY_CONVERT(DECIMAL(18,2),
            NULLIF(TRIM(unit_price), '')
        ) AS unit_price,
        TRY_CONVERT(DECIMAL(18,2),
            NULLIF(TRIM(unit_cost), '')
        ) AS unit_cost
    FROM stg.order_Items
),
DuplicateKeys AS
(
    SELECT order_item_id
    FROM Converted
    WHERE order_item_id IS NOT NULL
    GROUP BY order_item_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.order_item_id = d.order_item_id
    INNER JOIN dbo.orders o
        ON c.order_id = o.order_id
    INNER JOIN dbo.products p
        ON c.product_id = p.product_id
    WHERE c.order_item_id IS NOT NULL
      AND c.order_id IS NOT NULL
      AND c.product_id IS NOT NULL
      AND c.quantity > 0
      AND c.unit_price >= 0
      AND c.unit_cost >= 0
      AND d.order_item_id IS NULL
)
MERGE dbo.order_items AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.order_item_id = SOURCE.order_item_id

WHEN MATCHED AND
(
       TARGET.order_id <> SOURCE.order_id
    OR TARGET.product_id <> SOURCE.product_id
    OR ISNULL(TARGET.quantity, 0) <> ISNULL(SOURCE.quantity, 0)
    OR ISNULL(TARGET.unit_price, 0) <> ISNULL(SOURCE.unit_price, 0)
    OR ISNULL(TARGET.unit_cost, 0) <> ISNULL(SOURCE.unit_cost, 0)
)
THEN UPDATE SET
    TARGET.order_id = SOURCE.order_id,
    TARGET.product_id = SOURCE.product_id,
    TARGET.quantity = SOURCE.quantity,
    TARGET.unit_price = SOURCE.unit_price,
    TARGET.unit_cost = SOURCE.unit_cost

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    unit_cost
)
VALUES
(
    SOURCE.order_item_id,
    SOURCE.order_id,
    SOURCE.product_id,
    SOURCE.quantity,
    SOURCE.unit_price,
    SOURCE.unit_cost
);

--validation
SELECT
    COUNT(*) AS order_item_count,
    SUM(quantity) AS total_units
FROM dbo.order_items;

--check orphan realtionship

SELECT COUNT(*) AS orphan_order_items
FROM dbo.order_items oi
LEFT JOIN dbo.orders o
    ON oi.order_id = o.order_id
LEFT JOIN dbo.products p
    ON oi.product_id = p.product_id
WHERE o.order_id IS NULL
   OR p.product_id IS NULL;

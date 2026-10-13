--NOTE: order_Item must be loaded after orders and products.

/* ============================================================
   ORDER ITEMS - DATA QUALITY
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
)
SELECT
    *,
    CASE
        WHEN order_item_id IS NULL
            THEN 'INVALID ORDER ITEM ID'

        WHEN order_id IS NULL
            THEN 'INVALID ORDER ID'

        WHEN product_id IS NULL
            THEN 'INVALID PRODUCT ID'

        WHEN quantity IS NULL OR quantity <= 0
            THEN 'INVALID QUANTITY'

        WHEN unit_price IS NULL OR unit_price < 0
            THEN 'INVALID UNIT PRICE'

        WHEN unit_cost IS NULL OR unit_cost < 0
            THEN 'INVALID UNIT COST'

        WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.orders o
            WHERE o.order_id = Converted.order_id
        )
            THEN 'ORDER DOES NOT EXIST'

        WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.products p
            WHERE p.product_id = Converted.product_id
        )
            THEN 'PRODUCT DOES NOT EXIST'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;

--duplicate check

SELECT
    TRIM(order_item_id) AS order_item_id,
    COUNT(*) AS duplicate_count
FROM stg.order_Items
GROUP BY TRIM(order_item_id)
HAVING COUNT(*) > 1;
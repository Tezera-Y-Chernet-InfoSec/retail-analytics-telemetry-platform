/* ============================================================
   PRODUCTS - MERGE
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(product_id), '')) AS product_id,
        NULLIF(TRIM(product_name), '') AS product_name,
        NULLIF(TRIM(category), '') AS category,
        TRY_CONVERT(DECIMAL(18,2),
            NULLIF(TRIM(unit_cost), '')
        ) AS unit_cost,
        TRY_CONVERT(DECIMAL(18,2),
            NULLIF(TRIM(unit_price), '')
        ) AS unit_price
    FROM stg.products
),
DuplicateKeys AS
(
    SELECT product_id
    FROM Converted
    WHERE product_id IS NOT NULL
    GROUP BY product_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.product_id = d.product_id
    WHERE c.product_id IS NOT NULL
      AND c.product_name IS NOT NULL
      AND c.category IS NOT NULL
      AND c.unit_cost IS NOT NULL
      AND c.unit_price IS NOT NULL
      AND c.unit_cost >= 0
      AND c.unit_price >= 0
      AND c.unit_price >= c.unit_cost
      AND d.product_id IS NULL
)
MERGE dbo.products AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.product_id = SOURCE.product_id

WHEN MATCHED AND
(
       ISNULL(TARGET.product_name, '') <> ISNULL(SOURCE.product_name, '')
    OR ISNULL(TARGET.category, '') <> ISNULL(SOURCE.category, '')
    OR ISNULL(TARGET.unit_cost, 0) <> ISNULL(SOURCE.unit_cost, 0)
    OR ISNULL(TARGET.unit_price, 0) <> ISNULL(SOURCE.unit_price, 0)
)
THEN UPDATE SET
    TARGET.product_name = SOURCE.product_name,
    TARGET.category = SOURCE.category,
    TARGET.unit_cost = SOURCE.unit_cost,
    TARGET.unit_price = SOURCE.unit_price

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    product_id,
    product_name,
    category,
    unit_cost,
    unit_price
)
VALUES
(
    SOURCE.product_id,
    SOURCE.product_name,
    SOURCE.category,
    SOURCE.unit_cost,
    SOURCE.unit_price
);


--validation
SELECT
    COUNT(*) AS product_count,
    SUM(unit_price - unit_cost) AS total_unit_margin
FROM dbo.products;

--check business quality issue
SELECT *
FROM dbo.products
WHERE unit_price < unit_cost;
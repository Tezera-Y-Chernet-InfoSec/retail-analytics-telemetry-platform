/* ============================================================
   PRODUCTS - DATA QUALITY
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
)
SELECT
    *,
    CASE
        WHEN product_id IS NULL
            THEN 'INVALID PRODUCT ID'

        WHEN product_name IS NULL
            THEN 'MISSING PRODUCT NAME'

        WHEN category IS NULL
            THEN 'MISSING CATEGORY'

        WHEN unit_cost IS NULL
            THEN 'INVALID UNIT COST'

        WHEN unit_price IS NULL
            THEN 'INVALID UNIT PRICE'

        WHEN unit_cost < 0
            THEN 'NEGATIVE UNIT COST'

        WHEN unit_price < 0
            THEN 'NEGATIVE UNIT PRICE'

        WHEN unit_price < unit_cost
            THEN 'PRICE BELOW COST'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;

--duplicate check

SELECT
    TRIM(product_id) AS product_id,
    COUNT(*) AS duplicate_count
FROM stg.products
GROUP BY TRIM(product_id)
HAVING COUNT(*) > 1;
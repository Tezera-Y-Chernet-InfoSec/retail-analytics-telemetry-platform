/* ============================================================
   ORDERS - DATA QUALITY
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
)
SELECT
    *,
    CASE
        WHEN order_id IS NULL
            THEN 'INVALID ORDER ID'

        WHEN customer_id IS NULL
            THEN 'INVALID CUSTOMER ID'

        WHEN store_id IS NULL
            THEN 'INVALID STORE ID'

        WHEN order_date IS NULL
            THEN 'INVALID ORDER DATE'

        WHEN order_status IS NULL
            THEN 'MISSING ORDER STATUS'

        WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.customers c
            WHERE c.customer_id = Converted.customer_id
        )
            THEN 'CUSTOMER DOES NOT EXIST'

        WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.stores s
            WHERE s.store_id = Converted.store_id
        )
            THEN 'STORE DOES NOT EXIST'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;

--duplicate orders

SELECT
    TRIM(order_id) AS order_id,
    COUNT(*) AS duplicate_count
FROM stg.orders
GROUP BY TRIM(order_id)
HAVING COUNT(*) > 1;


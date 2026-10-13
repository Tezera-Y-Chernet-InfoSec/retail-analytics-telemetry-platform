/* ============================================================
   CUSTOMERS - DATA CONVERSION / DATA QUALITY
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) AS customer_id,
        NULLIF(TRIM(customer_name), '') AS customer_name,
        NULLIF(TRIM(email), '') AS email,
        TRY_CONVERT(DATE, NULLIF(TRIM(signup_date), '')) AS signup_date
    FROM stg.customers
)
SELECT
    *,
    CASE
        WHEN customer_id IS NULL
            THEN 'INVALID CUSTOMER ID'

        WHEN customer_name IS NULL
            THEN 'MISSING CUSTOMER NAME'

        WHEN email IS NOT NULL
             AND email NOT LIKE '%_@_%._%'
            THEN 'INVALID EMAIL'

        WHEN signup_date IS NULL
             AND EXISTS
             (
                 SELECT 1
             )
            THEN 'INVALID SIGNUP DATE'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;

--Check duplicates

SELECT
    TRIM(customer_id) AS customer_id,
    COUNT(*) AS duplicate_count
FROM stg.customers
GROUP BY TRIM(customer_id)
HAVING COUNT(*) > 1;
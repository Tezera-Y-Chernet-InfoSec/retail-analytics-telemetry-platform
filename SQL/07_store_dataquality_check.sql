/* ============================================================
   STORES - DATA QUALITY
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(store_id), '')) AS store_id,
        NULLIF(TRIM(store_name), '') AS store_name,
        NULLIF(TRIM(region), '') AS region
    FROM stg.stores
)
SELECT
    *,
    CASE
        WHEN store_id IS NULL
            THEN 'INVALID STORE ID'
        WHEN store_name IS NULL
            THEN 'MISSING STORE NAME'
        WHEN region IS NULL
            THEN 'MISSING REGION'
        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;


--duplicate check

SELECT
    TRIM(store_id) AS store_id,
    COUNT(*) AS duplicate_count
FROM stg.stores
GROUP BY TRIM(store_id)
HAVING COUNT(*) > 1;
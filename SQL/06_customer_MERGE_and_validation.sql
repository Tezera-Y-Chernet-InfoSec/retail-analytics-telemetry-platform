/* ============================================================
   CUSTOMERS - MERGE
   ============================================================ */

;WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) AS customer_id,
        NULLIF(TRIM(customer_name), '') AS customer_name,
        NULLIF(TRIM(email), '') AS email,
        TRY_CONVERT(DATE, NULLIF(TRIM(signup_date), '')) AS signup_date
    FROM stg.customers
),
DuplicateKeys AS
(
    SELECT customer_id
    FROM Converted
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.customer_id = d.customer_id
    WHERE c.customer_id IS NOT NULL
      AND c.customer_name IS NOT NULL
      AND (c.email IS NULL OR c.email LIKE '%_@_%._%')
      AND c.signup_date IS NOT NULL
      AND d.customer_id IS NULL
)
MERGE dbo.customers AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.customer_id = SOURCE.customer_id

WHEN MATCHED AND
(
       ISNULL(TARGET.customer_name, '') <> ISNULL(SOURCE.customer_name, '')
    OR ISNULL(TARGET.email, '') <> ISNULL(SOURCE.email, '')
    OR ISNULL(TARGET.signup_date, '19000101')
       <> ISNULL(SOURCE.signup_date, '19000101')
)
THEN UPDATE SET
    TARGET.customer_name = SOURCE.customer_name,
    TARGET.email = SOURCE.email,
    TARGET.signup_date = SOURCE.signup_date

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    customer_id,
    customer_name,
    email,
    signup_date
)
VALUES
(
    SOURCE.customer_id,
    SOURCE.customer_name,
    SOURCE.email,
    SOURCE.signup_date
);


/* ============================================================
   CUSTOMERS - LOAD VALIDATION
   ============================================================ */

SELECT 'STAGING' AS layer, COUNT(*) AS row_count
FROM stg.customers

UNION ALL

SELECT 'MAIN', COUNT(*)
FROM dbo.customers;

--check invalid record
SELECT *
FROM stg.customers
WHERE TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) IS NULL
   OR NULLIF(TRIM(customer_name), '') IS NULL;

--check duplicate key
SELECT customer_id, COUNT(*) AS row_count
FROM dbo.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
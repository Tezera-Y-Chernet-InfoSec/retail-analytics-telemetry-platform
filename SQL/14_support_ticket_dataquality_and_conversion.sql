/* ============================================================
   SUPPORT TICKETS - DATA QUALITY
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(INT, NULLIF(TRIM(ticket_id), '')) AS ticket_id,
        TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) AS customer_id,
        TRY_CONVERT(DATETIME2(0),
            NULLIF(TRIM(created_at), '')
        ) AS created_at,
        NULLIF(TRIM(category), '') AS category,
        NULLIF(TRIM(priority), '') AS priority,
        NULLIF(TRIM(status), '') AS status,
        TRY_CONVERT(DECIMAL(10,2),
            NULLIF(TRIM(resolution_hours), '')
        ) AS resolution_hours
    FROM stg.support_tickets
)
SELECT
    *,
    CASE
        WHEN ticket_id IS NULL
            THEN 'INVALID TICKET ID'

        WHEN customer_id IS NULL
            THEN 'INVALID CUSTOMER ID'

        WHEN created_at IS NULL
            THEN 'INVALID CREATED DATE'

        WHEN category IS NULL
            THEN 'MISSING CATEGORY'

        WHEN priority IS NULL
            THEN 'MISSING PRIORITY'

        WHEN status IS NULL
            THEN 'MISSING STATUS'

        WHEN resolution_hours IS NULL
            THEN 'INVALID RESOLUTION HOURS'

        WHEN resolution_hours < 0
            THEN 'NEGATIVE RESOLUTION HOURS'

        WHEN NOT EXISTS
        (
            SELECT 1
            FROM dbo.customers c
            WHERE c.customer_id = Converted.customer_id
        )
            THEN 'CUSTOMER DOES NOT EXIST'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;


--duplicate check

SELECT
    TRIM(ticket_id) AS ticket_id,
    COUNT(*) AS duplicate_count
FROM stg.support_tickets
GROUP BY TRIM(ticket_id)
HAVING COUNT(*) > 1;
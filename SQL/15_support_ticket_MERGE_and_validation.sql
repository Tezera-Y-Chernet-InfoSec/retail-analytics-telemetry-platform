/* ============================================================
   SUPPORT TICKETS - MERGE
   ============================================================ */

;WITH Converted AS
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
),
DuplicateKeys AS
(
    SELECT ticket_id
    FROM Converted
    WHERE ticket_id IS NOT NULL
    GROUP BY ticket_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.ticket_id = d.ticket_id
    INNER JOIN dbo.customers cu
        ON c.customer_id = cu.customer_id
    WHERE c.ticket_id IS NOT NULL
      AND c.customer_id IS NOT NULL
      AND c.created_at IS NOT NULL
      AND c.category IS NOT NULL
      AND c.priority IS NOT NULL
      AND c.status IS NOT NULL
      AND c.resolution_hours >= 0
      AND d.ticket_id IS NULL
)
MERGE dbo.support_tickets AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.ticket_id = SOURCE.ticket_id

WHEN MATCHED AND
(
       TARGET.customer_id <> SOURCE.customer_id
    OR ISNULL(TARGET.created_at, '19000101')
       <> ISNULL(SOURCE.created_at, '19000101')
    OR ISNULL(TARGET.category, '') <> ISNULL(SOURCE.category, '')
    OR ISNULL(TARGET.priority, '') <> ISNULL(SOURCE.priority, '')
    OR ISNULL(TARGET.status, '') <> ISNULL(SOURCE.status, '')
    OR ISNULL(TARGET.resolution_hours, 0)
       <> ISNULL(SOURCE.resolution_hours, 0)
)
THEN UPDATE SET
    TARGET.customer_id = SOURCE.customer_id,
    TARGET.created_at = SOURCE.created_at,
    TARGET.category = SOURCE.category,
    TARGET.priority = SOURCE.priority,
    TARGET.status = SOURCE.status,
    TARGET.resolution_hours = SOURCE.resolution_hours

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    ticket_id,
    customer_id,
    created_at,
    category,
    priority,
    status,
    resolution_hours
)
VALUES
(
    SOURCE.ticket_id,
    SOURCE.customer_id,
    SOURCE.created_at,
    SOURCE.category,
    SOURCE.priority,
    SOURCE.status,
    SOURCE.resolution_hours
);


--validation

SELECT
    COUNT(*) AS ticket_count,
    AVG(resolution_hours) AS avg_resolution_hours,
    MAX(resolution_hours) AS max_resolution_hours
FROM dbo.support_tickets;

--customer relationship orphan check

SELECT COUNT(*) AS orphan_tickets
FROM dbo.support_tickets t
LEFT JOIN dbo.customers c
    ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
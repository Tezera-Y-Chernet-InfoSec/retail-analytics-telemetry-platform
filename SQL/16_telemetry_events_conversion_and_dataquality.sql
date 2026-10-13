/* ============================================================
   TELEMETRY EVENTS - DATA QUALITY
   ============================================================ */

WITH Converted AS
(
    SELECT
        TRY_CONVERT(BIGINT,
            NULLIF(TRIM(event_id), '')
        ) AS event_id,

        TRY_CONVERT(DATETIME2(3),
            NULLIF(TRIM([timestamp]), '')
        ) AS [timestamp],

        NULLIF(TRIM(service), '') AS service,

        NULLIF(TRIM(event_type), '') AS event_type,

        TRY_CONVERT(DECIMAL(18,2),
            NULLIF(TRIM(latency_ms), '')
        ) AS latency_ms

    FROM stg.telemetry_events
)
SELECT
    *,
    CASE
        WHEN event_id IS NULL
            THEN 'INVALID EVENT ID'

        WHEN [timestamp] IS NULL
            THEN 'INVALID TIMESTAMP'

        WHEN service IS NULL
            THEN 'MISSING SERVICE'

        WHEN event_type IS NULL
            THEN 'MISSING EVENT TYPE'

        WHEN latency_ms IS NULL
            THEN 'INVALID LATENCY'

        WHEN latency_ms < 0
            THEN 'NEGATIVE LATENCY'

        ELSE 'VALID'
    END AS data_quality_status
FROM Converted;

--duplicate check

SELECT
    TRIM(event_id) AS event_id,
    COUNT(*) AS duplicate_count
FROM stg.telemetry_events
GROUP BY TRIM(event_id)
HAVING COUNT(*) > 1;
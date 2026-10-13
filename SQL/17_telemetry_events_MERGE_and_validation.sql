/* ============================================================
   TELEMETRY EVENTS - MERGE
   ============================================================ */

;WITH Converted AS
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
),
DuplicateKeys AS
(
    SELECT event_id
    FROM Converted
    WHERE event_id IS NOT NULL
    GROUP BY event_id
    HAVING COUNT(*) > 1
),
ValidRows AS
(
    SELECT c.*
    FROM Converted c
    LEFT JOIN DuplicateKeys d
        ON c.event_id = d.event_id
    WHERE c.event_id IS NOT NULL
      AND c.[timestamp] IS NOT NULL
      AND c.service IS NOT NULL
      AND c.event_type IS NOT NULL
      AND c.latency_ms >= 0
      AND d.event_id IS NULL
)
MERGE dbo.telemetry_events AS TARGET
USING ValidRows AS SOURCE
    ON TARGET.event_id = SOURCE.event_id

WHEN MATCHED AND
(
       ISNULL(TARGET.[timestamp], '19000101')
       <> ISNULL(SOURCE.[timestamp], '19000101')
    OR ISNULL(TARGET.service, '')
       <> ISNULL(SOURCE.service, '')
    OR ISNULL(TARGET.event_type, '')
       <> ISNULL(SOURCE.event_type, '')
    OR ISNULL(TARGET.latency_ms, 0)
       <> ISNULL(SOURCE.latency_ms, 0)
)
THEN UPDATE SET
    TARGET.[timestamp] = SOURCE.[timestamp],
    TARGET.service = SOURCE.service,
    TARGET.event_type = SOURCE.event_type,
    TARGET.latency_ms = SOURCE.latency_ms

WHEN NOT MATCHED BY TARGET
THEN INSERT
(
    event_id,
    [timestamp],
    service,
    event_type,
    latency_ms
)
VALUES
(
    SOURCE.event_id,
    SOURCE.[timestamp],
    SOURCE.service,
    SOURCE.event_type,
    SOURCE.latency_ms
);

--validation

SELECT
    COUNT(*) AS event_count,
    MIN([timestamp]) AS first_event,
    MAX([timestamp]) AS last_event,
    AVG(latency_ms) AS average_latency_ms,
    MAX(latency_ms) AS max_latency_ms
FROM dbo.telemetry_events;


--check invalid business values
SELECT *
FROM dbo.telemetry_events
WHERE latency_ms < 0;
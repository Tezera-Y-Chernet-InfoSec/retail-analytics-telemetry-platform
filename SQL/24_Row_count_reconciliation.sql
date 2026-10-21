-- Row-count reconciliation

-- stagging rows=valid rows + Rejected rows


/* Retail Analytics & Telemetry Platform
   Step 1: Compare staging and main table row counts
   Read-only diagnostic query
*/

WITH RowCounts AS
(
    SELECT
        'Customers' AS EntityName,
        (SELECT COUNT_BIG(*) FROM stg.customers) AS StagingRows,
        (SELECT COUNT_BIG(*) FROM dbo.Customers) AS MainRows

    UNION ALL

    SELECT
        'Stores',
        (SELECT COUNT_BIG(*) FROM stg.stores),
        (SELECT COUNT_BIG(*) FROM dbo.Stores)

    UNION ALL

    SELECT
        'Products',
        (SELECT COUNT_BIG(*) FROM stg.products),
        (SELECT COUNT_BIG(*) FROM dbo.Products)

    UNION ALL

    SELECT
        'Orders',
        (SELECT COUNT_BIG(*) FROM stg.orders),
        (SELECT COUNT_BIG(*) FROM dbo.Orders)

    UNION ALL

    SELECT
        'Order Items',
        (SELECT COUNT_BIG(*) FROM stg.order_items),
        (SELECT COUNT_BIG(*) FROM dbo.Order_Items)

    UNION ALL

    SELECT
        'Support Tickets',
        (SELECT COUNT_BIG(*) FROM stg.support_tickets),
        (SELECT COUNT_BIG(*) FROM dbo.Support_Tickets)

    UNION ALL

    SELECT
        'Telemetry',
        (SELECT COUNT_BIG(*) FROM stg.telemetry_events),
        (SELECT COUNT_BIG(*) FROM dbo.telemetry_events)
)
SELECT
    EntityName,
    StagingRows,
    MainRows,
    StagingRows - MainRows AS RowCountDifference,
    CASE
        WHEN StagingRows = MainRows THEN 'COUNT MATCH'
        ELSE 'REVIEW'
    END AS ReconciliationStatus
FROM RowCounts
ORDER BY EntityName;


SELECT customer_id, COUNT(*) AS DuplicateCount
FROM dbo.Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
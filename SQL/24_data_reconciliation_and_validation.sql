
SELECT
    s.name AS SchemaName,
    v.name AS ViewName
FROM sys.views AS v
JOIN sys.schemas AS s
    ON v.schema_id = s.schema_id
WHERE s.name = 'analytics'
ORDER BY v.name;


SELECT TOP (20) *
FROM analytics.vw_SalesDetail;

SELECT TOP (20) *
FROM analytics.vw_RecognizedSales;



SELECT
    s.name AS SchemaName,
    p.name AS ProcedureName,
    p.create_date AS CreatedDate,
    p.modify_date AS ModifiedDate
FROM sys.procedures AS p
JOIN sys.schemas AS s
    ON p.schema_id = s.schema_id
WHERE p.name LIKE 'usp_Load_%'
ORDER BY p.name;



EXEC sys.sp_helptext
    'dbo.usp_Load_Customers';



SELECT
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
WHERE s.name = 'ETL'
ORDER BY t.name;



SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    c.column_id AS ColumnOrder,
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.columns AS c
    ON c.object_id = t.object_id
WHERE s.name = 'ETL'
ORDER BY t.name, c.column_id;




SELECT TOP (20) *
FROM ETL.ETL_Run_Log
ORDER BY ExecutionStartTime DESC;



SELECT TOP (50) *
FROM ETL.ETL_Task_Log
ORDER BY StartTime DESC;



SELECT
    COUNT(*) AS TotalRows,
    SUM(
        CASE
            WHEN TRY_CONVERT(
                INT, NULLIF(TRIM(quantity), '')
            ) IS NULL THEN 1
            ELSE 0
        END
    ) AS InvalidQuantityRows,
    SUM(
        CASE
            WHEN TRY_CONVERT(
                INT, NULLIF(TRIM(quantity), '')
            ) <= 0 THEN 1
            ELSE 0
        END
    ) AS NonpositiveQuantityRows
FROM stg.order_items;



SELECT 'customers' AS Entity,
       (SELECT COUNT_BIG(*) FROM stg.customers) AS StagingRows,
       (SELECT COUNT_BIG(*) FROM dbo.Customers) AS MainRows
UNION ALL
SELECT 'stores',
       (SELECT COUNT_BIG(*) FROM stg.stores),
       (SELECT COUNT_BIG(*) FROM dbo.Stores)
UNION ALL
SELECT 'products',
       (SELECT COUNT_BIG(*) FROM stg.products),
       (SELECT COUNT_BIG(*) FROM dbo.Products)
UNION ALL
SELECT 'orders',
       (SELECT COUNT_BIG(*) FROM stg.orders),
       (SELECT COUNT_BIG(*) FROM dbo.Orders)
UNION ALL
SELECT 'order_items',
       (SELECT COUNT_BIG(*) FROM stg.order_items),
       (SELECT COUNT_BIG(*) FROM dbo.Order_Items);


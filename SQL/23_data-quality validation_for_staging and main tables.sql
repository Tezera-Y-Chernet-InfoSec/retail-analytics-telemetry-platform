
SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    CASE WHEN pk.column_id IS NOT NULL THEN 'YES' ELSE 'NO' END AS IsPrimaryKey
FROM sys.tables AS t
JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
JOIN sys.columns AS c
    ON t.object_id = c.object_id
JOIN sys.types AS ty
    ON c.user_type_id = ty.user_type_id
LEFT JOIN (
    SELECT
        ic.object_id,
        ic.column_id
    FROM sys.indexes AS i
    JOIN sys.index_columns AS ic
        ON i.object_id = ic.object_id
       AND i.index_id = ic.index_id
    WHERE i.is_primary_key = 1
) AS pk
    ON c.object_id = pk.object_id
   AND c.column_id = pk.column_id
WHERE s.name IN ('stg', 'dbo')
  AND t.name IN (
      'customers',
      'stores',
      'products',
      'orders',
      'order_items',
      'support_tickets',
      'telemetry_events'
  )
ORDER BY
    s.name,
    t.name,
    c.column_id;

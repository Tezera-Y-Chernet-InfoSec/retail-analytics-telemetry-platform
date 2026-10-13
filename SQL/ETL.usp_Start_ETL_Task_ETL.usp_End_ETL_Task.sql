SELECT TOP (10)
    TaskLogID,
    RunID,
    PackageName,
    TaskName,
    StartTime,
    EndTime,
    Status,
    RowsProcessed,
    ErrorMessage
FROM ETL.ETL_Task_Log
ORDER BY TaskLogID DESC;
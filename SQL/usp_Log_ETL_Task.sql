CREATE PROCEDURE ETL.usp_Log_ETL_Task
    @RunID BIGINT,
    @PackageName NVARCHAR(200),
    @TaskName NVARCHAR(200),
    @StartTime DATETIME2(3),
    @EndTime DATETIME2(3) = NULL,
    @Status VARCHAR(20),
    @RowsProcessed INT = NULL,
    @ErrorMessage NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ETL.ETL_Task_Log
    (
        RunID,
        PackageName,
        TaskName,
        StartTime,
        EndTime,
        Status,
        RowsProcessed,
        ErrorMessage
    )
    VALUES
    (
        @RunID,
        @PackageName,
        @TaskName,
        @StartTime,
        @EndTime,
        @Status,
        @RowsProcessed,
        @ErrorMessage
    );
END;
GO


-- Updated


CREATE OR ALTER PROCEDURE ETL.usp_Start_ETL_Task
    @RunID BIGINT,
    @PackageName NVARCHAR(200),
    @TaskName NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ETL.ETL_Task_Log
    (
        RunID,
        PackageName,
        TaskName,
        StartTime,
        Status
    )
    VALUES
    (
        @RunID,
        @PackageName,
        @TaskName,
        SYSDATETIME(),
        'RUNNING'
    );

    SELECT CONVERT(BIGINT, SCOPE_IDENTITY()) AS TaskLogID;
END;
GO

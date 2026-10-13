CREATE PROCEDURE ETL.usp_Start_ETL_Run
    @PackageName NVARCHAR(200),
    @RunID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ETL.ETL_Run_Log
    (
        PackageName,
        ExecutionStartTime,
        Status
    )
    VALUES
    (
        @PackageName,
        SYSDATETIME(),
        'RUNNING'
    );

    SET @RunID = SCOPE_IDENTITY();
END;
GO


--EXEC usp_Start_ETL_Run


--EXEC usp_End_ETL_Run
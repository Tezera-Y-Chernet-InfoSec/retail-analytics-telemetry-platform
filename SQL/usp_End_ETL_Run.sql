CREATE PROCEDURE ETL.usp_End_ETL_Run
    @RunID BIGINT,
    @Status VARCHAR(20),
    @ErrorMessage NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ETL.ETL_Run_Log
    SET
        ExecutionEndTime = SYSDATETIME(),
        Status = @Status,
        ErrorMessage = @ErrorMessage
    WHERE RunID = @RunID;
END;
GO


EXEC [ETL].[usp_Start_ETL_Run]
     @PackageName = ?,
     @RunID = ? OUTPUT;


	 EXEC [ETL].[usp_Start_ETL_Run]

select * from [ETL].[usp_Start_ETL_Run]

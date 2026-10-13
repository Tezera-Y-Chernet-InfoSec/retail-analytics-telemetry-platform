CREATE SCHEMA ETL;
GO
--ETL logging tables
--This table answers: Did my ETL package run successfully?
CREATE TABLE ETL.ETL_Run_Log
(
    RunID              BIGINT IDENTITY(1,1) PRIMARY KEY,
    PackageName        NVARCHAR(200) NOT NULL,
    ExecutionStartTime DATETIME2(3) NOT NULL,
    ExecutionEndTime   DATETIME2(3) NULL,
    Status              VARCHAR(20) NOT NULL,
    ErrorMessage       NVARCHAR(MAX) NULL,
    CreatedDate        DATETIME2(3) NOT NULL
        DEFAULT SYSDATETIME()
);
GO

--task-level log
--did the overall package succeeded?

CREATE TABLE ETL.ETL_Task_Log
(
    TaskLogID           BIGINT IDENTITY(1,1) PRIMARY KEY,
    RunID               BIGINT NOT NULL,
    PackageName         NVARCHAR(200) NOT NULL,
    TaskName            NVARCHAR(200) NOT NULL,
    StartTime            DATETIME2(3) NOT NULL,
    EndTime             DATETIME2(3) NULL,
    Status               VARCHAR(20) NOT NULL,
    RowsProcessed       INT NULL,
    ErrorMessage        NVARCHAR(MAX) NULL,
    CreatedDate         DATETIME2(3) NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_ETL_Task_Log_Run
        FOREIGN KEY (RunID)
        REFERENCES ETL.ETL_Run_Log(RunID)
);
GO
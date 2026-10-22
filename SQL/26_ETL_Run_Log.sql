--ETL logging tables
--This table answers: Did my ETL package run successfully?
CREATE TABLE ETL_Run_Log
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

--create date table

CREATE TABLE dbo.dim_date
(
    date_key        INT           NOT NULL,
    full_date       DATE          NOT NULL,
    year            INT           NOT NULL,
    quarter         INT           NOT NULL,
    month_number    INT           NOT NULL,
    month_name      NVARCHAR(20)  NOT NULL,
    week_number     INT           NOT NULL,
    day_of_month    INT           NOT NULL,
    day_of_week     INT           NOT NULL,
    day_name        NVARCHAR(20)  NOT NULL,
    is_weekend      BIT           NOT NULL,

    CONSTRAINT PK_dim_date
        PRIMARY KEY (date_key),

    CONSTRAINT UQ_dim_date_full_date
        UNIQUE (full_date)
);

-- populate the date table

DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate   DATE = '2030-12-31';

;WITH DateSequence AS
(
    SELECT @StartDate AS full_date

    UNION ALL

    SELECT DATEADD(DAY, 1, full_date)
    FROM DateSequence
    WHERE full_date < @EndDate
)
INSERT INTO dbo.dim_date
(
    date_key,
    full_date,
    year,
    quarter,
    month_number,
    month_name,
    week_number,
    day_of_month,
    day_of_week,
    day_name,
    is_weekend
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), full_date, 112)) AS date_key,

    full_date,

    YEAR(full_date),

    DATEPART(QUARTER, full_date),

    MONTH(full_date),

    DATENAME(MONTH, full_date),

    DATEPART(WEEK, full_date),

    DAY(full_date),

    DATEPART(WEEKDAY, full_date),

    DATENAME(WEEKDAY, full_date),

    CASE
        WHEN DATEPART(WEEKDAY, full_date) IN (1, 7)
            THEN 1
        ELSE 0
    END
FROM DateSequence
OPTION (MAXRECURSION 0);

--check
select * from dim_date
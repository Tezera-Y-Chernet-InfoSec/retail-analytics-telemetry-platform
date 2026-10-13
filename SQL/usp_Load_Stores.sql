CREATE OR ALTER PROCEDURE dbo.usp_Load_Stores
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        /* ============================================================
           STORES - CONVERSION
           ============================================================ */

        ;WITH Converted AS
        (
            SELECT
                TRY_CONVERT(INT, NULLIF(TRIM(store_id), '')) AS store_id,
                NULLIF(TRIM(store_name), '') AS store_name,
                NULLIF(TRIM(region), '') AS region
            FROM stg.stores
        ),

        /* ============================================================
           STORES - DUPLICATE CHECK
           ============================================================ */

        DuplicateKeys AS
        (
            SELECT store_id
            FROM Converted
            WHERE store_id IS NOT NULL
            GROUP BY store_id
            HAVING COUNT(*) > 1
        ),

        /* ============================================================
           STORES - DATA VALIDATION
           ============================================================ */

        ValidRows AS
        (
            SELECT c.*
            FROM Converted c
            LEFT JOIN DuplicateKeys d
                ON c.store_id = d.store_id
            WHERE c.store_id IS NOT NULL
              AND c.store_name IS NOT NULL
              AND c.region IS NOT NULL
              AND d.store_id IS NULL
        )

        /* ============================================================
           STORES - MERGE
           ============================================================ */

        MERGE dbo.stores AS TARGET

        USING ValidRows AS SOURCE
            ON TARGET.store_id = SOURCE.store_id

        WHEN MATCHED AND
        (
               ISNULL(TARGET.store_name, '')
                    <> ISNULL(SOURCE.store_name, '')
            OR ISNULL(TARGET.region, '')
                    <> ISNULL(SOURCE.region, '')
        )

        THEN UPDATE SET
            TARGET.store_name = SOURCE.store_name,
            TARGET.region = SOURCE.region

        WHEN NOT MATCHED BY TARGET

        THEN INSERT
        (
            store_id,
            store_name,
            region
        )

        VALUES
        (
            SOURCE.store_id,
            SOURCE.store_name,
            SOURCE.region
        );

    END TRY

    BEGIN CATCH
        THROW;
    END CATCH;

END;
GO
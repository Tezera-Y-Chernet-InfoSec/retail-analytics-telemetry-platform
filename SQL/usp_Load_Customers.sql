CREATE OR ALTER PROCEDURE dbo.usp_Load_Customers
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        /* ============================================================
           CUSTOMERS - CONVERSION
           Convert staging VARCHAR values into proper data types
           ============================================================ */

        ;WITH Converted AS
        (
            SELECT
                TRY_CONVERT(INT, NULLIF(TRIM(customer_id), '')) AS customer_id,
                NULLIF(TRIM(customer_name), '') AS customer_name,
                NULLIF(TRIM(email), '') AS email,
                TRY_CONVERT(DATE, NULLIF(TRIM(signup_date), '')) AS signup_date
            FROM stg.customers
        ),

        /* ============================================================
           CUSTOMERS - DUPLICATE CHECK
           Find duplicate customer IDs in staging
           ============================================================ */

        DuplicateKeys AS
        (
            SELECT
                customer_id
            FROM Converted
            WHERE customer_id IS NOT NULL
            GROUP BY customer_id
            HAVING COUNT(*) > 1
        ),

        /* ============================================================
           CUSTOMERS - DATA VALIDATION
           Keep only rows that pass the business/data-quality rules
           ============================================================ */

        ValidRows AS
        (
            SELECT
                c.*
            FROM Converted c
            LEFT JOIN DuplicateKeys d
                ON c.customer_id = d.customer_id

            WHERE c.customer_id IS NOT NULL

              -- Customer name is required
              AND c.customer_name IS NOT NULL

              -- Email is optional, but if supplied it must have
              -- a basic email structure
              AND (
                    c.email IS NULL
                    OR c.email LIKE '%_@_%._%'
                  )

              -- Signup date is required
              AND c.signup_date IS NOT NULL

              -- Exclude duplicate customer IDs
              AND d.customer_id IS NULL
        )

        /* ============================================================
           CUSTOMERS - MERGE
           Insert new customers
           Update existing customers when values changed
           ============================================================ */

        MERGE dbo.customers AS TARGET

        USING ValidRows AS SOURCE
            ON TARGET.customer_id = SOURCE.customer_id

        /* ------------------------------------------------------------
           UPDATE existing customer
           Only update when something actually changed
           ------------------------------------------------------------ */

        WHEN MATCHED AND
        (
               ISNULL(TARGET.customer_name, '')
                    <> ISNULL(SOURCE.customer_name, '')

            OR ISNULL(TARGET.email, '')
                    <> ISNULL(SOURCE.email, '')

            OR ISNULL(TARGET.signup_date, '19000101')
                    <> ISNULL(SOURCE.signup_date, '19000101')
        )

        THEN UPDATE SET
            TARGET.customer_name = SOURCE.customer_name,
            TARGET.email = SOURCE.email,
            TARGET.signup_date = SOURCE.signup_date

        /* ------------------------------------------------------------
           INSERT new customer
           ------------------------------------------------------------ */

        WHEN NOT MATCHED BY TARGET

        THEN INSERT
        (
            customer_id,
            customer_name,
            email,
            signup_date
        )

        VALUES
        (
            SOURCE.customer_id,
            SOURCE.customer_name,
            SOURCE.email,
            SOURCE.signup_date
        );

    END TRY

    /* ================================================================
       ERROR HANDLING
       Pass SQL Server errors back to SSIS
       ================================================================ */

    BEGIN CATCH

        THROW;

    END CATCH;

END;
GO
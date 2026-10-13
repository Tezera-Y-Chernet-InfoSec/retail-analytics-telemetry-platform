/*
================================================================================
PROJECT: Retail Analytics & Telemetry Platform
FILE:    01_create_staging_tables.sql

PURPOSE
-------
Creates the raw staging layer used by the SSIS ETL pipeline.

ARCHITECTURE
------------
CSV Files
    ↓
SSIS
    ↓
STAGING TABLES
    ↓
Data Validation / Transformation
    ↓
DATA WAREHOUSE / FINAL TABLES
    ↓
SQL Analytics / Power BI / Telemetry Analysis

STAGING DESIGN PRINCIPLES
-------------------------
1. Staging tables are intentionally flexible.
2. Source data should be accepted with minimal modification.
3. Business relationships are NOT enforced in staging.
4. Primary keys and foreign keys are NOT enforced in staging.
5. Many source attributes are stored as NVARCHAR so SSIS can safely
   ingest values that require later datatype conversion.
6. Business rules and strict datatypes will be applied during the
   transformation / warehouse-loading stage.
7. This preserves the source layer for troubleshooting and auditing.

IMPORTANT
---------
The staging layer is NOT the final data warehouse.

The final warehouse tables will later contain:
    - Proper INT / BIGINT / DATE / DATETIME2 / DECIMAL datatypes
    - Primary keys
    - Foreign keys
    - Business rules
    - Cleaned and standardized values
    - Fact and dimension structures

================================================================================
*/

--CREATE DATABASE RetailAnalytics
--GO;

--USE RetailAnalytics
--GO;


/*
================================================================================
1. CREATE STAGING SCHEMA
================================================================================
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg');
END;
GO


/*
================================================================================
2. CUSTOMERS
--------------------------------------------------------------------------------
Source file:
    customers.csv

Future warehouse role:
    Customer Dimension

Important relationships that will be created later:
    customers.customer_id
          ↓
    orders.customer_id
          ↓
    order_items through orders
================================================================================
*/

IF OBJECT_ID('stg.customers', 'U') IS NOT NULL
    DROP TABLE stg.customers;
GO

CREATE TABLE stg.customers
(
    -- Source business identifier.
    -- Kept as text in staging so SSIS can ingest unexpected values.
    customer_id        NVARCHAR(100)  NULL,

    -- Large enough to tolerate whitespace and unexpected source values.
    customer_name      NVARCHAR(1000) NULL,

    -- Email stored as text because source validation will occur later.
    email              NVARCHAR(1000) NULL,

    -- Stored as text initially.
    -- SSIS / SQL transformation will later convert this to DATE/DATETIME2.
    signup_date        NVARCHAR(100)  NULL
);
GO


/*
================================================================================
3. PRODUCTS
--------------------------------------------------------------------------------
Source file:
    products.csv

Future warehouse role:
    Product Dimension

Relationships later:
    products.product_id
          ↓
    order_items.product_id
================================================================================
*/

IF OBJECT_ID('stg.products', 'U') IS NOT NULL
    DROP TABLE stg.products;
GO

CREATE TABLE stg.products
(
    product_id         NVARCHAR(100)  NULL,
    product_name       NVARCHAR(1000) NULL,
    category           NVARCHAR(500)  NULL,

    -- Stored as text initially to tolerate values such as:
    -- 19.99
    -- "19.99"
    -- blank
    -- values requiring conversion
    unit_cost          NVARCHAR(100)  NULL,
    unit_price         NVARCHAR(100)  NULL
);
GO


/*
================================================================================
4. STORES
--------------------------------------------------------------------------------
Source file:
    stores.csv

Future warehouse role:
    Store Dimension

Relationships later:
    stores.store_id
          ↓
    orders.store_id
================================================================================
*/

IF OBJECT_ID('stg.stores', 'U') IS NOT NULL
    DROP TABLE stg.stores;
GO

CREATE TABLE stg.stores
(
    store_id           NVARCHAR(100)  NULL,
    store_name         NVARCHAR(1000) NULL,
    region             NVARCHAR(500)  NULL
);
GO


/*
================================================================================
5. ORDERS
--------------------------------------------------------------------------------
Source file:
    orders.csv

Future warehouse role:
    Order Fact / Transaction Table

Relationships later:
    customers.customer_id
          ↓
    orders.customer_id

    stores.store_id
          ↓
    orders.store_id
================================================================================
*/

IF OBJECT_ID('stg.orders', 'U') IS NOT NULL
    DROP TABLE stg.orders;
GO

CREATE TABLE stg.orders
(
    order_id           NVARCHAR(100)  NULL,
    customer_id        NVARCHAR(100)  NULL,
    store_id           NVARCHAR(100)  NULL,

    -- Stored as text initially.
    -- Later converted to DATE/DATETIME2.
    order_date         NVARCHAR(100)  NULL,

    order_status       NVARCHAR(500)  NULL
);
GO


/*
================================================================================
6. ORDER ITEMS
--------------------------------------------------------------------------------
Source file:
    order_items.csv

Future warehouse role:
    Order Line / Sales Fact

Relationships later:
    orders.order_id
          ↓
    order_items.order_id

    products.product_id
          ↓
    order_items.product_id

This table will become one of the most important tables for:
    - Revenue
    - Cost
    - Profit
    - Margin
    - Product analysis
    - Category analysis
================================================================================
*/

IF OBJECT_ID('stg.order_items', 'U') IS NOT NULL
    DROP TABLE stg.order_items;
GO

CREATE TABLE stg.order_items
(
    order_item_id      NVARCHAR(100)  NULL,
    order_id           NVARCHAR(100)  NULL,
    product_id         NVARCHAR(100)  NULL,

    -- Stored as text intentionally.
    -- SSIS/SQL transformation will validate that quantity is numeric
    -- and greater than zero.
    quantity           NVARCHAR(100)  NULL,

    -- Stored as text for tolerant ingestion.
    unit_price         NVARCHAR(100)  NULL,
    unit_cost          NVARCHAR(100)  NULL
);
GO


/*
================================================================================
7. SUPPORT TICKETS
--------------------------------------------------------------------------------
Source file:
    support_tickets.csv

Future warehouse role:
    Support Ticket Fact

Potential analysis:
    - Ticket volume
    - Ticket category
    - Priority
    - Open vs closed
    - Resolution time
    - Customer support trends
================================================================================
*/

IF OBJECT_ID('stg.support_tickets', 'U') IS NOT NULL
    DROP TABLE stg.support_tickets;
GO

CREATE TABLE stg.support_tickets
(
    ticket_id          NVARCHAR(100)  NULL,
    customer_id        NVARCHAR(100)  NULL,

    -- Later converted to DATETIME2.
    created_at         NVARCHAR(100)  NULL,

    category           NVARCHAR(500)  NULL,
    priority           NVARCHAR(200)  NULL,
    status             NVARCHAR(200)  NULL,

    -- Later converted to DECIMAL.
    resolution_hours   NVARCHAR(100)  NULL
);
GO


/*
================================================================================
8. TELEMETRY EVENTS
--------------------------------------------------------------------------------
Source file:
    telemetry_events.csv

Future warehouse role:
    Telemetry / Operational Fact

This table is intentionally separated from retail transactions.

It will support:
    - Event volume analysis
    - Service analysis
    - Error/warning analysis
    - Latency analysis
    - Time-series analysis
    - KQL-style telemetry analysis
    - Power BI operational dashboards
================================================================================
*/

IF OBJECT_ID('stg.telemetry_events', 'U') IS NOT NULL
    DROP TABLE stg.telemetry_events;
GO

CREATE TABLE stg.telemetry_events
(
    event_id           NVARCHAR(100)  NULL,

    -- Later converted to DATETIME2.
    [timestamp]        NVARCHAR(100)  NULL,

    service            NVARCHAR(500)  NULL,
    event_type         NVARCHAR(200)  NULL,

    -- Later converted to DECIMAL/INT depending on warehouse design.
    latency_ms         NVARCHAR(100)  NULL
);
GO


/*
================================================================================
9. OPTIONAL ETL REJECT TABLE
--------------------------------------------------------------------------------
Purpose:
    Stores records that cannot pass validation during ETL.

Examples:
    - Invalid numeric value
    - Invalid date
    - Negative quantity
    - Missing required business key
    - Invalid foreign-key relationship
    - Invalid business rule

This is NOT a source table. It is an ETL operational table.
================================================================================
*/

IF OBJECT_ID('stg.etl_rejects', 'U') IS NOT NULL
    DROP TABLE stg.etl_rejects;
GO

CREATE TABLE stg.etl_rejects
(
    reject_id          BIGINT IDENTITY(1,1) NOT NULL,

    source_file        NVARCHAR(1000) NULL,
    source_table       NVARCHAR(500)  NULL,
    source_row_number  BIGINT         NULL,

    reject_reason      NVARCHAR(2000) NULL,
    source_data        NVARCHAR(MAX)  NULL,

    rejected_at        DATETIME2(3) NOT NULL
        CONSTRAINT DF_etl_rejects_rejected_at
        DEFAULT SYSUTCDATETIME()
);
GO


/*
================================================================================
10. OPTIONAL ETL LOAD AUDIT TABLE
--------------------------------------------------------------------------------
Tracks SSIS execution information.

This becomes useful when you later build:
    - For Each Loop
    - Variables
    - Execute SQL Tasks
    - File archive process
    - Error handling
================================================================================
*/

IF OBJECT_ID('stg.etl_load_audit', 'U') IS NOT NULL
    DROP TABLE stg.etl_load_audit;
GO

CREATE TABLE stg.etl_load_audit
(
    load_id            BIGINT IDENTITY(1,1) NOT NULL,

    source_file        NVARCHAR(1000) NULL,
    target_table       NVARCHAR(500)  NULL,

    load_start_time    DATETIME2(3)  NULL,
    load_end_time      DATETIME2(3)  NULL,

    rows_loaded        BIGINT        NULL,
    rows_rejected      BIGINT        NULL,

    load_status        NVARCHAR(50)  NULL,
    error_message      NVARCHAR(MAX) NULL
);
GO


/*
================================================================================
11. VERIFY STAGING TABLES
================================================================================
*/

SELECT
    SCHEMA_NAME(t.schema_id) AS schema_name,
    t.name AS table_name
FROM sys.tables t
WHERE SCHEMA_NAME(t.schema_id) = 'stg'
ORDER BY t.name;
GO
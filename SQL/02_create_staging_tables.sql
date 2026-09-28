/*
===============================================================================
PROJECT: Retail Analytics & Telemetry Platform
FILE:    02_create_staging_tables.sql

PURPOSE:
    Create staging tables used to ingest raw CSV files before loading
    the validated data into the final production/analytics tables.

DESIGN:
    - Staging tables intentionally use VARCHAR columns for most source fields.
    - This allows malformed values to be loaded and identified during
      data-quality validation instead of causing the ingestion process to fail.
    - No primary keys or foreign keys are applied to staging tables.
    - Data validation will occur after ingestion.

ETL FLOW:

    CSV
      |
      v
    STAGING
      |
      v
    VALIDATION
      |
      v
    CLEAN / TRANSFORM
      |
      v
    FINAL TABLES
      |
      v
    ANALYTICS / POWER BI

===============================================================================
*/

USE RetailAnalytics;
GO


/* ============================================================================
   1. CUSTOMER STAGING
   Source: customers.csv
   Grain: One row per customer
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_customers;
GO

CREATE TABLE dbo.stg_customers
(
    customer_id     VARCHAR(50)  NULL,
    customer_name   VARCHAR(150) NULL,
    segment         VARCHAR(50)  NULL,
    region          VARCHAR(50)  NULL,
    signup_date     VARCHAR(50)  NULL
);
GO


/* ============================================================================
   2. PRODUCT STAGING
   Source: products.csv
   Grain: One row per product
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_products;
GO

CREATE TABLE dbo.stg_products
(
    product_id      VARCHAR(50)  NULL,
    product_name    VARCHAR(150) NULL,
    category        VARCHAR(50)  NULL,
    unit_cost       VARCHAR(50)  NULL,
    list_price      VARCHAR(50)  NULL
);
GO


/* ============================================================================
   3. STORE STAGING
   Source: stores.csv
   Grain: One row per store
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_stores;
GO

CREATE TABLE dbo.stg_stores
(
    store_id        VARCHAR(50)  NULL,
    store_name      VARCHAR(100) NULL,
    region          VARCHAR(50)  NULL,
    city            VARCHAR(50)  NULL
);
GO


/* ============================================================================
   4. ORDER STAGING
   Source: orders.csv
   Grain: One row per order
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_orders;
GO

CREATE TABLE dbo.stg_orders
(
    order_id        VARCHAR(50) NULL,
    customer_id     VARCHAR(50) NULL,
    store_id        VARCHAR(50) NULL,
    order_date      VARCHAR(50) NULL,
    channel         VARCHAR(30) NULL,
    status          VARCHAR(30) NULL,
    payment_method  VARCHAR(30) NULL
);
GO


/* ============================================================================
   5. ORDER ITEM STAGING
   Source: order_items.csv
   Grain: One row per product line within an order
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_order_items;
GO

CREATE TABLE dbo.stg_order_items
(
    order_item_id   VARCHAR(50) NULL,
    order_id        VARCHAR(50) NULL,
    product_id      VARCHAR(50) NULL,
    quantity        VARCHAR(50) NULL,
    unit_cost       VARCHAR(50) NULL,
    list_price      VARCHAR(50) NULL,
    unit_price      VARCHAR(50) NULL,
    discount_pct    VARCHAR(50) NULL,
    net_sales       VARCHAR(50) NULL,
    cost            VARCHAR(50) NULL,
    gross_profit    VARCHAR(50) NULL
);
GO


/* ============================================================================
   6. SUPPORT TICKET STAGING
   Source: support_tickets.csv
   Grain: One row per support ticket
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_support_tickets;
GO

CREATE TABLE dbo.stg_support_tickets
(
    ticket_id         VARCHAR(50)  NULL,
    customer_id       VARCHAR(50)  NULL,
    created_at        VARCHAR(50)  NULL,
    priority          VARCHAR(20)  NULL,
    category          VARCHAR(50)  NULL,
    status            VARCHAR(30)  NULL,
    channel           VARCHAR(30)  NULL,
    resolution_hours  VARCHAR(50)  NULL
);
GO


/* ============================================================================
   7. TELEMETRY EVENT STAGING
   Source: telemetry_events.csv
   Grain: One row per telemetry event
   ============================================================================ */

DROP TABLE IF EXISTS dbo.stg_telemetry_events;
GO

CREATE TABLE dbo.stg_telemetry_events
(
    [timestamp]     VARCHAR(50)  NULL,
    service         VARCHAR(100) NULL,
    environment     VARCHAR(30)  NULL,
    event_type      VARCHAR(50)  NULL,
    status_code     VARCHAR(20)  NULL,
    region          VARCHAR(50)  NULL,
    duration_ms     VARCHAR(50)  NULL,
    customer_id     VARCHAR(50)  NULL,
    trace_id        VARCHAR(100) NULL,
    message         VARCHAR(500) NULL
);
GO


/*
===============================================================================
VALIDATION CHECK

Confirm that all seven staging tables were created.
===============================================================================
*/

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'stg_%'
ORDER BY TABLE_NAME;
GO
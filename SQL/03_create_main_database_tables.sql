/* ============================================================
   RETAIL ANALYTICS & TELEMETRY PORTFOLIO
   MAIN / DATA WAREHOUSE TABLES
   ============================================================ */

USE RetailAnalytics;
GO

/* ============================================================
   CREATE SCHEMA
   ============================================================ */

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'dbo'
)
BEGIN
    EXEC('CREATE SCHEMA dbo');
END
GO


/* ============================================================
   DROP EXISTING MAIN TABLES
   CHILD TABLES FIRST
   ============================================================ */

IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL
    DROP TABLE dbo.order_items;
GO

IF OBJECT_ID('dbo.support_tickets', 'U') IS NOT NULL
    DROP TABLE dbo.support_tickets;
GO

IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL
    DROP TABLE dbo.orders;
GO

IF OBJECT_ID('dbo.products', 'U') IS NOT NULL
    DROP TABLE dbo.products;
GO

IF OBJECT_ID('dbo.stores', 'U') IS NOT NULL
    DROP TABLE dbo.stores;
GO

IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL
    DROP TABLE dbo.customers;
GO

IF OBJECT_ID('dbo.telemetry_events', 'U') IS NOT NULL
    DROP TABLE dbo.telemetry_events;
GO

IF OBJECT_ID('dbo.data_dictionary', 'U') IS NOT NULL
    DROP TABLE dbo.data_dictionary;
GO


/* ============================================================
   1. CUSTOMERS
   ============================================================ */

CREATE TABLE dbo.customers
(
    customer_id     INT             NOT NULL,
    customer_name   NVARCHAR(500)   NULL,
    email           NVARCHAR(500)   NULL,
    signup_date     DATE            NULL,

    CONSTRAINT PK_customers
        PRIMARY KEY (customer_id)
);
GO


/* ============================================================
   2. STORES
   ============================================================ */

CREATE TABLE dbo.stores
(
    store_id        INT             NOT NULL,
    store_name      NVARCHAR(500)   NULL,
    region          NVARCHAR(500)   NULL,

    CONSTRAINT PK_stores
        PRIMARY KEY (store_id)
);
GO


/* ============================================================
   3. PRODUCTS
   ============================================================ */

CREATE TABLE dbo.products
(
    product_id      INT             NOT NULL,
    product_name    NVARCHAR(500)   NULL,
    category        NVARCHAR(500)   NULL,
    unit_cost       DECIMAL(18,2)   NULL,
    unit_price      DECIMAL(18,2)   NULL,

    CONSTRAINT PK_products
        PRIMARY KEY (product_id)
);
GO


/* ============================================================
   4. ORDERS
   ============================================================ */

CREATE TABLE dbo.orders
(
    order_id        INT             NOT NULL,
    customer_id     INT             NOT NULL,
    store_id        INT             NOT NULL,
    order_date      DATETIME2(0)    NULL,
    order_status    NVARCHAR(500)   NULL,

    CONSTRAINT PK_orders
        PRIMARY KEY (order_id),

    CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id),

    CONSTRAINT FK_orders_stores
        FOREIGN KEY (store_id)
        REFERENCES dbo.stores(store_id)
);
GO


/* ============================================================
   5. ORDER ITEMS
   ============================================================ */

CREATE TABLE dbo.order_items
(
    order_item_id   INT             NOT NULL,
    order_id        INT             NOT NULL,
    product_id      INT             NOT NULL,
    quantity        INT             NULL,
    unit_price      DECIMAL(18,2)   NULL,
    unit_cost       DECIMAL(18,2)   NULL,

    CONSTRAINT PK_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);
GO


/* ============================================================
   6. SUPPORT TICKETS
   ============================================================ */

CREATE TABLE dbo.support_tickets
(
    ticket_id          INT             NOT NULL,
    customer_id        INT             NOT NULL,
    created_at         DATETIME2(0)    NULL,
    category           NVARCHAR(500)   NULL,
    priority           NVARCHAR(500)   NULL,
    status             NVARCHAR(500)   NULL,
    resolution_hours   DECIMAL(10,2)   NULL,

    CONSTRAINT PK_support_tickets
        PRIMARY KEY (ticket_id),

    CONSTRAINT FK_support_tickets_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id)
);
GO


/* ============================================================
   7. TELEMETRY EVENTS
   ============================================================ */

CREATE TABLE dbo.telemetry_events
(
    event_id        BIGINT          NOT NULL,
    [timestamp]     DATETIME2(3)    NULL,
    service         NVARCHAR(500)   NULL,
    event_type      NVARCHAR(500)   NULL,
    latency_ms      DECIMAL(18,2)   NULL,

    CONSTRAINT PK_telemetry_events
        PRIMARY KEY (event_id)
);
GO


/* ============================================================
   8. DATA DICTIONARY
   Metadata table
   No business FK relationships
   ============================================================ */

CREATE TABLE dbo.data_dictionary
(
    table_name      NVARCHAR(500)   NULL,
    column_name     NVARCHAR(500)   NULL,
    description     NVARCHAR(1000)  NULL
);
GO


/* ============================================================
   INDEXES
   ============================================================ */

CREATE INDEX IX_orders_customer_id
ON dbo.orders(customer_id);
GO

CREATE INDEX IX_orders_store_id
ON dbo.orders(store_id);
GO

CREATE INDEX IX_order_items_order_id
ON dbo.order_items(order_id);
GO

CREATE INDEX IX_order_items_product_id
ON dbo.order_items(product_id);
GO

CREATE INDEX IX_support_tickets_customer_id
ON dbo.support_tickets(customer_id);
GO

CREATE INDEX IX_telemetry_timestamp
ON dbo.telemetry_events([timestamp]);
GO

CREATE INDEX IX_telemetry_service
ON dbo.telemetry_events(service);
GO
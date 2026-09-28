/*
create Database RetailAnalytics 
│
├── Create schema if needed - dbo in this case
│
├── Create final tables
│   ├── customers
│   ├── products
│   ├── stores
│   ├── orders
│   ├── order_items
│   ├── support_tickets
│   └── telemetry_events
│
├── Define columns and data types
│
├── Define primary keys
│
├── Define foreign keys
│
└── Define basic constraints

*/

USE RetailAnalytics;
GO

/* =========================================================
   RETAIL ANALYTICS & TELEMETRY PLATFORM
   Table Creation Script
   ========================================================= */


/* =========================================================
   1. CUSTOMERS
   Grain: One row per customer
   ========================================================= */

CREATE TABLE dbo.customers
(
    customer_id     INT           NOT NULL,
    customer_name   VARCHAR(100)  NOT NULL,
    segment         VARCHAR(50)   NOT NULL,
    region          VARCHAR(50)   NOT NULL,
    signup_date     DATE          NOT NULL,

    CONSTRAINT PK_customers
        PRIMARY KEY (customer_id)
);
GO


/* =========================================================
   2. PRODUCTS
   Grain: One row per product
   ========================================================= */

CREATE TABLE dbo.products
(
    product_id      INT            NOT NULL,
    product_name    VARCHAR(150)   NOT NULL,
    category        VARCHAR(50)    NOT NULL,
    unit_cost       DECIMAL(12,2)  NOT NULL,
    list_price      DECIMAL(12,2)  NOT NULL,

    CONSTRAINT PK_products
        PRIMARY KEY (product_id),

    CONSTRAINT CK_products_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT CK_products_list_price
        CHECK (list_price >= 0)
);
GO


/* =========================================================
   3. STORES
   Grain: One row per store
   ========================================================= */

CREATE TABLE dbo.stores
(
    store_id        INT           NOT NULL,
    store_name      VARCHAR(100)  NOT NULL,
    region          VARCHAR(50)   NOT NULL,
    city            VARCHAR(50)   NOT NULL,

    CONSTRAINT PK_stores
        PRIMARY KEY (store_id)
);
GO


/* =========================================================
   4. ORDERS
   Grain: One row per order
   ========================================================= */

CREATE TABLE dbo.orders
(
    order_id        INT           NOT NULL,
    customer_id     INT           NOT NULL,
    store_id        INT           NOT NULL,
    order_date      DATE          NOT NULL,
    channel         VARCHAR(30)   NOT NULL,
    status           VARCHAR(30)   NOT NULL,
    payment_method  VARCHAR(30)   NOT NULL,

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


/* =========================================================
   5. ORDER ITEMS
   Grain: One row per product line within an order
   ========================================================= */

CREATE TABLE dbo.order_items
(
    order_item_id   INT            NOT NULL,
    order_id        INT            NOT NULL,
    product_id      INT            NOT NULL,
    quantity        INT            NOT NULL,
    unit_cost       DECIMAL(12,2)  NOT NULL,
    list_price      DECIMAL(12,2)  NOT NULL,
    unit_price      DECIMAL(12,2)  NOT NULL,
    discount_pct    DECIMAL(5,2)   NOT NULL,
    net_sales       DECIMAL(12,2)  NOT NULL,
    cost            DECIMAL(12,2)  NOT NULL,
    gross_profit    DECIMAL(12,2)  NOT NULL,

    CONSTRAINT PK_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id),

    CONSTRAINT CK_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT CK_order_items_discount
        CHECK (discount_pct >= 0 AND discount_pct <= 1)
);
GO


/* =========================================================
   6. SUPPORT TICKETS
   Grain: One row per support ticket
   ========================================================= */

CREATE TABLE dbo.support_tickets
(
    ticket_id        INT            NOT NULL,
    customer_id      INT            NOT NULL,
    created_at       DATETIME2(0)   NOT NULL,
    priority         VARCHAR(20)    NOT NULL,
    category         VARCHAR(50)    NOT NULL,
    status           VARCHAR(30)    NOT NULL,
    channel          VARCHAR(30)    NOT NULL,
    resolution_hours DECIMAL(10,1)  NULL,

    CONSTRAINT PK_support_tickets
        PRIMARY KEY (ticket_id),

    CONSTRAINT FK_support_tickets_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id),

    CONSTRAINT CK_support_tickets_resolution
        CHECK (resolution_hours IS NULL OR resolution_hours >= 0)
);
GO


/* =========================================================
   7. TELEMETRY EVENTS
   Grain: One row per application telemetry event
   ========================================================= */

CREATE TABLE dbo.telemetry_events
(
    [timestamp]     DATETIME2(0)   NOT NULL,
    service         VARCHAR(100)   NOT NULL,
    environment     VARCHAR(20)    NOT NULL,
    event_type      VARCHAR(50)    NOT NULL,
    status_code     INT            NULL,
    region          VARCHAR(50)    NOT NULL,
    duration_ms     DECIMAL(12,1)  NULL,
    customer_id     INT            NULL,
    trace_id        VARCHAR(50)    NOT NULL,
    message         VARCHAR(500)   NULL
);
GO


/* =========================================================
   OPTIONAL INDEXES
   These will help common analytical queries.
   ========================================================= */

CREATE INDEX IX_orders_customer_id
ON dbo.orders(customer_id);
GO

CREATE INDEX IX_orders_store_id
ON dbo.orders(store_id);
GO

CREATE INDEX IX_orders_order_date
ON dbo.orders(order_date);
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

CREATE INDEX IX_telemetry_customer_id
ON dbo.telemetry_events(customer_id);
GO
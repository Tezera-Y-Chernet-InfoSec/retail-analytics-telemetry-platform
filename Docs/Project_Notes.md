</>

# Project Notes

# Day 1 � Database Setup and Data Ingestion

## Objective

Create the SQL Server foundation for the Retail Analytics & Telemetry
Platform and ingest the raw CSV datasets.

## Database

Database:
RetailAnalytics

Platform:
Microsoft SQL Server

## Tables Created

| Table            | Grain                       | Primary Key   |
| ---------------- | --------------------------- | ------------- |
| customers        | One row per customer        | customer_id   |
| products         | One row per product         | product_id    |
| stores           | One row per store           | store_id      |
| orders           | One row per order           | order_id      |
| order_items      | One row per order line      | order_item_id |
| support_tickets  | One row per support ticket  | ticket_id     |
| telemetry_events | One row per telemetry event | None          |

## Relationships

customers - orders
customers - support_tickets
stores - orders
orders - order_items
products - order_items

## Data Ingestion

CSV files were loaded into SQL Server after the target
tables and relationships were created.

Load order:

1. customers
2. products
3. stores
4. orders
5. order_items
6. support_tickets
7. telemetry_events

## Data Validation

Validated:

- Row counts
- Primary key structure
- Foreign key relationships
- NULL values
- Data types
- Numeric ranges

## Initial Findings

The dataset contains approximately:

- 2,000 customers
- 100 products
- 12 stores
- 30,000 orders
- 68,649 order items
- 5,000 support tickets
- 100,000 telemetry events

## Next Step

Begin SQL exploratory analysis using:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- COUNT
- SUM
- AVG
- JOIN

</>

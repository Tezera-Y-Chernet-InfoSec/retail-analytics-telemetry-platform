# Database Schema

## Objective

Create the SQL Server database structure required for the Retail
Analytics & Telemetry Platform.

The schema separates source data staging from the final relational
tables used for analytics and reporting.

## Database Structure

The final database contains the following core tables:

- customers
- products
- stores
- orders
- order_items
- support_tickets
- telemetry_events

## Table Relationships

customers
    │
    └──< orders
            │
            └──< order_items >── products

stores
    │
    └──< orders

customers
    │
    └──< support_tickets

telemetry_events
    └── Independent event-level telemetry data

## Table Purpose

| Table | Purpose | Grain |
|---|---|---|
| customers | Customer information | One row per customer |
| products | Product information | One row per product |
| stores | Store information | One row per store |
| orders | Order header information | One row per order |
| order_items | Products purchased in each order | One row per order item |
| support_tickets | Customer support activity | One row per ticket |
| telemetry_events | Application/service telemetry | One row per event |

## Primary Keys

Primary keys uniquely identify records in the final tables.

- customers → customer_id
- products → product_id
- stores → store_id
- orders → order_id
- order_items → order_item_id
- support_tickets → ticket_id

Telemetry events do not use timestamp as a primary key because
multiple events can occur at the same timestamp.

## Foreign Keys

The schema enforces relationships between related tables:

- orders.customer_id → customers.customer_id
- orders.store_id → stores.store_id
- order_items.order_id → orders.order_id
- order_items.product_id → products.product_id
- support_tickets.customer_id → customers.customer_id

## Data Integrity

The final schema uses primary keys and foreign keys to maintain
referential integrity.

Additional validation is performed on the staging tables before
data is loaded into the final tables.

## Data Flow

CSV Files
    ↓
SSIS Packages
    ↓
Staging Tables
    ↓
Data Validation
    ↓
Final SQL Schema
    ↓
Power BI / Analytics
# ETL Architecture — Retail Analytics & Telemetry Platform

## 1. Purpose

This document describes the current architecture of the Retail Analytics & Telemetry Platform, a portfolio project using SQL Server Integration Services (SSIS) and SQL Server to ingest CSV data, validate and transform records, and load main tables for downstream analytics.

It distinguishes implemented ETL components from planned analytics and operational testing so the documentation remains accurate.

## 2. High-level architecture

```text
CSV SOURCE FILES
(customers, stores, products, orders, order_items,
 support_tickets, telemetry_events)
             |
             v
+--------------------------------------+
| MASTER_ETL_PACKAGE                   |
| Top-level orchestration              |
| Run-level ETL logging                |
| Success/failure precedence paths     |
+--------------------------------------+
             |
             v
+--------------------------------------+
| Load_Staging.dtsx                    |
| Flat File Sources / Data Flow Tasks  |
| CSV ingestion and destination maps   |
+--------------------------------------+
             |
             v
+--------------------------------------+
| STAGING LAYER                        |
| stg.customers                        |
| stg.stores                           |
| stg.products                         |
| stg.orders                           |
| stg.order_items                      |
| stg.support_tickets                  |
| stg.telemetry_events                 |
+--------------------------------------+
             |
             v
+--------------------------------------+
| EPT_Load_main.dtsx                   |
| Execute SQL Tasks                    |
| Calls main-load stored procedures    |
+--------------------------------------+
             |
             v
+--------------------------------------+
| SQL TRANSFORMATION / LOAD            |
| Conversion and normalization         |
| Duplicate-key checks                 |
| Data validation                     |
| MERGE: insert / update / no change   |
+--------------------------------------+
             |
             v
+--------------------------------------+
| MAIN SQL SERVER TABLES               |
| Retail and telemetry datasets        |
+--------------------------------------+
             |
             v
+--------------------------------------+
| ANALYTICS LAYER — PLANNED            |
| Analytical SQL queries and views     |
| Power BI model and dashboard         |
+--------------------------------------+

CROSS-CUTTING CONTROLS
- ETL run/task logging
- Data-quality validation
- Row-count reconciliation
- Success/failure paths and operational testing
```

## 3. Source layer

CSV files provide seven datasets:

- Customers
- Stores
- Products
- Orders
- Order Items
- Support Tickets
- Telemetry Events

File paths and source formats are configured in the SSIS project and should be adapted to the environment where the project is run.

## 4. Orchestration layer

### `MASTER_ETL_PACKAGE`

The master package coordinates the overall workflow. It invokes the staging package and then the main-load package according to the configured precedence constraints. Run-level logging records the overall execution status.

### `Load_Staging.dtsx`

This package reads CSV files and loads records into the staging schema using SSIS Data Flow Tasks. The exact Flat File Source, conversion, derived-column, and destination components should be described according to the current package implementation.

### `EPT_Load_main.dtsx`

This package contains Execute SQL Tasks that call the main-load stored procedures. It separates main-table loading logic from the CSV ingestion package.

## 5. Staging layer

The `stg` schema provides an intermediate landing area for incoming data:

- `stg.customers`
- `stg.stores`
- `stg.products`
- `stg.orders`
- `stg.order_items`
- `stg.support_tickets`
- `stg.telemetry_events`

Staging allows source ingestion and main-table processing to be managed as separate phases. Confirm the current table definitions and reload/archive behavior from the actual implementation before documenting them as guaranteed behaviors.

## 6. Transformation and main-table load

The main-load stored procedures implement SQL-based processing. The design uses conversion and normalization, duplicate-key detection, validation, and `MERGE` operations to maintain the main tables.

Expected `MERGE` behavior:

- Insert records that do not already exist.
- Update records when tracked values have changed.
- Leave unchanged records untouched.

The precise matching keys, columns updated, rejected-record behavior, and transaction strategy are defined by the stored procedures and should be verified against the current SQL scripts.

## 7. ETL observability

The project includes ETL run/task logging and data reconciliation controls.

- **Run logging** records overall package execution status.
- **Task logging** records task-level outcomes where configured.
- **Data-quality validation** checks applicable rules before records are accepted into the main tables.
- **Row-count reconciliation** compares expected and observed counts across relevant pipeline stages.

Counts do not always need to match exactly if records are deliberately rejected, deduplicated, or excluded. Reconciliation rules should document the expected relationship and explain exceptions.

## 8. Error handling and testing status

The master package contains success/failure paths. A complete operational test should deliberately trigger controlled failures and confirm that:

1. The run/task status is correct.
2. The error message is captured.
3. Downstream tasks do not incorrectly run after a failure.
4. The success path is not recorded for a failed run.
5. A subsequent valid run can complete successfully.

Treat these as test criteria until each scenario has been executed and its results recorded.

## 9. Analytics layer

Analytical SQL queries/views and the Power BI model/dashboard are downstream deliverables. The main tables are the source for this layer.

A fact/dimension or star-schema design should be documented only after those tables and relationships are actually created and validated.

## 10. Deployment considerations

Before running the project in a new environment:

- Create the required database objects in dependency order.
- Configure SQL Server connections and CSV paths.
- Confirm SSIS runtime and Visual Studio extension compatibility.
- Verify the input files and column formats.
- Run the master package and inspect logs, validation outputs, and reconciliation results.


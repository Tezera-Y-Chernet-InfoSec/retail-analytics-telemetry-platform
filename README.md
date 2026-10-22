# Retail Analytics & Telemetry Platform

An end-to-end analytics platform built with **SQL Server, SSIS, Power BI, and Azure Data Explorer (Kusto)** to automate retail data integration, ensure data quality, deliver business intelligence, and analyze operational telemetry.

## Key Features & Implementation

- **ETL Pipeline & Orchestration:** Built SSIS workflows to ingest CSV data into SQL Server staging and main tables, orchestrate package execution, and deploy solutions to the SSISDB Catalog.
- **Automated Scheduling:** Configured SQL Server Agent jobs with recurring, time-based schedules to automate data pipeline execution.
- **Data Quality & Reconciliation:** Implemented data validation, quality checks, error logging, and source-to-target row-count reconciliation to improve data reliability and traceability.
- **Dimensional Modeling & BI:** Developed a Power BI semantic model using a star schema and defined table relationships to support interactive reporting and analysis.
- **DAX Measures & Dashboards:** Created business KPIs for Total Sales, Units Sold, Total Orders, and Profit Margin %, with interactive slicers for exploring performance across relevant dimensions.
- **Data Access Security:** Implemented Power BI Row-Level Security (RLS) to restrict report data according to user access rules.
- **Telemetry & Operational Analytics:** Ingested telemetry, store, and support-ticket data into Azure Data Explorer and used KQL to investigate operational patterns and derive insights.

## Technology Stack

**Data Engineering:** SQL Server, T-SQL, SSIS, SSISDB, SQL Server Agent  
**Business Intelligence:** Power BI, DAX, Semantic Modeling, Star Schema, Row-Level Security  
**Telemetry Analytics:** Azure Data Explorer (Kusto), KQL

## Business Value

Demonstrates an end-to-end approach to building reliable, automated data pipelines and transforming retail and operational data into analytical models and actionable insights. The platform combines data quality controls, business KPI reporting, access security, and telemetry analysis to support data-driven decision-making.

## Architectural Overview

The platform follows an end-to-end data integration and analytics architecture, connecting source data ingestion, ETL processing, data quality controls, business intelligence, and operational telemetry analysis.

### Data Flow

1. **Source Data:** Retail CSV files containing customer, order, and sales data serve as inputs to the data integration pipeline.
2. **ETL & Orchestration:** SQL Server Integration Services (SSIS) packages extract and load source data into staging tables, then process and transform data into main tables. Execute Package Tasks coordinate package execution.
3. **Data Quality & Audit Logging:** SQL validation procedures and data quality checks support data integrity, error logging, and source-to-target row-count reconciliation.
4. **Deployment & Scheduling:** SSIS packages are deployed to the SSISDB Catalog and automated through scheduled SQL Server Agent jobs.
5. **Data Modeling & Business Intelligence:** Power BI connects to the prepared SQL Server data, uses a star-schema semantic model, and provides DAX measures, interactive dashboards, slicers, and Row-Level Security (RLS).
6. **Telemetry Analytics:** Telemetry, store, and support-ticket data are ingested into Azure Data Explorer (Kusto) and queried with KQL to investigate operational patterns and derive insights.

### Architecture at a Glance

**Retail CSV Sources**  
↓  
**SSIS ETL & Package Orchestration**  
↓  
**SQL Server Staging Tables**  
↓  
**Validation, Error Logging & Reconciliation**  
↓  
**SQL Server Main Tables**  
↓  
**Power BI Semantic Model & DAX Measures**  
↓  
**Interactive Dashboards with Row-Level Security (RLS)**

**Operational Analytics Path:** Telemetry, store, and support-ticket data → Azure Data Explorer (Kusto) → KQL queries → Operational insights.

### Architecture Goals

- Automate repeatable data ingestion and package execution.
- Improve data reliability through validation, error handling, and reconciliation.
- Separate data preparation from reporting and analysis.
- Deliver interactive business KPIs through Power BI.
- Apply role-based data access through Power BI RLS.
- Analyze operational telemetry independently using Kusto and KQL.

## SQL Database Objects & ETL Inventory

This section documents the database objects supporting retail data ingestion, transformation, validation, reconciliation, and analytical reporting.

### 1. Database Tables

#### Staging Tables

The `stg` schema holds source records loaded from CSV files before downstream processing.

| Table                  | Purpose                        |
| ---------------------- | ------------------------------ |
| `stg.customers`        | Stage customer records         |
| `stg.stores`           | Stage store information        |
| `stg.products`         | Stage product records          |
| `stg.orders`           | Stage order headers            |
| `stg.order_Items`      | Stage order line items         |
| `stg.support_tickets`  | Stage customer support tickets |
| `stg.telemetry_events` | Stage telemetry event records  |

#### Main Tables

The main tables store records processed by the ETL pipeline for downstream reporting and analysis.

| Table                  | Purpose                               |
| ---------------------- | ------------------------------------- |
| `dbo.customers`        | Customer information                  |
| `dbo.stores`           | Store information                     |
| `dbo.products`         | Product information                   |
| `dbo.orders`           | Order headers and transaction details |
| `dbo.order_items`      | Individual order line items           |
| `dbo.support_tickets`  | Customer support records              |
| `dbo.telemetry_events` | Telemetry event records               |

### 2. Stored Procedures

The project uses reusable T-SQL stored procedures to process staging data and load main tables using validation and MERGE-based logic.

| Stored Procedure          | Responsibility                          |
| ------------------------- | --------------------------------------- |
| `usp_Load_Customers`      | Process and load customer records       |
| `usp_Load_Stores`         | Process and load store records          |
| `usp_Load_Products`       | Process and load product records        |
| `usp_Load_Orders`         | Process and load order records          |
| `usp_Load_OrderItems`     | Process and load order line items       |
| `usp_Load_SupportTickets` | Process and load support ticket records |
| `usp_Load_Telemetry`      | Process and load telemetry records      |

### 3. SQL Views — Business Analytics

Analytical views provide reusable query logic for reporting and business analysis.

| View                                        | Purpose                                                   |
| ------------------------------------------- | --------------------------------------------------------- |
| `analytics.vw_SalesDetail`                  | Detailed sales data across all order statuses             |
| `analytics.vw_RecognizedSales`              | Filters to completed and shipped orders                   |
| `analytics.vw_RecognizedOrderSummary`       | Aggregates sales, costs, units, and profit by order       |
| `analytics.vw_RecognizedMonthlySales`       | Summarizes monthly sales and order trends                 |
| `analytics.vw_RecognizedProductPerformance` | Analyzes sales and profitability by product and category  |
| `analytics.vw_RecognizedStorePerformance`   | Analyzes sales, orders, and customers by store and region |

**Key capabilities:** Business-rule-based sales recognition, reusable SQL aggregations, monthly trend analysis, and product/store performance reporting.

### 4. Star Schema & Dimensional Modeling

Designed a star-schema data model for Power BI to support business KPI reporting, analytical queries, and interactive dashboards.

**Fact Tables**

- `FactSales` — Sales transactions, quantities, costs, and profit measures.

**Dimension Tables**

- `DimDate` — Calendar attributes for time-based analysis.
- `DimCustomer` — Customer attributes.
- `DimProduct` — Product and category attributes.
- `DimStore` — Store and regional attributes.

**Modeling Features**

- Fact-to-dimension relationships for multidimensional analysis.
- DAX measures for Total Sales, Units Sold, Total Orders, and Profit Margin %.
- Row-Level Security (RLS) for controlled report access.

### 5. Relationship Design for the Star Schema

Designed a Power BI star schema to support efficient, consistent business reporting.

- **Cardinality:** One-to-many (1:\*)
- **Cross-filter direction:** Single
- **Relationship pattern:** Dimension tables filter the central fact table.
- **Business KPIs:** Total Sales, Units Sold, Total Orders, and Profit Margin %.
- **Security:** Row-Level Security (RLS) to control report data access.

This relationship design supports predictable filter propagation from dimensions to fact data and helps reduce ambiguity in the semantic model.

### 6. ETL Audit, Logging & Reconciliation

The ETL workflow includes logging and monitoring to support execution traceability and troubleshooting.

| Component                | Purpose                                                              |
| ------------------------ | -------------------------------------------------------------------- |
| ETL run logging          | Track package-level execution using a run identifier                 |
| ETL task logging         | Record task execution and status                                     |
| Pre-execution logging    | Capture run/task context and start information                       |
| Post-execution logging   | Record completion status and execution information                   |
| On-error logging         | Capture error descriptions, source/task information, and run context |
| Data quality validation  | Check incoming data and enforce transformation rules                 |
| Row-count reconciliation | Compare source and target record counts                              |
| Error handling           | Support troubleshooting and controlled failure testing               |

### 7. SSIS Packages & Scheduling

| Component            | Responsibility                                    |
| -------------------- | ------------------------------------------------- |
| `MASTER_ETL_PACKAGE` | Orchestrate the overall ETL workflow              |
| `Load_Staging.dtsx`  | Load source CSV data into staging tables          |
| `EPT_Load_main.dtsx` | Execute the main-table loading workflow           |
| SSISDB Catalog       | Host deployed SSIS packages and execution records |
| SQL Server Agent     | Schedule recurring ETL executions                 |

### 8. Data Quality & Transformation

The SQL and SSIS workflows support the following processing activities:

- Source data ingestion into staging tables
- Data type conversion and validation
- Duplicate checking
- Stored-procedure-based loading
- MERGE-based data processing
- Error logging and troubleshooting
- Source-to-target row-count reconciliation

### 9. Power BI Analytics & Security

The Power BI reporting layer uses a star-schema semantic model with table relationships and DAX measures.

**Business KPIs**

- Total Sales
- Units Sold
- Total Orders
- Profit Margin %

**Reporting capabilities**

- Interactive dashboards and slicers
- Dimensional data analysis
- Row-Level Security (RLS) to restrict data visibility according to configured roles and access rules

### 10. Telemetry Analytics — Kusto & KQL

The telemetry analytics component uses Azure Data Explorer (Kusto) and KQL to explore operational data.

Analysis areas include:

- Telemetry and application events
- Error patterns
- Latency and performance trends
- Store and support-ticket activity
- Operational monitoring insights

Refer to the `kql/` directory for the project's query scripts.

### 11. Repository Structure

retail-analytics-telemetry-platform/
├── SQL/ # Tables, stored procedures, views, validation
├── ssis/ # SSIS packages and ETL orchestration
├── pbi/ # Power BI reports and semantic model assets
├── kql/ # Kusto queries and telemetry analysis
├── Docs/ # Architecture and project documentation
├── screenshots/ # Evidence of implementation and results
└── README.md

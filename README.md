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

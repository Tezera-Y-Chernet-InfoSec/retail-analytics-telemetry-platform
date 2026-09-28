# Retail Analytics & Telemetry Platform

## Project Overview

This project demonstrates an end-to-end data analytics and data engineering workflow using retail business data and application telemetry.

The project combines:

* SQL Server
* SQL
* KQL
* Power BI
* ETL and data quality validation
* Azure data architecture concepts

## Business Scenario

A fictional retail company wants to understand:

* Sales performance
* Customer behavior
* Product profitability
* Store performance
* Customer support activity
* Application and system telemetry

The goal is to transform raw data into reliable analytics and actionable insights.

## Project Architecture

```text
CSV Files
   |
   v
SQL Server
   |
   +--> Data Validation
   |
   +--> Star Schema
   |
   v
Power BI
   |
   v
Business Analytics


Telemetry Events
   |
   v
Kusto / KQL
   |
   +--> Error Analysis
   +--> Latency Analysis
   +--> Service Monitoring
   |
   v
Telemetry Insights
```

## Technologies

| Technology | Purpose                          |
| ---------- | -------------------------------- |
| SQL Server | Data storage and analytics       |
| SQL        | Data transformation and analysis |
| KQL        | Telemetry and log analysis       |
| Power BI   | Dashboard and visualization      |
| Python     | Future data analysis/automation  |
| Azure      | Cloud architecture concepts      |
| Git/GitHub | Version control and portfolio    |

## Data

The project uses synthetic datasets representing:

* Customers
* Products
* Stores
* Orders
* Order Items
* Support Tickets
* Telemetry Events

## Project Goals

1. Load raw CSV data into SQL Server.
2. Validate data quality and relationships.
3. Build an analytical data model.
4. Write SQL analytics queries.
5. Analyze telemetry using KQL.
6. Build Power BI dashboards.
7. Document the ETL and analytics process.
8. Present the project as a portfolio demonstrating practical data skills.

## Project Status

**Current phase:** Project setup and data ingestion

More analysis, dashboards, KQL queries, and documentation will be added as the project progresses.

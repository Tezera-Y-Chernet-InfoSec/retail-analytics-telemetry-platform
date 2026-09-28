\# Data Ingestion



\## Objective



Load CSV source files into SQL Server staging tables using SSIS.



\## Source Data



The project uses the following CSV files:



\- customers.csv

\- products.csv

\- stores.csv

\- orders.csv

\- order\_items.csv

\- support\_tickets.csv

\- telemetry\_events.csv



\## Ingestion Process



CSV Files

&#x20;   ↓

SSIS Data Flow

&#x20;   ↓

Staging Tables (stg)



\## SSIS Processing



SSIS packages are used to:



1\. Read the CSV files.

2\. Map source columns to staging columns.

3\. Load the data into SQL Server staging tables.

4\. Preserve source data for validation and transformation.



\## Staging Tables



\- stg.customers

\- stg.products

\- stg.stores

\- stg.orders

\- stg.order\_items

\- stg.support\_tickets

\- stg.telemetry\_events



\## Data Validation



After ingestion, SQL validation queries are used to check:



\- Row counts

\- Missing IDs

\- Duplicate IDs

\- Invalid values

\- Referential integrity

\- Orphan records



\## Next Step



Validated staging data is transformed and loaded into the final SQL tables for analytics and Power BI reporting.


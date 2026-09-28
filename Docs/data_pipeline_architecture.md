## Data Pipeline Architecture

The project uses SSIS to ingest CSV files into SQL Server staging
tables. Data is then validated before being loaded into the final
relational tables for analytics.

CSV Files
    ↓
SSIS Packages
    ↓
Staging Tables
    ↓
Data Validation
    ↓
Final SQL Tables
    ↓
Power BI / Analytics
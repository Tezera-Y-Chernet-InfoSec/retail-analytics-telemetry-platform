POWER BI DAX — RETAIL ANALYTICS \& TELEMETRY PLATFORM



1\. DimDate Calculated Table



Purpose:

The DimDate calculated table creates a continuous calendar covering the full years of the earliest and latest valid order dates in FactSales. Blank Order\_Date values are excluded when determining the date range.



The table includes Year, Month Number, Month, Year Month, Month Start, and Quarter columns to support time-based sales analysis, date filtering, and trend reporting.



DAX Formula:



DimDate =

VAR MinDate =

&#x20;   MINX (

&#x20;       FILTER (

&#x20;           FactSales,

&#x20;           NOT ISBLANK ( FactSales\[Order\_Date] )

&#x20;       ),

&#x20;       FactSales\[Order\_Date]

&#x20;   )

VAR MaxDate =

&#x20;   MAXX (

&#x20;       FILTER (

&#x20;           FactSales,

&#x20;           NOT ISBLANK ( FactSales\[Order\_Date] )

&#x20;       ),

&#x20;       FactSales\[Order\_Date]

&#x20;   )

VAR StartDate =

&#x20;   DATE ( YEAR ( MinDate ), 1, 1 )

VAR EndDate =

&#x20;   DATE ( YEAR ( MaxDate ), 12, 31 )

RETURN

&#x20;   ADDCOLUMNS (

&#x20;       CALENDAR ( StartDate, EndDate ),

&#x20;       "Year", YEAR ( \[Date] ),

&#x20;       "Month Number", MONTH ( \[Date] ),

&#x20;       "Month", FORMAT ( \[Date], "MMM" ),

&#x20;       "Year Month", FORMAT ( \[Date], "yyyy-MM" ),

&#x20;       "Month Start", DATE ( YEAR ( \[Date] ), MONTH ( \[Date] ), 1 ),

&#x20;       "Quarter", "Q" \& FORMAT ( \[Date], "Q" )

&#x20;   )





2\. DAX Measures



Total Sales



Formula:

Total Sales =

SUM ( FactSales\[sales\_amount] )



Purpose:

Calculates total sales revenue within the current filter context, including any applied date, product, customer, or store filters.





Unit Sold



Formula:

Unit Sold =

SUM ( FactSales\[quantity] )



Purpose:

Calculates the total quantity of units sold within the current filter context.





Total Cost



Formula:

Total Cost =

SUM ( FactSales\[product\_cost] )



Purpose:

Calculates the total product cost associated with the sales records in the current filter context.





Gross Profit



Formula:

Gross Profit =

\[Total Sales] - \[Total Cost]



Purpose:

Calculates gross profit by subtracting total product cost from total sales.





Profit Margin %



Formula:

Profit Margin % =

DIVIDE ( \[Gross Profit], \[Total Sales], 0 )



Purpose:

Calculates gross profit as a percentage of total sales. The DIVIDE function returns zero when the sales denominator is zero or blank. Format this measure as a percentage in Power BI.





Total Orders



Formula:

Total Orders =

DISTINCTCOUNT ( FactSales\[order\_id] )



Purpose:

Counts distinct orders within the current filter context, helping analyze order volume across dates, products, customers, and stores.





3\. Implementation Notes



• Use DimDate\[Date] as the calendar date column and mark DimDate as a date table in Power BI.



• Create an active relationship between DimDate\[Date] and the appropriate date column in FactSales.



• Sort the Month column by Month Number to display months in calendar order rather than alphabetical order.



• Use Year Month for chronological monthly trend analysis. If needed, sort it by a suitable numeric year-month sort column.



• Format Profit Margin % as a percentage.



• Validate all measures against the underlying SQL data and ensure they respect the project's recognized-sales business rules.


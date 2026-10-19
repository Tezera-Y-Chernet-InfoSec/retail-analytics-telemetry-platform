Power BI DAX — Retail Analytics & Telemetry Platform

DimDate calculated table
DimDate creates a continuous calendar from the first day of the earliest order year to the last day of the latest order year. It excludes blank Order_Date 
values when finding the date range and adds Year, Month Number, Month, Year Month, Month Start, and Quarter columns for time-based analysis.
DimDate =
VAR MinDate =
    MINX (
        FILTER ( FactSales, NOT ISBLANK ( FactSales[Order_Date] ) ),
        FactSales[Order_Date]
    )
VAR MaxDate =
    MAXX (
        FILTER ( FactSales, NOT ISBLANK ( FactSales[Order_Date] ) ),
        FactSales[Order_Date]
    )
VAR StartDate = DATE ( YEAR ( MinDate ), 1, 1 )
VAR EndDate = DATE ( YEAR ( MaxDate ), 12, 31 )
RETURN
    ADDCOLUMNS (
        CALENDAR ( StartDate, EndDate ),
        "Year", YEAR ( [Date] ),
        "Month Number", MONTH ( [Date] ),
        "Month", FORMAT ( [Date], "MMM" ),
        "Year Month", FORMAT ( [Date], "yyyy-MM" ),
        "Month Start", DATE ( YEAR ( [Date] ), MONTH ( [Date] ), 1 ),
        "Quarter", "Q" & FORMAT ( [Date], "Q" )
    )

Measures

Measure	DAX	Purpose
Total Sales	SUM ( FactSales[sales_amount] )	Total sales amount in the current filter context.
Unit Sold	SUM ( FactSales[quantity] )	Total units sold.
Total Cost	SUM ( FactSales[product_cost] )	Total product cost.
Gross Profit	[Total Sales] - [Total Cost]	Sales less product cost.
Profit Margin %	DIVIDE ( [Gross Profit], [Total Sales], 0 )	Gross profit as a share of sales; format as a percentage.
Total Orders	DISTINCTCOUNT ( FactSales[order_id] )	Number of distinct orders in the current filter context.



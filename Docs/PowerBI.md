# Power BI DAX — Retail Analytics & Telemetry Platform

## 1. DimDate Calculated Table

### Purpose

The `DimDate` calculated table creates a continuous calendar covering the full years of the earliest and latest valid order dates in `FactSales`. Blank `Order_Date` values are excluded when determining the date range.

The table includes Year, Month Number, Month, Year Month, Month Start, and Quarter columns to support time-based sales analysis, date filtering, and trend reporting.

### DAX Formula

```dax
DimDate =
VAR MinDate =
    MINX (
        FILTER (
            FactSales,
            NOT ISBLANK ( FactSales[Order_Date] )
        ),
        FactSales[Order_Date]
    )
VAR MaxDate =
    MAXX (
        FILTER (
            FactSales,
            NOT ISBLANK ( FactSales[Order_Date] )
        ),
        FactSales[Order_Date]
    )
VAR StartDate =
    DATE ( YEAR ( MinDate ), 1, 1 )
VAR EndDate =
    DATE ( YEAR ( MaxDate ), 12, 31 )
RETURN
    ADDCOLUMNS (
        CALENDAR ( StartDate, EndDate ),
        "Year", YEAR ( [Date] ),
        "Month Number", MONTH ( [Date] ),
        "Month", FORMAT ( [Date], "MMM" ),
        "Year Month", FORMAT ( [Date], "yyyy-MM" ),
        "Month Start",
            DATE (
                YEAR ( [Date] ),
                MONTH ( [Date] ),
                1
            ),
        "Quarter", "Q" & FORMAT ( [Date], "Q" )
    )
```

### Columns Created

| Column         | Description                                  |
| -------------- | -------------------------------------------- |
| `Date`         | Continuous calendar date                     |
| `Year`         | Calendar year                                |
| `Month Number` | Numeric month used for chronological sorting |
| `Month`        | Abbreviated month name (Jan, Feb, Mar, etc.) |
| `Year Month`   | Year and month in `yyyy-MM` format           |
| `Month Start`  | First day of each month                      |
| `Quarter`      | Calendar quarter (Q1–Q4)                     |

## 2. DAX Measures

### 2.1 Total Sales

**DAX Formula**

```dax
Total Sales =
SUM ( FactSales[sales_amount] )
```

**Purpose:** Calculates total sales revenue within the current filter context, including applied date, product, customer, and store filters.

### 2.2 Unit Sold

**DAX Formula**

```dax
Unit Sold =
SUM ( FactSales[quantity] )
```

**Purpose:** Calculates the total quantity of units sold within the current filter context.

### 2.3 Total Cost

**DAX Formula**

```dax
Total Cost =
SUM ( FactSales[product_cost] )
```

**Purpose:** Calculates the total product cost associated with the sales records in the current filter context.

### 2.4 Gross Profit

**DAX Formula**

```dax
Gross Profit =
[Total Sales] - [Total Cost]
```

**Purpose:** Calculates gross profit by subtracting total product cost from total sales.

**Business calculation:**

Gross Profit = Total Sales − Total Cost

### 2.5 Profit Margin %

**DAX Formula**

```dax
Profit Margin % =
DIVIDE ( [Gross Profit], [Total Sales], 0 )
```

**Purpose:** Calculates gross profit as a percentage of total sales. The `DIVIDE` function returns zero when the sales denominator is zero or blank.

**Business calculation:**

Profit Margin % = Gross Profit / Total Sales

**Formatting:** Set the measure's format to Percentage in Power BI and select the desired decimal precision.

### 2.6 Total Orders

**DAX Formula**

```dax
Total Orders =
DISTINCTCOUNT ( FactSales[order_id] )
```

**Purpose:** Counts distinct orders within the current filter context, helping analyze order volume across dates, products, customers, and stores.

## 3. Implementation Notes

1. **Configure the date table:** Use `DimDate[Date]` as the calendar date column and mark `DimDate` as a date table in Power BI.
2. **Create the date relationship:** Establish an active relationship between `DimDate[Date]` and the appropriate date column in `FactSales`.
3. **Sort month names:** Select `DimDate[Month]` and choose **Sort by column → Month Number** to display months in calendar order rather than alphabetical order.
4. **Configure monthly trends:** Use `DimDate[Year Month]` for chronological monthly trend analysis. If necessary, create a numeric year-month sort column and sort `Year Month` by that column.
5. **Format profit margin:** Set `Profit Margin %` to Percentage and choose the desired decimal precision.
6. **Validate calculations:** Compare Power BI measures with the underlying SQL results and confirm that they follow the project's recognized-sales business rules.

## 4. Business Logic and Validation

The DAX measures calculate results according to the current filter context and the relationships in the Power BI semantic model.

For this project, **recognized sales include Completed and Shipped orders**, excluding Pending and Cancelled orders.

The following measures are validated against the corresponding SQL results:

- Total sales revenue
- Units sold
- Total product cost
- Gross profit
- Profit margin percentage
- Distinct order count

## 5. Key Power BI Concepts Demonstrated

This implementation demonstrates the following skills:

- **Calculated tables:** Creating a reusable calendar dimension with DAX.
- **Iterator functions:** Using `MINX` and `MAXX` to evaluate expressions across a table.
- **Filter context:** Calculating measures that respond to report filters and slicers.
- **Aggregation functions:** Using `SUM` and `DISTINCTCOUNT` for business metrics.
- **Time-based analysis:** Organizing sales data by year, month, and quarter.
- **Business KPI development:** Calculating revenue, cost, gross profit, and profit margin.
- **Data validation:** Reconciling Power BI measures against SQL results and recognized-sales rules.

These calculations support the Retail Analytics & Telemetry Platform's interactive sales dashboard and demonstrate practical DAX skills for data analyst and business intelligence roles.

# Olist E-commerce Data Warehouse and Sales Analytics

A data warehousing and business intelligence project using Microsoft SQL Server and Power BI to analyse the Olist Brazilian e-commerce dataset.

Developed for the IT3101 – Data Warehousing and Business Intelligence module at SLIIT.

## Project Overview

This project brings related CSV sources into a SQL Server warehouse and presents the results through interactive Power BI dashboards.

The analysis explores:
- Which product categories generate the most delivered sales?
- Which customer states contribute the largest sales shares?
- How do sales and order volumes vary over time?
- How do freight charges compare with sales?

## Tools and Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- SQL and DAX

## Dataset

Source: [Olist Brazilian E-commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The main sales analysis combines orders, order items, customers, products, sellers, and category translations. Payment data is handled separately.

All monetary values are in Brazilian reais (BRL / R$).

## Data Processing

1. Import CSV files into SQL Server staging tables.
2. Trim text, standardise state codes, and handle blank categories.
3. Convert dates and numeric values to suitable data types.
4. Load dimensions before fact tables.
5. Validate counts, keys, and analytical totals.
6. Expose reporting fields through the sales mart.
7. Connect Power BI and create DAX measures and visuals.

## Warehouse Design

The warehouse uses a dimensional model with a snowflake category branch.

| Table | Purpose |
|---|---|
| dw.FactSales | One row per order item |
| dw.FactPayments | One row per payment record within an order |
| dw.DimCustomer | Customer identifiers and location |
| dw.DimProduct | Product details and category relationship |
| dw.DimCategory | Product category descriptions |
| dw.DimSeller | Seller identifiers and location |
| dw.DimDate | Purchase-date attributes |

Sales and payments remain separate because an order can contain multiple items and multiple payment records. Directly joining these records could duplicate amounts.

The mart.SalesAnalysis view provides the reporting data for Power BI.

## Power BI Pages

### 1. Sales Breakdown
Overview of delivered sales, delivered orders, average order value, and freight charges.

### 2. Executive Summary
Product-category rankings, regional sales comparisons, and order-status analysis.

### 3. Trend Analysis
Monthly patterns and available-year comparisons of sales and orders.

### 4. Interactive Analysis
Year, state, and category slicers, an average-order-value decomposition tree, category rankings, a freight-to-sales matrix, and regional sales shares.

## Key Results

| Metric | Result |
|---|---:|
| Delivered sales | R$13,221,498.11 |
| Distinct delivered orders | 96,478 |
| Delivered items | 110,197 |
| Average order value | R$137.04 |
| Delivered freight | R$2,198,275.64 |
| Freight to sales | Approximately 16.63% |

These figures represent the complete delivered subset with filters cleared.

### Selected Findings

- Health and beauty leads delivered sales at approximately R$1.23 million.
- São Paulo contributes approximately 38.33% of delivered sales.
- São Paulo, Rio de Janeiro, and Minas Gerais together contribute approximately 63.38%.
- Bed, bath and table has the highest total freight among the leading categories.

These findings can inform inventory planning, regional distribution, and further investigation of shipping charges.

## Measure Definitions

- Delivered Sales: sum of item prices for delivered orders.
- Delivered Orders: distinct count of delivered order IDs.
- Delivered Items: number of delivered order-item records.
- Average Order Value: Delivered Sales divided by Delivered Orders.
- Delivered Freight: sum of freight charges for delivered items.
- Freight to Sales %: Delivered Freight divided by Delivered Sales.

Sales excludes freight and does not represent profit.

## How to Run

1. Download and extract the source dataset.
2. Create the OlistDW database in SQL Server.
3. Run the table and schema creation scripts.
4. Import the selected CSV files into staging tables.
5. Run transformation and dimension-loading scripts.
6. Load fact tables and run validation queries.
7. Create or update mart.SalesAnalysis.
8. Open the Power BI file.
9. Update the SQL Server connection to your own server and database.
10. Refresh the report.

Follow the execution order documented in the uploaded SQL scripts.

## Interpretation Notes

- The dataset contains partial first and last years, so annual totals are not directly comparable as complete years.
- Charts grouped only by month name combine the same month across years.
- Freight represents recorded charges, not verified logistics expenses.
- Category-level distinct order counts are not additive because an order can contain multiple categories.
- The date dimension contains observed purchase dates rather than a continuous daily calendar.

## Skills Practised

SQL querying, data cleaning, ETL, dimensional modelling, data validation, data mart development, DAX, dashboard design, and business insight communication. 

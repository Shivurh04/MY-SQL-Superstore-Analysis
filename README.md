# SQL Superstore Analysis

A end-to-end SQL data analysis project using the classic Superstore retail dataset. This project covers the full data analysis pipeline — from data cleaning and validation to revenue analysis, customer segmentation, and cohort retention.

---

## Project Structure

```
SQL-Superstore-Analysis/
│
├── Superstore_Dataset.csv       # Raw dataset
├── 01_data_cleaning.sql         # Data validation & cleaning
├── 02_revenue_analysis.sql      # Revenue & profit analysis (18 queries)
├── 03_customer_metrics.sql      # Customer behavior & RFM segmentation
└── 04_cohort_retention.sql      # Cohort analysis & retention rates
```

---

## Dataset

The **Superstore Dataset** is a popular retail dataset containing transactional order data from a US-based superstore. It includes:

| Column | Description |
|---|---|
| `ORDER_ID` | Unique order identifier |
| `ORDER_DATE` / `SHIP_DATE` | Order and shipment dates |
| `CUSTOMER_ID` / `CUSTOMER_NAME` | Customer identifiers |
| `SEGMENT` | Customer segment (Consumer, Corporate, Home Office) |
| `STATE` | US state of the order |
| `PRODUCT_ID` / `PRODUCT_NAME` | Product identifiers |
| `CATEGORY` / `SUB-CATEGORY` | Product classification |
| `SALES` | Revenue from the order line |
| `PROFIT` | Profit from the order line |
| `QUANTITY` | Units sold |
| `DISCOUNT` | Discount applied |

**Database:** MySQL &nbsp;|&nbsp; **Table:** `PROJECT.SUPERSTORE`

---

## Analysis Breakdown

### 01 — Data Cleaning ([01_data_cleaning.sql](01_data_cleaning.sql))

Before any analysis, the raw data is validated and cleaned:

- **Row count** — verify total records loaded
- **NULL check** — detect missing values in key business columns (`SALES`, `PROFIT`, `ORDER_DATE`, `CUSTOMER_ID`)
- **Duplicate removal** — identify and delete duplicate rows using `ROW_NUMBER()` window function partitioned by order + product keys
- **Date formatting** — convert string dates to proper `DATE` type using `STR_TO_DATE()` and `ALTER TABLE`
- **Data integrity** — check for negative sales or zero/negative quantities
- **Summary statistics** — min, max, average, and total for both sales and profit, including overall profit margin

---

### 02 — Revenue Analysis ([02_revenue_analysis.sql](02_revenue_analysis.sql))

18 queries covering business performance from multiple angles:

| # | Analysis |
|---|---|
| 01 | Total revenue & total profit |
| 02 | Overall profit percentage |
| 03 | Average revenue & profit by year |
| 04 | Average Order Value (AOV) |
| 05 | Average order profit |
| 06 | Revenue & profit by **category** |
| 07 | Revenue & profit by **sub-category** |
| 08 | Yearly revenue and profit trend |
| 09 | Orders, revenue & profit by **state** |
| 10 | Orders, revenue & profit by **segment** |
| 11 | Most sold products and their revenue |
| 12 | **Month-on-Month (MoM) growth** with % change |
| 13 | Category-wise revenue with profit margin % |
| 14 | Top 10 customers by revenue |
| 15 | Monthly revenue trend |
| 16 | **Cumulative revenue** over time |
| 17 | Top product within each category (using `ROW_NUMBER`) |
| 18 | Average Order Value (AOV) by month |

---

### 03 — Customer Metrics ([03_customer_metrics.sql](03_customer_metrics.sql))

Deep dive into customer behavior and value:

- **Customer revenue ranking** — rank all customers by total revenue using `RANK()` window function
- **RFM Segmentation** — compute Recency, Frequency, and Monetary value per customer:
  - **Recency** — days since last purchase (`DATEDIFF`)
  - **Frequency** — count of distinct orders
  - **Monetary** — total spend
- **Repeat Purchase Rate** — percentage of customers who placed more than one order
- **Monthly Customer KPIs** — active customers, total orders, revenue, AOV, and orders per customer tracked month by month

---

### 04 — Cohort Retention ([04_cohort_retention.sql](04_cohort_retention.sql))

Understand how well the business retains customers over time:

- **First Purchase Month** — assign each customer to their acquisition cohort using `MIN(ORDER_DATE)`
- **Cohort Retention Analysis** — for each cohort, track how many customers returned to purchase in subsequent months and calculate the **retention rate** as a percentage of cohort size

---

## Key SQL Techniques Used

- **Window Functions** — `ROW_NUMBER()`, `RANK()`, `LAG()`, `SUM() OVER()`
- **CTEs** — multi-step logic broken into readable `WITH` clauses
- **Aggregate Functions** — `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- **Date Functions** — `DATE_FORMAT()`, `STR_TO_DATE()`, `DATEDIFF()`, `YEAR()`
- **Subqueries** — for repeat purchase rate and deduplication
- **JOINs** — self-joins for cohort analysis
- **NULLIF** — safe division to avoid division-by-zero in MoM growth
- **DDL** — `ALTER TABLE`, `UPDATE` for schema and data corrections

---

## How to Run

1. **Import the dataset** — Load `Superstore_Dataset.csv` into a MySQL table named `SUPERSTORE` inside a schema called `PROJECT`
2. **Run scripts in order:**
   ```
   01_data_cleaning.sql      ← Run first (cleans and prepares data)
   02_revenue_analysis.sql   ← Revenue & profit insights
   03_customer_metrics.sql   ← Customer segmentation & KPIs
   04_cohort_retention.sql   ← Retention analysis
   ```
3. Any MySQL client works — **MySQL Workbench**, **DBeaver**, or the `mysql` CLI

---

## Skills Demonstrated

- Data Cleaning & Validation
- Exploratory Data Analysis (EDA) with SQL
- Business KPI calculation (Revenue, Profit Margin, AOV)
- Customer Segmentation (RFM Analysis)
- Time-series trend analysis
- Cohort & Retention analysis
- Advanced SQL (Window Functions, CTEs, Subqueries)

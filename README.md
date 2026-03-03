# Retail Superstore — SQL Analytics Project

![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-orange?style=flat)
![Domain](https://img.shields.io/badge/Domain-E--Commerce%20%7C%20Retail-green?style=flat)
![Type](https://img.shields.io/badge/Type-Data%20Analysis-blueviolet?style=flat)

A structured, end-to-end SQL analytics project on a US retail superstore's transactional data. Built to answer real business questions across revenue performance, customer behavior, and long-term retention — using advanced MySQL techniques throughout.

---

## Business Questions Answered

> The core of every analysis here is a business problem, not just a query.

| Business Question | Analysis |
|---|---|
| How much revenue and profit is the business generating? | Total revenue, profit & margin |
| Which product categories and sub-categories are most profitable? | Category & sub-category breakdown |
| Which states and customer segments drive the most value? | Geographic & segment analysis |
| Is revenue growing month over month? | MoM growth with % change |
| Who are the highest-value customers? | Top 10 customer revenue ranking |
| How loyal are customers? Are they coming back? | Repeat purchase rate & cohort retention |
| How recently did customers buy, how often, and how much? | RFM Segmentation |
| What does the revenue trajectory look like over time? | Cumulative revenue trend |

---

## Project Structure

```
SQL-Superstore-Analysis/
│
├── Superstore_Dataset.csv       # Raw transactional dataset (~9,000 rows)
├── 01_data_cleaning.sql         # Data validation, deduplication & type fixing
├── 02_revenue_analysis.sql      # 18 revenue & profit queries
├── 03_customer_metrics.sql      # RFM segmentation & customer KPIs
└── 04_cohort_retention.sql      # Cohort-based retention analysis
```

---

## Dataset Overview

**Source:** Sample retail dataset — US Superstore orders (4 years of data)
**Size:** ~9,000 rows &nbsp;|&nbsp; **Database:** MySQL &nbsp;|&nbsp; **Table:** `PROJECT.SUPERSTORE`

| Column | Description |
|---|---|
| `ORDER_ID` / `ORDER_DATE` | Order identifier and date placed |
| `SHIP_DATE` | Date the order was shipped |
| `CUSTOMER_ID` / `CUSTOMER_NAME` | Customer identifiers |
| `SEGMENT` | Consumer · Corporate · Home Office |
| `STATE` | US delivery state |
| `CATEGORY` / `SUB-CATEGORY` | Product classification (3 categories, 17 sub-categories) |
| `SALES` | Revenue per order line |
| `PROFIT` | Profit per order line |
| `QUANTITY` | Units sold |
| `DISCOUNT` | Discount applied |

---

## Analysis Breakdown

### 01 — Data Cleaning & Validation &nbsp;·&nbsp; [01_data_cleaning.sql](01_data_cleaning.sql)

Every analysis starts with trust in the data. This script validates and prepares the raw dataset before any business queries run.

| Check | What It Does |
|---|---|
| Row count | Confirms total records loaded correctly |
| NULL audit | Scans key columns — `SALES`, `PROFIT`, `ORDER_DATE`, `CUSTOMER_ID` |
| Duplicate removal | Detects and deletes exact duplicates using `ROW_NUMBER()` partitioned by order + product keys |
| Date conversion | Converts string dates → proper `DATE` type via `STR_TO_DATE()` + `ALTER TABLE` |
| Data integrity | Flags negative sales and zero/negative quantities |
| Summary stats | Min, max, average, total for revenue & profit — including overall profit margin |

---

### 02 — Revenue & Profit Analysis &nbsp;·&nbsp; [02_revenue_analysis.sql](02_revenue_analysis.sql)

18 queries covering every angle of business performance — from high-level KPIs down to product-level and geographic breakdowns.

| # | Business Insight |
|---|---|
| 01 | Total revenue & total profit |
| 02 | Overall profit margin % |
| 03 | Average revenue & profit by year |
| 04 | Average Order Value (AOV) |
| 05 | Average profit per order |
| 06 | Revenue & profit by **category** |
| 07 | Revenue & profit by **sub-category** |
| 08 | Year-over-year revenue & profit trend |
| 09 | Orders, revenue & profit by **US state** |
| 10 | Orders, revenue & profit by **customer segment** |
| 11 | Best-selling products by order frequency & revenue |
| 12 | **Month-on-Month (MoM) revenue growth** with % change using `LAG()` |
| 13 | Category revenue with profit margin % |
| 14 | Top 10 highest-value customers |
| 15 | Monthly revenue trend (time series) |
| 16 | **Cumulative revenue** over time using running `SUM() OVER()` |
| 17 | Top-selling product within each category using `ROW_NUMBER()` |
| 18 | Monthly Average Order Value (AOV) trend |

---

### 03 — Customer Metrics & Segmentation &nbsp;·&nbsp; [03_customer_metrics.sql](03_customer_metrics.sql)

Goes beyond revenue to understand *who* the customers are and *how* they behave.

**RFM Segmentation** — a proven framework for customer value scoring:

| Dimension | Metric | SQL Used |
|---|---|---|
| **Recency** | Days since last purchase | `DATEDIFF(CURDATE(), MAX(ORDER_DATE))` |
| **Frequency** | Number of distinct orders | `COUNT(DISTINCT ORDER_ID)` |
| **Monetary** | Total spend | `SUM(SALES)` |

**Also includes:**
- Customer revenue ranking with `RANK()` window function
- Repeat purchase rate — what % of customers bought more than once
- Monthly customer KPIs — active users, total orders, revenue, AOV, and orders per customer

---

### 04 — Cohort Retention Analysis &nbsp;·&nbsp; [04_cohort_retention.sql](04_cohort_retention.sql)

Tracks whether customers return after their first purchase — one of the most important signals of business health.

- **Cohort assignment** — each customer is grouped by their first purchase month using `MIN(ORDER_DATE)`
- **Retention tracking** — for each cohort, counts how many customers placed orders in each subsequent month
- **Retention rate** — calculated as a percentage of cohort size, enabling direct comparison across cohorts

```sql
-- Core logic: cohort retention rate
ROUND(COUNT(DISTINCT ss.customer_id) / cs.total_customers, 2) AS retention_pct
```

---

## SQL Techniques Demonstrated

| Technique | Used For |
|---|---|
| `ROW_NUMBER()` | Deduplication, top-N per group |
| `RANK()` | Customer revenue ranking |
| `LAG()` | Month-on-Month growth calculation |
| `SUM() OVER()` | Cumulative revenue over time |
| CTEs (`WITH`) | Multi-step cohort logic, MoM growth |
| Subqueries | Repeat purchase rate calculation |
| Self-JOINs | Linking cohorts back to transaction data |
| `DATE_FORMAT()` / `STR_TO_DATE()` | Date parsing and time-series grouping |
| `DATEDIFF()` | Recency calculation in RFM |
| `NULLIF()` | Safe division to prevent divide-by-zero |
| `ALTER TABLE` / `UPDATE` | Schema corrections on raw data |

---

## How to Run

1. **Import the data** — Load `Superstore_Dataset.csv` into MySQL as table `SUPERSTORE` in schema `PROJECT`
2. **Run scripts in order:**

```
01_data_cleaning.sql      ← Always run first
02_revenue_analysis.sql   ← Revenue & profit insights
03_customer_metrics.sql   ← Customer segmentation & KPIs
04_cohort_retention.sql   ← Retention analysis
```

3. Compatible with **MySQL Workbench**, **DBeaver**, or the `mysql` CLI

---

## Skills Demonstrated

- **Data Cleaning & Validation** — Null checks, deduplication, type conversion, integrity checks
- **Exploratory Data Analysis (EDA)** — Summary statistics, distributions, range validation
- **Business KPI Analysis** — Revenue, Profit Margin, AOV, MoM Growth
- **Customer Analytics** — RFM Segmentation, Repeat Purchase Rate, Customer Ranking
- **Time-Series Analysis** — Monthly trends, YoY comparison, cumulative growth
- **Cohort & Retention Analysis** — Customer lifecycle tracking, retention rate calculation
- **Advanced SQL** — Window functions, CTEs, subqueries, multi-table joins

---

## Challenges Faced

**1. Dates stored as strings**
The raw dataset had `ORDER_DATE` and `SHIP_DATE` loaded as text (`VARCHAR`), not actual date types. Running any date-based grouping or comparison on them returned wrong results. Solved by using `STR_TO_DATE()` to parse the format and `ALTER TABLE` to permanently change the column types — learning that data type correctness is a prerequisite, not an afterthought.

**2. Detecting duplicates without a simple key**
The dataset had no single "duplicate" column to check. Duplicates were only identifiable by matching across multiple columns together (`ORDER_ID`, `CUSTOMER_ID`, `PRODUCT_ID`, `ORDER_DATE`, `SALES`, `PROFIT`, `QUANTITY`). Used `ROW_NUMBER() OVER (PARTITION BY ...)` to tag duplicates and then deleted them by `ROW_ID` — understanding that deduplication logic depends entirely on what makes a row unique in context.

**3. Divide-by-zero in Month-on-Month growth**
When calculating MoM growth %, the first month has no previous month — making `LAG()` return `NULL`, and dividing by that caused errors. Solved using `NULLIF(LAG(...), 0)` to safely handle both zero and null denominators, returning `NULL` instead of crashing the query.

**4. Building cohort retention from scratch**
Cohort analysis required three separate logical steps: finding each customer's first purchase month, calculating cohort sizes, and then joining both back to all transactions to compute retention per month. Chaining multiple CTEs together was the only clean way to do this without deeply nested subqueries — a significant jump in query complexity compared to standard aggregations.

**5. Thinking in business terms, not just SQL**
The biggest non-technical challenge was framing queries around business questions rather than just "writing SQL." Learning to ask *"what decision does this answer?"* before writing a single line made the analysis more focused and the results more meaningful.

---

## What I Learned

- **Window functions are essential for real analytics** — `LAG()`, `ROW_NUMBER()`, `RANK()`, and running `SUM() OVER()` came up repeatedly and can't be replaced by simple aggregations. Mastering them unlocked a whole class of problems that were previously impossible.

- **Data cleaning is 40% of the work** — Before writing a single business query, fixing data types, removing duplicates, and validating ranges took significant effort. Clean data isn't given — it's built.

- **CTEs make complex logic readable** — Breaking multi-step logic (like cohort retention) into named, sequential CTEs made queries that would otherwise be unreadable into something structured and debuggable.

- **RFM is a powerful segmentation starting point** — Recency, Frequency, and Monetary value together give a surprisingly complete picture of customer behavior using only order data — no external tools needed.

- **Cohort analysis reveals what averages hide** — Overall retention rate is just a number. Cohort analysis shows *which* group of customers is churning and *when* — a fundamentally more useful view for any retention strategy.

- **Safe SQL practices matter** — Using `NULLIF()` for safe division, always verifying deletes with a `SELECT` before running `DELETE`, and validating date ranges after conversion are habits that prevent silent, hard-to-catch errors in production.

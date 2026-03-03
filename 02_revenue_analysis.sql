-- 01. Total revenue & Total profit
-- 02. Profit percentage
-- 03. Average revenue & profit by year
-- 04. Average oder values
-- 05. Average order profit
-- 06. Revenue & profit by category 
-- 07. Revenue & profit by sub-category 
-- 08. Yearly revenue and profit
-- 09. Orders, Revenue and Profit by state
-- 10. Orders, Revenue and Profit by segment
-- 11. Most sold products and it's revenue
-- 12. Month on month growth
-- 13. Category-wise Revenue
-- 14. Top 10 Customers
-- 15. Monthly Revenue Trend
-- 16. Total revenue accumulating over time
-- 17. Top Product Within Each Category
-- 18. Average Order Value (Monthly)



-------------- 01. Total revenue & Total profit --------------
select 
	round(sum(sales), 2) as total_revenue, 
    round(sum(profit), 2) as total_profit
from project.superstore;


-------------- 02. Profit percentage --------------
select 
    round((sum(profit)/sum(sales))*100, 2) as profit_percentage
from project.superstore;


-------------- 03. Average revenue & profit by year --------------
select year(order_date) average_revenue_year,
	round(avg(sales), 2) average_revenue,
    round(avg(profit), 2) average_profit
from project.superstore
group by average_revenue_year;


-------------- 04. Average oder values -------------
select 
	round(
		sum(sales)/count(distinct order_id), 2
		) as average_order_value
from project.superstore;


-------------- 05. Average order profit -------------
select 
	round(
		sum(profit)/count(distinct order_id), 2
        ) as average_order_profit
from project.superstore;


-------------- 06. Revenue & profit by category -------------
select 
	category, 
	round(sum(sales), 2) revenue_by_category, 
	round(sum(profit), 2) as profit_by_category
from project.superstore
group by category
order by profit_by_category desc;


-------------- 07. Revenue & profit by sub-category -------------
select 
	`sub-category`, 
	round(sum(sales), 2) revenue_by_sub_category, 
	round(sum(profit), 2) as profit_by_sub_category
from project.superstore
group by `sub-category`
order by profit_by_sub_category desc;

-------------- 08. Yearly revenue and profit -------------
select year(order_date) revenue_year, 
	round(sum(sales), 2) as revenue,
    round(sum(profit), 2) as profit
from project.superstore
group by revenue_year
order by revenue desc;

-------------- 09. Orders, Revenue and Profit by state --------------
select state,
	count(order_id) as total_orders, 
    round(sum(sales), 2) as total_revenue, 
    round(sum(profit), 2) as total_profit
from project.superstore
group by state
order by total_profit desc;

-------------- 10. Orders, Revenue and Profit by segment -------------
select segment,
	count(order_id) as total_orders, 
    round(sum(sales), 2) as total_revenue, 
    round(sum(profit), 2) as total_profit
from project.superstore
group by segment
order by total_profit desc;

-------------- 11. Most sold products and it's revenue -------------
select product_id, product_name, 
	count(*) repeated_product_count,
    round(sum(sales), 2) toatal_revenue
from project.superstore
group by product_id, product_name
order by repeated_product_count desc;

-------------- 12. Month on month growth -------------
with mom_growth as (
select 
	date_format(order_date, '%Y-%m') as month,
    round(sum(sales), 2) as revenue
from project.superstore
group by month)
select 
	month, revenue, 
    lag(revenue) over(order by month) as  prev_month,
    round(revenue - lag(revenue) over(order by month), 2) as revenue_diff,
    ROUND(
    100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
           / NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
    2) as mom_growth_pct
from mom_growth;

-------------- 13. Category-wise Revenue --------------
select 
	category, 
    round(sum(sales), 2) total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales) * 100, 2) AS profit_margin_pct
from project.superstore
group by category;

-------------- 14. Top 10 Customers --------------
select 
	customer_id, 
	customer_name, 
    round(sum(sales), 2) as revenue
from project.superstore
group by customer_id, customer_name
order by revenue desc
limit 10;

-------------- 15. Monthly Revenue Trend --------------
select 
	date_format(order_date, '%Y-%m') as month, 
	round(sum(sales), 2) as revenue
from project.superstore
group by month
order by month;

-------------- 16. Total revenue accumulating over time -------------
select date_format(order_date, '%Y-%m') as month,
	round(sum(sales),2) as revenue,
    round(sum(sum(sales)) over(order by date_format(order_date, '%Y-%m')), 2) as acc_rev
from project.superstore
group by month
order by month;

-------------- 17. Top Product Within Each Category --------------
select *
from (select category, product_id, product_name,
        sum(sales) as revenue,
        row_number() over(
			partition by(category) order by sum(sales) desc
            ) as rn
		from project.superstore
        group by category, product_id, product_name) t
where rn = 1;

-------------- 18. Average Order Value (Monthly) --------------
select date_format(order_date, '%Y-%m') month,
	round(sum(sales)/count(distinct order_id), 2) as AOV
from project.superstore
group by month;
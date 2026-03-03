-- 01. Ranking Customers by Revenue
-- 02. RFM SEGMENTATION
-- 03. Repeat Purchase Rate
-- 04. Monthly Customer KPIs
-- 05. Monthly Customer KPIs




-------------- 01. Ranking Customers by Revenue --------------
select customer_id,
	round(sum(sales), 2) as revenue,
    rank() over(order by sum(sales) desc) as revenue_rank
from project.superstore
group by customer_id;

-------------- 02. RFM SEGMENTATION --------------
select 
	customer_id,
    max(order_date) as latest_purchased_date,
    count(distinct order_id) as frequency,
    round(sum(sales), 2) as monetary,
    datediff(curdate(), max(order_date)) as recency_days
from project.superstore
group by customer_id
order by recency_days;

-------------- 03. Repeat Purchase Rate --------------
select round(count(*) * 100/
	(select count(distinct customer_id) from project.superstore), 2) as 
    repeat_purchase_rate
from
	(select customer_id
	from project.superstore
	group by customer_id
	having count(distinct order_id) > 1) t;

-------------- 04. Monthly Customer KPIs --------------
select date_format(order_date, '%Y-%m') as month,
	count(distinct customer_id) as active_customers,
    count(distinct order_id) as total_orders,
    round(sum(sales), 2) as revenue,
    round(sum(sales)/count(distinct order_id), 2) as AOV,
    round(count(distinct order_id)/count(distinct customer_id), 2) as order_per_customer
from project.superstore
group by month
ORDER BY month;

-------------- 05. Monthly Customer KPIs --------------
with order_level as (
	select 
		order_id, customer_id,
        date_format(order_date, '%Y-%m') as month,
        sum(sales) as order_revenue
    from project.superstore
    group by order_id, customer_id, month
)
select month,
	count(distinct customer_id) as active_users,
    count(order_id) as total_orders,
    round(sum(order_revenue), 2) as total_revenue,
    round(sum(order_revenue)/count(order_id), 2) as AOV,
    round(count(order_id)/count(distinct customer_id), 2) as orders_per_customers
from order_level
group by month
order by month;
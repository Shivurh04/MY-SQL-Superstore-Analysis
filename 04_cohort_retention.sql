-- 01. First Purchase Month
-- 02. Cohort Retention Analysis



-------------- 01. First Purchase Month -------------
with first_purchase as (
	select customer_id,
		date_format(min(order_date), '%Y-%m') as cohort_month
    from project.superstore
    group by customer_id
)
select 
	fp.cohort_month,
    date_format(ss.order_date, '%Y-%m') order_month,
    count(distinct ss.customer_id) as active_user
from project.superstore ss 
join first_purchase fp
on ss.customer_id = fp.customer_id 
group by fp.cohort_month, order_month
order by fp.cohort_month, order_month;


-------------- 02. Cohort Retention Analysis --------------
with first_purchase as (
	select 
		customer_id,
		date_format(min(order_date), '%Y-%m') as cohort_month
	from project.superstore
	group by customer_id
	order by cohort_month
),
cohort_size as (
	select cohort_month, 
		count(*) as total_customers
	from first_purchase
    group by cohort_month
)
select 
	fp.cohort_month,
	date_format(ss.order_date, '%Y-%m') as order_month,
    count(distinct ss.customer_id) active_customers,
	round(count(distinct ss.customer_id)/cs.total_customers, 2) as retention_pct
from project.superstore ss
join first_purchase fp
	on ss.customer_id = fp.customer_id  
join cohort_size cs 
	on fp.cohort_month = cs.cohort_month 
group by fp.cohort_month, order_month, cs.total_customers
order by fp.cohort_month, order_month;

/* Business Insight: Weekly order trends */

select 
concat(datepart(year,order_date),'-',datepart(week,order_date)) as weekly_orders,
count(distinct order_id) as number_of_orders
from Order_list 
group by concat(datepart(year,order_date),'-',datepart(week,order_date))

---------------------------------------------------------------------------------------------
/* Business Insight: Weekly order trends by State */
select 
concat(datepart(year,order_date),'-',datepart(week,order_date)) as weekly_orders,
state,
count(distinct order_id) as number_of_orders
from Order_list 
group by concat(datepart(year,order_date),'-',datepart(week,order_date)),state

---------------------------------------------------------------------------------------------
/* Business Insight: Weekly order trends by State */
select 
concat(datepart(year,order_date),'-',datepart(week,order_date)) as weekly_orders,
count(distinct order_id) as number_of_orders
from Order_list 
where datediff(MONTH, order_date, CURRENT_TIMESTAMP)<=36
group by concat(datepart(year,order_date),'-',datepart(week,order_date))
order by weekly_orders


---------------------------------------------------------
/* Business Insight: Key Business Metrics at a Category level */
select 
category,
sum(amount) as amount,
sum(profit) as Profit,
count(distinct [Order ID]) as number_of_orders
from order_details
group by category

-----------------------------------------------------------
/* Business Insight: Second most profitable category for the company on the entire sales data */
with CTE as (select 
category,
sum(amount) as amount,
sum(profit) as Profit,
count(distinct [Order ID]) as number_of_orders
from order_details
group by category)

, ranking as (
select 
category,
amount,
profit,
number_of_orders,
dense_rank() over(order by profit desc) as profit_ranking
from cte)

select * from ranking where profit_ranking = 2

--------------------------------------------------------------------------------------------------
/* Business Insight: Top two profitable sub-categories for each Category in the entire sales duration */

with CTE as 
(select category,
[sub-category],
sum(amount) as amount,
sum(profit) as profit,
count([order id]) as no_orders 
from
order_details
group by Category,[Sub-Category])

, sub as 
(select 
category,
[sub-category],
amount,
profit,
no_orders,
dense_rank()over(partition by category order by profit desc) as ranking from cte)

select * from sub where ranking<=2

-----------------------------------------------------------------------------------------
/* Business Insight: Weekly profit trends in the entire sales data */
select 
concat(datepart(year,order_date),'-',datepart(week,order_date)) as weekly_orders,
count(distinct order_id) as number_of_orders,
sum(order_details.profit) as Profit
from Order_list  join
order_details on order_list.order_id = order_details.[Order ID]
group by concat(datepart(year,order_date),'-',datepart(week,order_date))


-----------------------------------------------------------------------------------------
/* Business Insight: Category-State profit trends in the entire sales data */
select 
State,
Category,
count(distinct order_id) as number_of_orders,
sum(order_details.profit) as Profit
from Order_list  join
order_details on order_list.order_id = order_details.[Order ID]
group by State,Category

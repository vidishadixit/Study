/*

Section 2: Query Questions
Assume tables:

Orders(order_id, customer_id, order_date, total_amount)

OrderItems(order_id, product_id, quantity, price)

Products(product_id, product_name, category)

Customers(customer_id, customer_name, region)

*/


--Q1. Retrieve the top 3 products by total sales amount.

select
	p.Product_id,
	sum(oi.quantity*oi.price) as Total_sales
from
	OrderItems oi
join Products P on oi.produt_id = p.product_id
group by p.product_id
order by total_sales desc
limit 3;

with Sales as (
select
	P.product_id,
	sum(oi.quantity*oi.price) as Total_sales
from
	orderItems oi
join Products P on oi.produt_id = p.product_id
group by p.product_id
	),
ranked as(
select
	product_id,
	total_sales,
	rank() over (order by Total_sales desc) as rnk
from
	sales)
select
	product_id
from
	ranked
where rnk <=3
	


--Q2. Write a query to find customers who placed more than 3 orders in a month.

select
	customer_id,
	format(order_date, 'yyyy-MM') as month,
	count(*) as CountOfCust
from
	Orders 
group by customer_id, format(order_date, 'yyyy-MM')
having count(*) >3

-- Q3. Get the average order value for each customer’s first order.

with firstOrder as (
select 
	customer_id,
	min(order_date) 
from 
	orders 
group by 
	customer_id)
select
	o.customer_id,
	avg(o.total_amount) as total
from
	orders o
join firstorder f on o.customer_id = f.customer_id
group by o.customer_id

--Q4. Find the cumulative revenue per month. Orders(order_id, customer_id, order_date, total_amount)

select 
	format(order_date, 'yyyy-MM') as month,
	sum(total_amount) as monthlyRevenue,
	sum(total_amount) over (order by format(order_date, 'yyyy-MM')) as CumulativeRevenue
from
	orders
group by
	format(order_date, 'yyyy-MM')

--Q5. Identify the most frequently purchased product category in each region.



--Q6. Detect customers who never ordered again after their first order.

-- Q7. Write an SQL query to find the total number of orders placed by each customer from the table.

select
	customer_id,
	count(*) as totalNum
from
	orders
group by
	customer_id
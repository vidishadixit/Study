/*
1. Find the Second Highest Salary
Table: employees(emp_id, emp_name, salary)
*/

select
	emp_id,
	salary
from
	employees
order by salary desc
limit 2
/*
🟣 Write a query to find the second highest salary without using LIMIT or TOP.
*/
select
	emp_id,
	salary
from
	(select
		emp_id,
		emp_name,
		salary,
		rank() over (order by salary desc) as rnk
	from
		employees
	)
where rnk = 2

/*
🔹 2. Running Total (Cumulative Sum)
Table: sales(sale_id, sale_date, amount)

🟣 Write a query to display cumulative sales amount over time, ordered by sale_date.
*/

select
	sale_id,
	sum(amount) over (order by sale_date asc) as cumulative_sum
from
	sales

/*

🔹 3. Top 3 Salaries Per Department
Table: employees(emp_id, emp_name, department_id, salary)
*/

select
	emp_id,
	salary,
	department_id
from
	(select
		emp_id,
		salary,
		department_id,
		rank() over (partition by department_id order by salary desc) as rnk
	from
		employees
	) a
where rnk<=3
/*

🟣 Write a query to get top 3 earning employees in each department.
*/

select
	emp_id,
	department,
	salary
from
	(
	select
		emp_id,
		department,
		salary,
		rank() over (partition by department order by salary desc) as rnk
	from
		employees
		) a
where rnk <=3
		
/*
🔹 4. Customers with Orders Greater Than Their Own Average Order Value
Tables:

orders(order_id, customer_id, amount)

🟣 Find all orders where the amount is greater than that customer's average order value.
*/

select
	order_id, customer_id, amount
from
	orders o
where amount> (select avg(amount) from orders where customer_id = o.customer_id)

/*

🔹 5. Identify Gaps in Dates
Table: attendance(emp_id, attendance_date)

🟣 Write a query to find employees who have missing consecutive attendance dates (e.g., absent on a working day).
*/

select
	emp_id
from
	(
	select
		emp_id,
		attendance_date,
		lag(attendance_date) over (partition by emp_id order by attendance_date) Gap
	from
		attendance
	) a
where datediff(attendance_date,gap) > 1

/*

🔹 6. Product Pairs Sold Together
Table: order_items(order_id, product_id)

🟣 Write a query to find distinct pairs of products that were sold together in the same order.

*/

SELECT DISTINCT
  a.product_id AS product_1,
  b.product_id AS product_2
FROM order_items a
JOIN order_items b
  ON a.order_id = b.order_id
WHERE a.product_id < b.product_id;


/*

🔹 7. Median Salary
Table: employees(emp_id, salary)

🟣 Write a query to calculate the median salary using SQL (no built-in MEDIAN() function).
*/

with ranks as(
select 
	rank() over (order by salary) as rnk,
	count(*) over () as total_count
from
	employees)
select
	avg(salary) as median_salary
from ranks
where rnk in (
	(total_count +1)/2,
	(total_count +2)/2)
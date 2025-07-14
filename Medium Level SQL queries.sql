/*
Write a query to find the second highest salary in an employee table.
Fetch all employees whose names contain the letter “a” exactly twice.
How do you retrieve only duplicate records from a table?
Write a query to calculate the running total of sales by date.
Find employees who earn more than the average salary in their department.
Write a query to find the most frequently occurring value in a column.
Fetch records where the date is within the last 7 days from today.
Write a query to count how many employees share the same salary.
How do you fetch the top 3 records for each group in a table?
Retrieve products that were never sold (hint: use LEFT JOIN).
*/

--Write a query to find the second highest salary in an employee table.

select
	employee_id
from
	(select
		employee_id,
		salary,
		rank() over (order by salary desc) as rnk
	from
		employees
	) a
where rnk = 2

-- or

select
	employee_id
from
	employees
order by
	salary
offset 1 rows fetch next 1 rows only

-- or

select
	employee_id,
	Salary
from
	employees
where salary = (select
					max(salary)
				from
					employees
				where salary < (select max(salary) from employees))

-- Fetch all employees whose names contain the letter “a” exactly twice.

select
	employee_name
from
	employees
where
	len(employee_name) - len(replace(lower(employee_name), 'a', '')) =2

-- How do you retrieve only duplicate records from a table?

select
	emp_id,
	count(*)
from
	employees
group by emp_id
having count(*) >1

-- full rows

with dupe as
(select
	emp_id,
	count(*)
from
	employees
group by emp_id
having count(*) >1)
select * from employees
where emp_id in (select emp_id from dupe)

-- Write a query to calculate the running total of sales by date.

select
	product_id,
	sale_date,
	sum(order_amount) over (partition by produc_id order by sale_date) as running_total
from
	Orders

-- Find employees who earn more than the average salary in their department.

select
	employee_id,
	department,
	salary
from
	employees e
where salary > (select avg(salary) from employees where department = e.department)

--Write a query to find the most frequently occurring value in a column.

SELECT TOP 1
    employee_Firstname,
    COUNT(*) AS name_count
FROM
    employees
GROUP BY
    employee_Firstname
ORDER BY
    name_count DESC;

-- Fetch records where the date is within the last 7 days from today.

select
	order_id
from
	orders
where 
	order_date  >= DATEADD(day, -7, GETDATE())
	and order_date <= GETDATE()

-- Write a query to count how many employees share the same salary.

SELECT
    employee_id,
    salary,
    COUNT(*) OVER (PARTITION BY salary) AS salary_group_count
FROM
    employees;

-- How do you fetch the top 3 records for each group in a table?

select
	product_id
from
(
select 
	product_id,
	amount,
	row_number() over (partition by product_id order by amount desc) as rnk
from
	orders) a
where rnk <=3

--Retrieve products that were never sold (hint: use LEFT JOIN).

SELECT
    p.product_id,
    p.product_name
FROM
    products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

/*
PART 2: QUERY QUESTIONS
1. WHERE, LIKE, UPDATE, DELETE
Q: Find and delete all products whose names start with “Test_” and haven’t been sold in the last 60 days.
(Tables: products(product_id, name), sales(product_id, sale_date))
*/


delete from products
where name like 'Test_%'
 and product_id not in (
	select product_id from sales
	where sale_date >= dateadd(day, -60, getdate());

/*
2. TOP, OFFSET, FETCH, ORDER BY
Q: Write a query to return the 6th to 10th most expensive products in descending price order.
(Table: products(product_id, product_name, price))
*/

select
	product_id
from
	products
order by
	price desc
limit 5,5;

/*
3. COUNT, MIN, MAX, AVG, SUM, GROUP BY
Q: For each customer, return the total, average, and highest order amount.
(Table: orders(order_id, customer_id, amount))
*/

select
	customer_id,
	sum(amount) as total,
	avg(amount) as average,
	max(amount) as highest
from
	orders
group by
	customer_id

/*
4. WINDOW FUNCTIONS, RANK, ROW_NUMBER
Q: Rank employees by salary within each department, showing only the top 2 in each.
(Table: employees(emp_id, department, salary))
*/

select
	emp_id,
	salary,
	department
from
	(select
		emp_id,
		salary,
		department,
		rank() over (partition by department order by salary desc) as rnk
	from
		employees) a
where rnk <= 2

/*
5. STRING FUNCTIONS, CONCAT, LENGTH
Q: Create a formatted email alias for each employee as firstnamelastname@company.com from first_name, last_name.
(Table: employees(emp_id, first_name, last_name))
*/

select
	concat(firstname,lastname, '@company.com') as email
from
	employees

/*
6. DATE FUNCTIONS, DATEDIFF, CURDATE
Q: List customers who haven’t placed an order in the last 90 days.
(Tables: customers(customer_id), orders(order_id, customer_id, order_date))
*/

select
	c.customer_id
from
	customers c
left join orders o on c.customer_id = o.customer_id
where
	o.order_id is null
or
	o.order_date <dateadd(day, -90, getdate());
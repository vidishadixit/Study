/*
PART 2: Query Questions
6. Basic SELECT + WHERE + ORDER BY:

SELECT product_name, price 
FROM products 
WHERE price > 100 
ORDER BY price DESC;
?? What does this query do, and how would you modify it to only return the top 5 expensive products?
-this query gives the products which has price graeter than 100 ans sorts the result descending.
*/

SELECT product_name, price 
FROM products 
WHERE price > 100 
ORDER BY price DESC
limit 5;

--or

select
	product_name,
	Price
from
	(
	select
		product_name,
		price,
		rank() over (order by price desc) as rnk
	from
		products
	) a
where rnk<= 5


/*
7. GROUP BY + Aggregates:
Write a query to find the total revenue per product category:

SELECT product_category, SUM(sales_amount) AS total_revenue
FROM sales_data
GROUP BY product_category;
?? Modify the query to show only those categories with total revenue above ?50,000.
*/

-- per product category

select
	product_category,
	sum(sales_amount) over(partition by product_category) as total_revenue
from
	sales_data

--modifications
SELECT product_category, SUM(sales_amount) AS total_revenue
FROM sales_data
GROUP BY product_category
having SUM(sales_amount) >50000

/*
8. JOINs:
Given two tables:

orders(order_id, customer_id, order_date)

customers(customer_id, customer_name)

?? Write a query to list all customer names who placed an order in March 2024.
*/

select
	c.customer_name
from
	customers c
join orders o
on c.customer_id = o.customer_id
where format(o.order_date, 'yyyy-MM') = '2024-03'

/*
9. Subqueries:
?? Find products whose price is higher than the average price of all products.
*/

select
	product_name
from
	products
where price>(select avg(price) from products)

/*
10. Window Functions:
?? Write a query to display each employee’s salary and their rank within their department (highest to lowest salary).
*/

select
	emp_id,
	department_id,
	salary,
	rank() over (partition by department_id order by salary desc) as rnk
from
	employees
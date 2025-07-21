/*
PART 2: Tricky Query Challenges
Q5.
Find the customer(s) who made more than one purchase on the same day.
-- Tables: orders(order_id, customer_id, order_date)
*/

select
	customer_id,
	Order_date,
	count(*) as Purchases
from
	orders
group by customer_id, Order_date
having count(*)>1

/*
Q6.
Write a query to return the first non-null value for each product from a list of possible description fields.

-- Table: products(product_id, desc1, desc2, desc3)
-- Use COALESCE or other tricks

*/

select
	product_id,
	coalesce(desc1, desc2, desc3) as description
from
	products


/*
Q7.
From a table of employee hierarchy, find if there’s a cycle in the reporting structure.

-- Table: employees(emp_id, manager_id)
-- Use recursive CTE to detect loop

*/

WITH RECURSIVE hierarchy AS (
  SELECT emp_id, manager_id, CAST(emp_id AS CHAR(100)) AS path
  FROM employees
  WHERE manager_id IS NOT NULL

  UNION ALL

  SELECT e.emp_id, e.manager_id, CONCAT(h.path, '->', e.emp_id)
  FROM employees e
  JOIN hierarchy h ON e.manager_id = h.emp_id
  WHERE LOCATE(CONCAT('->', e.emp_id), h.path) = 0 -- prevent infinite loops
)
SELECT * 
FROM hierarchy
WHERE emp_id = manager_id;
-- If any row exists where emp_id = manager_id, there's a cycle


/*

Q8.
Return a list of customers who ordered every product in the catalog.

-- Tables:
-- products(product_id)
-- orders(order_id, customer_id, product_id)

*/

SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) = (SELECT COUNT(*) FROM products);


/*
Q9.
Generate all dates between a start and end date using SQL only — no calendar table.
*/

WITH RECURSIVE dates AS (
  SELECT DATE('2023-01-01') AS dt
  UNION ALL
  SELECT DATE_ADD(dt, INTERVAL 1 DAY)
  FROM dates
  WHERE dt < '2023-01-10'
)
SELECT * FROM dates;

/*
Q10.
Find top N products per category using DENSE_RANK, and also include ties.
*/

select
	*
from
	(
	select
		*,
		DENSE_RANK() over (partition by category_id order by price desc) as rnk
	from
		products
	) a
where rnk <= 3
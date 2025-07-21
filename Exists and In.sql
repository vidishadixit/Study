/*
Q1.
Retrieve all customers who have placed at least one order.
Tables: Customers(customer_id, customer_name), Orders(order_id, customer_id)
Use: IN
*/

select
	customer_id
from
	customers
where
	customer_id in (select customer_id, count(*) from orders group by customer_id having count(*)>0)


/*
Q2.
Fetch the names of products that have never been ordered.
Tables: Products(product_id, product_name), OrderItems(order_id, product_id)
Use: NOT IN
*/

select
	product_id
from
	products
where
	product_id not in (select product_id from orderItems)

/*
Intermediate Level
Q3.
Get the list of all customers who have placed an order only if they have at least one order.
Tables: Customers(customer_id, name), Orders(order_id, customer_id)
Use: EXISTS
*/

select
	customer_id,
	name
from
	customers c
where
	exists(
	select 1
	from orders o
	where c.customer_id = o.customer_id)
	

/*
Q4.
Find the orders that include products from the 'electronics' category.
Tables: Orders(order_id), OrderItems(order_id, product_id), Products(product_id, category)
Use: IN or EXISTS
*/

select
	o.order_id
from
	orders o 
where
	exists(
	select 1
	from orderitems ot
	join products p on ot.product_id = p.product_id
	and p.product_category = 'electronics')

/*
Advanced Level
Q5.
List all customers who ordered only from the "books" category and never from any other category.
Tables: Customers, Orders, OrderItems, Products
Use: NOT EXISTS in a correlated subquery
*/

select
	customer_id
from
	customers
where
	not exists(
	select 1
	from orders o
	join orderitems ot on o.order_id = ot.order_id
	join products p on ot.product_id = p.product_id
	and p.category != 'books')

/*
Q6.
Identify sellers who sell at least one product that has never been ordered.
Tables: Sellers(seller_id), Products(product_id, seller_id), OrderItems(product_id)
Use: EXISTS with NOT IN
*/

select
	sellers
from
	sellers
where
	exists(
	select p.product_id
	from
		products p
	join orderitems ot on p.product_id = ot.product_id
	where ot.product_id is null)


/*
Q7.
Retrieve product names that have been ordered by every customer.
Tables: Products, Orders, OrderItems, Customers
Use: NOT EXISTS + double negative subquery trick
*/
SELECT
    p.product_name
FROM
    Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Customers c
    WHERE NOT EXISTS (
        SELECT 1
        FROM Orders o
        JOIN OrderItems oi ON o.order_id = oi.order_id
        WHERE o.customer_id = c.customer_id
        AND oi.product_id = p.product_id
    )
);

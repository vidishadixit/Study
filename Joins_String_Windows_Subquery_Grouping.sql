/*
Question 1: Basic to Intermediate Joins

You have two tables:
Customers(CustomerID, CustomerName, Country)
Orders(OrderID, CustomerID, OrderDate, TotalAmount)
Task:
Write a query to display all customers with the total amount they have spent. Include customers with no orders.

Question 2: Aggregation and Grouping

Using the same Orders table:

Task:
Find the top 3 customers by total amount spent, and show:

CustomerID

TotalSpent

Question 3: Window Functions
Given the Orders table again:

Task:
For each customer, find their second most recent order.

Question 4: Subquery Challenge
You have a Products table:

Products(ProductID, ProductName, Price)
Orders(OrderID, ProductID, Quantity)
Task:
Find the product(s) that have generated the highest total revenue.

Question 5: Data Cleaning Logic
You have a Users table with inconsistent email formats:


Users(UserID, Email)
Examples of bad values:

' john.doe@GMAIL.com '

'jane_doe@Yahoo.Co.Uk'

Task:
Write a query to return cleaned email addresses:

Trimmed

Lowercased

*/

/*
Question 1: Basic to Intermediate Joins

You have two tables:
Customers(CustomerID, CustomerName, Country)
Orders(OrderID, CustomerID, OrderDate, TotalAmount)
Task:
Write a query to display all customers with the total amount they have spent. Include customers with no orders.
*/

select
	c.customerId,
	sum(totalamount) as Spent_money
from
	customers c
left join orders o on c.customerid = o.customerid
group by
	c.customerId
order by Spent_money desc


/*
Question 2: Aggregation and Grouping

Using the same Orders table:

Task:
Find the top 3 customers by total amount spent, and show:

CustomerID

TotalSpent
*/

select
	c.customerId,
	sum(o.totalamount) as Spent_money
from
	customers c
join orders o on c.customerid = o.customerid
group by
	c.customerId
order by Spent_money desc
limit 3

/*
Question 3: Window Functions
Given the Orders table again:
Customers(CustomerID, CustomerName, Country)
Orders(OrderID, CustomerID, OrderDate, TotalAmount)

Task:
For each customer, find their second most recent order.
*/

select
	customerid,
	OrderId
from
	(
		select
			c.customerId,
			o.OrderId,
			rank() over (partition by c.customerid order by o.orderdate desc) as rnk
		from
			customers c
		join orders o on c.customerid = o.customerid
		group by
			c.customerId, o.OrderId
		) a
	where rnk  = 2

/*
Question 4: Subquery Challenge
You have a Products table:

Products(ProductID, ProductName, Price)
Orders(OrderID, ProductID, Quantity)
Task:
Find the product(s) that have generated the highest total revenue.
*/

select
	productid,
	totalrevenue
from
	(
	select
		p.productid,
		sum(p.price * o.quantity) as totalrevenue
	from
		products p
join orders o on p.productid = o.orderid
	)a
where
	totalrevenue = (
	select 
		max(sum(p.price * o.quantity))
	from products p
	join orders o on p.productid = o.orderid)

/*
Question 5: Data Cleaning Logic
You have a Users table with inconsistent email formats:


Users(UserID, Email)
Examples of bad values:

' john.doe@GMAIL.com '

'jane_doe@Yahoo.Co.Uk'

Task:
Write a query to return cleaned email addresses:

Trimmed

Lowercased
*/

select
	lower(trim(email)) as email
from
	users
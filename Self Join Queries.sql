/*
1. Find all employees who earn more than their manager
Table:
Employee(id, name, salary, manager_id)

Task:
Write a query to find employees whose salary is greater than their manager’s salary.
*/

select
	e.id
from
	Employee e
join Employee m on e.id = m.manager_id
where e.salary>m.salary


/*
2. Find duplicate rows by a column (excluding one)
Table:
Products(product_id, name, category, price)

Task:
Delete all but one row for each duplicate name, keeping the row with the lowest product_id.

*/

with duplicates as(
select
	product_id,
	name,
	category,
	Price,
	RANK() over (partition by name order by product_id) as rnk
from
	Products
)
delete from duplicates
where rnk>1

/*
3. Find the second highest salary
Table:
Employee(id, name, salary)

Task:
Write a query to find the employee with the second highest salary, using self-join only (no LIMIT, OFFSET, or RANK() functions).
*/

select
	e.salary
from
	employee e
join employee ee on e.salary > ee.salary
where not exists(
			select 1
			from
				employee eee where eee.salary<e.salary and eee.salary >(select min(e1.salary) from employee e1);


SELECT MAX(e1.salary) AS second_highest
FROM Employee e1
WHERE e1.salary < (SELECT MAX(salary) FROM Employee);


/*
4. Find customers who referred others
Table:
Customers(customer_id, name, referred_by_id)

Task:
List names of customers who have referred at least one other customer.
*/

select
	c.customer_id
from
	Customers c
join Customers r on c.customer_id = r.referred_by_id


/*
5. Find pairs of people with the same birthday
Table:
People(id, name, birth_date)

Task:
Find all distinct pairs of people who share the same birthday, without repeating (e.g., A-B and B-A should not both appear).
*/

select
	distinct p.name, b.name
from
	People p
join People b on p.birth_date = b.birth_date and p.id < b.id

/*
6. Find employees at the same level
Table:
OrgChart(id, name, manager_id)

Task:
List all pairs of employees who report to the same manager.
*/

select
	name
from
	OrgChart o
join OrgChart oc on o.manager_id = oc.manager_id and o.id < oc.id

/*
7. Find the person with the longest name and the one with the shortest name
Table:
Users(user_id, name)

Task:
Return the shortest and longest name(s) (if ties, return all) using self-join.
*/

SELECT name
FROM Users
WHERE LEN(name) = (SELECT MAX(LEN(name)) FROM Users)
   OR LEN(name) = (SELECT MIN(LEN(name)) FROM Users);

/*

Date functions in SQL

*/

--1. Retrieve the current system date and time.

select getdate() as CurrentSysDateTime

--2. Fetch all employees who joined in the last 90 days.

select
	Emp_id
from
	Employees
where
	DOJ <= dateadd(day, -90, getdate())

--3. Find the difference in days between `order_date` and `delivery_date` from an `Orders` table.

select
	datediff(day, order_date, delivery_date) as DiffinDays
from
	Orders
	
--4. Get all records from `Sales` table where the sale happened in the **current month**.

select * from Sales
where
	month(SaleDate) = month(getdate())
and
	year(saleDate) = year(getdate())

--5. Extract year, month, and day separately from a `hire_date` column.

select
	FORMAT(hire_date, 'yyyy') as Year,
	Format(hire_date, 'MM') as Month,
	Format(hire_date, 'dd') as Day
from
	Table

--6. Get the number of days left in the current month from today’s date.

select DATEDIFF(day,getdate(), eomonth(getdate())) as DaysLeftinMonth
 
--7. Return all customers whose birthday falls **this month** from a `birth_date` column.

select * from Customers
where
	month(Birth_date) = MONTH(getdate())

--8. Retrieve all orders placed on a **weekend**.

select * from Orders
where
	DATENAME(WEEKDAY, order_date) in ('Saturday', 'Sunday')

--9. Find the first day and last day of the current month.

SELECT
  DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AS FirstDay,
  EOMONTH(GETDATE()) AS LastDay;


--10. Write a query to return all sales made in **Q2 (April to June)** of any year.

SELECT *
FROM Sales
WHERE MONTH(SaleDate) BETWEEN 4 AND 6;


--11. Show how many orders were placed **each month** of 2024.

--12. From the `Employees` table, calculate how many **years, months, and days** each employee has completed in the company based on `hire_date`.

--13. Round down a datetime value to just the start of the day (i.e., remove the time part).

--14. Retrieve all rows where `payment_date` is the **last day of any month**.

--15. Calculate the **age** of customers using their `birth_date`.

--16. Display current date in `DD-MM-YYYY` format using `FORMAT()`.

--17. Show all orders where `order_date` was **on a Monday**.

--18. Fetch orders that were placed in the **last week**, i.e., the previous Monday to Sunday range (excluding this week).

--19. Get all events from `Events` table that are scheduled on **leap day (Feb 29)**.

--20. Write a query to generate a list of the first day of each month in 2025.

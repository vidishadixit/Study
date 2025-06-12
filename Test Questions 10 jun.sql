/*
SQL Middle Aged

Table: maintable_EHQMU(id, firstname, lastname, age)

In this MySQL challenge, your query should return the FirstName, LastName, and 
Age of all users aged between 23 and 27 (inclusive). 
The results should be ordered by Age in descending order and then by ID in ascending order for those with the same age.
*/

select
	FisrtName,
	Lastname,
	Age
from
	maintable_EHQMU
where
	Age between 23 and 27
order by
	Age desc, id asc

/*
SalesformattedDate

learnbay_dqobd_Sales (productname, saledate, saleamount)

Find the total sales amount for each product per month, and 
also display the day of the week when the highest sales occurred for that product in each month.
*/

-- Step 1: Get daily sales with weekday and month
WITH DailySales AS (
    SELECT 
        productname,
        FORMAT(saledate, 'yyyy-MM') AS sale_month,
        DATENAME(WEEKDAY, saledate) AS weekday,
        CAST(saledate AS DATE) AS sale_day,
        SUM(saleamount) AS daily_sales
    FROM learnbay_dqobd_Sales
    GROUP BY 
        productname, 
        FORMAT(saledate, 'yyyy-MM'), 
        CAST(saledate AS DATE), 
        DATENAME(WEEKDAY, saledate)
),

-- Step 2: Get total monthly sales per product
MonthlySales AS (
    SELECT 
        productname,
        sale_month,
        SUM(daily_sales) AS total_monthly_sales
    FROM DailySales
    GROUP BY productname, sale_month
),

-- Step 3: Rank weekdays by daily sales per product per month
MaxSalesWeekday AS (
    SELECT 
        ds.productname,
        ds.sale_month,
        ds.weekday,
        ds.daily_sales,
        RANK() OVER (
            PARTITION BY ds.productname, ds.sale_month 
            ORDER BY ds.daily_sales DESC
        ) AS rnk
    FROM DailySales ds
)

-- Step 4: Final output
SELECT 
    ms.productname,
    ms.sale_month,
    mw.weekday AS highest_sales_weekday,
    ms.total_monthly_sales
FROM MonthlySales ms
JOIN MaxSalesWeekday mw
    ON ms.productname = mw.productname AND ms.sale_month = mw.sale_month
WHERE mw.rnk = 1
ORDER BY ms.sale_month, ms.productname;

/*
SQLQueryQsns

learnbay_dqobd_Books (Title, Author, Year)

write a query to ensure it correctly retrieves all possible pairs of books written by the same author.
Your query should returns Book1title,Author,Year1,Book2title,Year2
*/

select
	b1.Title as Book1title,
	b1.Author,
	b1.Year as Year1,
	b2.Title as Book2title,
	b2.year as Year2
from
	learnbay_dqobd_Books b1
join learnbay_dqobd_Books b2
on b1.author = b2.author
and b1.title > b2.title

/*
SQLSalesQuery

learnbay_dqobd_Sales(ProductName, Region, Saleamount)

Find the total sales amount for each product by region and identify the top-performing region for each product.

You’ll need to:

Group the data by ProductName and Region.

Calculate the total sales for each product in each region.

Find the region with the highest total sales for each product.

*/

with TotalSalesPerProduct as
(
select
	ProductName,
	Region,
	sum(saleamount) as total_sales
from
	learnbay_dqobd_Sales
group by 
	ProductName,
	Region
),
RankedSales AS (
    SELECT *,
           RANK() OVER (PARTITION BY ProductName ORDER BY TotalSales DESC) AS rnk
    FROM TotalSalesPerProduct
)
select
	ProductName,
	Region,
	total_sales as HighestTotalSales
from
	RankedSales
WHERE rnk = 1 

/*
SQLcustomertable

learnbay_dqobd_Customer(Customer_id, Registrationdate, city)

List the cities where customers have registered in the last 6 months from '2024-01-01' and count the number of customers as 
NumCustomers and RegistrationDate as MostRecentRegistration in each city. 
Order the result by the most recent registration date.
*/

select
	city,
	count(*) as NumCustomers,
	max(RegistrationDate) as MostRecentRegistration
from
	learnbay_dqobd_Customer
where
	RegistrationDate >= DATEADD(MONTH, -6, '2024-01-01')
	and RegistrationDate< '2024-01-01'
group by
	city
order by
	MostRecentRegistration
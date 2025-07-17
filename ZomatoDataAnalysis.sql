/*
1. Write a SQL query to find the top 5 restaurants with the highest total orders in the last month.
2. Identify customers who ordered food in more than 3 different cities.
3. Find restaurants that have never received a rating below 4.
4. Calculate the average delivery time per delivery partner.
5. Retrieve customers who placed orders on consecutive days at least once.
6. Write a query to get the most frequently ordered dish for each city.
7. Find delivery partners with more than 10% of their deliveries marked as late.
8. Write a query to get the first and latest review date for each restaurant.
9. Identify customers who placed at least 2 orders every month for the last 6 months.
10. Find restaurants with revenue above the average restaurant revenue in their city.

*/

--Write a SQL query to find the top 5 restaurants with the highest total orders in the last month.

select top 5
	restaurant_id,
	Restaurant_name,
	count(*) as Total_orders
from
	ZomatoData
where
	order_date>=DATEADD(month, DATEDIFF(month, 0, GETDATE())-1,0)
and
	order_date < DATEADD(month, datediff(month, 0, getdate()),0)
group by
	restaurant_id,
	Restaurant_name
order by
	Total_orders desc

-- Identify customers who ordered food in more than 3 different cities.

select
	customer_id,
	count(distinct city) as num_cities
from
	ZomatoData
group by
	customer_id
having
	count(*) > 3
order by
	num_cities desc

-- Find restaurants that have never received a rating below 4.

select
	restaurant_id
from
	ZomatoData
group by
	restaurant_id
having
	min(rating) >= 4

-- Calculate the average delivery time per delivery partner

select
	delivery_agentID,
	avg(delivery_time) as avg_delivery_time
from
	ZomatoData
group by
	delivery_agentID

--Retrieve customers who placed orders on consecutive days at least once.

with prevDateOrder as
(
	select
		customer_id,
		order_date,
		lag(order_date) over (partition by customer_id order by order_date) as prevOrder_date
	from
		ZomatoData
)
select
	customer_id
from
	prevDateOrder
where
	datediff(DAY, prevOrder_date, order_date)=1

-- Write a query to get the most frequently ordered dish for each city.

with mostdishesOrdered as(
select
	city,
	food_items,
	count(*) as num_ordered,
	row_number() over (partition by city order by count(*)) as rnk
from
	ZomatoData
group by
	city,
	food_items
order by
	num_ordered desc
)
select
	city,
	food_items,
	num_ordered
from
	mostdishesOrdered
where rnk = 1

--Find delivery partners with more than 10% of their deliveries marked as late.

WITH DeliveryStats AS (
    SELECT
        delivery_agentId,
        SUM(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS late_deliveries,
        COUNT(*) AS total_deliveries
    FROM
        ZomatoData
    GROUP BY
        delivery_agentId
)
SELECT
    delivery_agentId,
    ROUND(1.0 * late_deliveries / total_deliveries, 2) AS late_delivery_ratio
FROM
    DeliveryStats
WHERE
    1.0 * late_deliveries / total_deliveries > 0.10;

--Write a query to get the first and latest review date for each restaurant.

select
	restaurant_id,
	min(review_date) as FirstReview,
	max(review_date) as LatestReview
from
	ZOmatoData
group by
	restaurant_id

--Identify customers who placed at least 2 orders every month for the last 6 months.

with ordersFromLast6Months as
(
select
	customer_id,
	FORMAT(order_date, 'yyyy-MM') as Order_month
from
	ZomatoData
where
	Order_date>= DATEADD(MONTH, -6, cast(getdate() as date))
),
MonthlyOrderCounts as
(
select
	customer_id,
	Order_month,
	count(*) as order_count
from
	ordersFromLast6Months
group by
	customer_id,
	Order_month
),
CustomersWith2OrdersPerMonth AS (
    SELECT
        customer_id
    FROM
        MonthlyOrderCounts
    WHERE
        order_count >= 2
    GROUP BY
        customer_id
    HAVING COUNT(DISTINCT order_month) = 6
)
SELECT
    customer_id
FROM
    CustomersWith2OrdersPerMonth;


--Find restaurants with revenue above the average restaurant revenue in their city.

WITH CityAvgRevenue AS (
    SELECT
        city,
        AVG(revenue) AS avg_city_revenue
    FROM
        ZomatoData
    GROUP BY
        city
)
SELECT
    z.restaurant_id,
    z.city,
    z.revenue,
    c.avg_city_revenue
FROM
    ZomatoData z
JOIN
    CityAvgRevenue c ON z.city = c.city
WHERE
    z.revenue > c.avg_city_revenue;

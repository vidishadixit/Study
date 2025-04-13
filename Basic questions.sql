-- Interview Questions

--1. write a query to find the secnd highest salary in emp table

select * from EMP_Salary
where salary = (select max(salary) from EMP_Salary
where SALARY<(select max(salary) from EMP_Salary))


select * from EMP_Salary
order by SALARY desc
offset 1 row
fetch next 1 row only

--2. Third highest

select * from EMP_Salary
where salary = (select max(salary) from EMP_Salary
where SALARY<(select max(salary) from EMP_Salary
where SALARY<(select max(salary) from EMP_Salary)))

select * from EMP_Salary
order by SALARY desc
offset 2 row
fetch next 1 row only

-- 3. fetch all employees whose names contain the letter a exactly twice

select * from EmployeeSalary
where LEN(NAME)-len(Replace(LOWER(Name), 'a' , ''))=2

select * from EmployeeSalary
where len(PARSENAME(REPLACE(name,' ', '.'), 2)) - len(replace(lower(PARSENAME(REPLACE(name, ' ' , '.'), 2)),'a', ' '))=2

--4. How do you retrieve only duplicate records

select CITY,count(*) from EmployeeSalary
group by CITY
having COUNT(*)>1

-- 5. write a query to calculate running total of sales by date

select 
	product,
	Account,
	sales_agent,
	sum(close_value) over (order by close_date) as Running_Total
from sales_pipeline
order by Running_Total desc

--6. find emp who earn more than the avg salary in their dept

WITH SalaryWithDeptAvg AS (
    SELECT 
        EID,
        DEPT,
        salary,
        AVG(salary) OVER (PARTITION BY dept) AS dept_avg_salary
    FROM EMP_Salary
)
SELECT *
FROM SalaryWithDeptAvg
WHERE salary > dept_avg_salary;

-- 7. Top Salary

select Top 1 Salary from EMP_Salary

with SR as (select
	EID,
	DEPT,
	Salary,
	Rank() over(order by salary desc) as rnk
from EMP_Salary)
select * from SR
where rnk = 1

-- 8.wite a query to find the most frequently occurring value in a column

select 
	--top 1
	dept,
	count(*) as Frequency
from EMP_Salary
group by DEPT
order by dept desc

--9. write a query to count how many employees share the same salary

select
	salary,
	count(*) as No_Emp
from EMP_Salary
group by 
	salary
having count(*) > 1

-- 10. how do you fetch the top 3 records for each group in a table

select * from
(select EID, DEPT, Desi, Salary, row_number() over (partition by dept order by salary desc) as rn from EMP_Salary) as ranked
where rn<=3

--11. retreive products that were never sold(hint:use left join)
SELECT p.*
FROM Product p
LEFT JOIN Orders o ON p.PID = o.PID
WHERE o.pid IS NULL;

select * from Product
select * from Orders
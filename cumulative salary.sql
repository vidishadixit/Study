select
	employeed_id,
	salary,
	sum(salary) over(order by employee_id) as cumulative_salary
from
	employee
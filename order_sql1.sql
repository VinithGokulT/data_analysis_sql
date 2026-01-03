--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,extract(year from order_date) as order_year,
sum(sale_price) as sales
from order1
group by sub_category,extract(year from order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select  *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc --limit 1
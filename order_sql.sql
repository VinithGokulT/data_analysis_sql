select * from order1

--1. find top 10 highest reveue generating products 

select product_id, sum(sale_price) revenue from order1 group by product_id order by revenue desc limit 10

--2. find top 5 highest selling products in each region
with cte as (
			select product_id, region, sum(sale_price) sales from order1 group by product_id, region 
			)
	select * from (
		select *, row_number() over(partition by region order by sales) ranking
		from cte )
	where ranking<=5

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte as (
			select extract(year from order_date ) order_year, extract(month from order_date) order_month, sum(sale_price) sales
			from order1 group by extract(year from order_date ) , extract(month from order_date)
			)
	select order_month,
	sum(case when order_year = 2022 then sales else 0 end) "2022_sales",
	sum(case when order_year = 2023 then sales else 0 end) "2023_sales"
	from cte 
	group by order_month
	order by order_month asc


-- trying

with cte as (
			select extract(year from order_date ) order_year, extract(month from order_date) order_month, sum(sale_price) sales
			from order1 group by extract(year from order_date ) , extract(month from order_date)
			)
	select order_month,order_year,
	(case when order_year = 2022 then sales else 0 end) "2022_sales",
	(case when order_year = 2023 then sales else 0 end) "2023_sales"
	from cte 
	--group by order_month
	order by order_month asc


--4. for each category which month had highest sales 
with cte as(
			select category, extract(month from order_date) order_month, 
			TO_CHAR(order_date, 'YYYYMM') AS order_year_month, sum(sale_price) sales
			from order1
			group by category, extract(month from order_date), TO_CHAR(order_date, 'YYYYMM')
			)
	select * from 
		(select *, row_number()over(partition by category order by sales desc) ranking
		from cte)
	where ranking =1

--select distinct category from order1


--5. which sub category had highest growth by profit in 2023 compare to 2022

with cte as (
			select sub_category, extract(year from order_date) order_year,sum(sale_price) sales
			from order1
			group by sub_category, extract(year from order_date)
			)
	,cte1 as(
			select sub_category,
			sum(case when order_year = 2022 then sales else 0 end) "sales_2022",
			sum(case when order_year = 2023 then sales else 0 end) "sales_2023"
			from cte
			group by sub_category
			)
	select *,
	(sales_2023- sales_2022) comparison
	from cte1
	order by sales_2023 - sales_2022 desc limit 1
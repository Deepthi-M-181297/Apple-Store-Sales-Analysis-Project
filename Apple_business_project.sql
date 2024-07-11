-- --------------------------------------------------------------------------
--Apple Business Problems
-- ---------------------------------------------------------------------------

select * from sales


--1. Rank products based on total sales revenue, showing the product name and its rank.

select 
	p.product_name,
	sum(s.sale) as Total_sales,
	dense_rank()over(order by sum(s.sale) desc) as rank
from sales s
join products p
on s.product_id = p.product_id
group by 1


--2. Identify stores with the highest sales quantity, showing the store name and total quantity sold, ranked using dense_rank.

select 
	ss.store_name,
	sum(s.quantity) as total_qty_sold,
	dense_rank()over(order by sum(s.quantity) desc) as rank
from store ss
join sales s
on ss.store_id = s.store_id
group by 1

--3. Calculate total sales amount for each month across all stores.
-- select * from sales
select 
	ss.store_name,
	extract(year from s.saledate) as year,
	extract(month from s.saledate) as month_num,
	to_char(s.saledate,'Month') as month,	
	sum(s.sale) as total_sales
from store ss
join sales s
on ss.store_id = s.store_id
group by 1,2,3,4
order by 1,2,3

--4. Calculate the profit margin (profit as a percentage of revenue) for each product,showing the product name and profit margin.
select * from sales
select 
	p.product_name,
	sum(s.profit / s.sale) * 100 as profit_margin
from sales s
join products p
on s.product_id = p.product_id
group by 1

--5. Identify stores where the total sales quantity has decreased compared to the previous month, showing store details and sales quantities.
select * from store
with cte1 as
(
select 
	s.store_id,
	ss.store_name,
	sum(s.quantity) as qty_current_month
from sales s
join store ss
on s.store_id = ss.store_id
where extract(month from saledate)='7'
group by 1,2
),
cte2 as
(
select 
	s.store_id,
	ss.store_name,
	sum(s.quantity) as qty_previous_month
from sales s
join store ss
on s.store_id = ss.store_id
where extract(month from saledate)='6'
group by 1,2
)

select 
	cte1.store_id,
	cte1.store_name,
	cte1.qty_current_month,
	cte2.qty_previous_month
from cte1
join cte2
on cte1.store_id = cte2.store_id
where qty_current_month < qty_previous_month

--6.Identifying Products with Seasonal Demand. List products with sales quantities that peak during certain months of the year, showing product details and peak months.
--select * from products
select 
	product_name,
	month,
	total_sale_qty
from
(
select 
	p.product_name,
	extract(month from s.saledate) as month,
	sum(s.quantity) as total_sale_qty,
	row_number()over(partition by product_name order by sum(s.quantity) desc)as dnk
from sales s
join products p 
on s.product_id = p.product_id
group by 1,2
)as s1

--7.Rank stores based on their average monthly sales revenue, showing store details and ranking using row number.
--select * from store
select 
	ss.store_name,
	extract(month from s.saledate),
	avg(s.sale)as total_revenue,
	row_number()over(partition by ss.store_name order by avg(s.sale) desc) as rn
from sales s
join store ss
on s.store_id = ss.store_id
group by 1,2
/*
select store_name,count(store_name)
from store
group by 1
having count(*) > 1
*/

--8. Calculate monthly growth % (based on profit) for each store between 2019 and 2020
select 
	ss.store_name,
	extract(month from s.saledate) as month,
	sum(s.profit) as total_profit
from sales s
join store ss
on s.store_id = ss.store_id
where extract(year from saledate) between '2019' and '2020'
group by 1,2

--9.Identify geographical regions with the highest sales

select 
	ss.country,	
	ss.city,
	sum(s.sale) as sale_by_region
from sales s
join store ss
on s.store_id = ss.store_id
group by 1,2 
order by 3
limit 1


















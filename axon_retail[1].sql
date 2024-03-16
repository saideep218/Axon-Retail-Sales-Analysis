-- AXON RETAIL CLASSIC CARS SALES ANALYSIS

-- 1.what are the total sales over years?

select year(order_date) as years,sum(quantity_ordered*unit_price) as Sales,count(order_status) as 'no of orders'
from order_details od
inner join orders o on o.order_id = od.order_id
inner join products p on p.product_id = od.product_id
where order_status in('shipped','in process')
group by 1
order by 1; 
-- The sales were high in the year 2004 whivh is about 4300603 and least in the year 2005 which is about 147667.and there is a 
-- relation with orders and sales when the orders were high there is increase in sales.

-- 2. Total Sales by products on 2004 and 2005
with total_sales as(
select product_name,
sum(case when year(order_date) = 2004 then (quantity_ordered*unit_price) else 0 end) Sales_2004,
sum(case when year(order_date) = 2005 then (quantity_ordered*unit_price) else 0 end) Sales_2005
from products p 
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
group by 1)
select product_name,sales_2004,sales_2005,((sales_2005 - sales_2004)*100/sales_2004) as growth_sales from total_sales
order by 4 ; 
-- All the growth sales are led to decrease, shown by a negative. 
--  there is no single product in growth compare to 2004 every product is 
--   outperforming 
--  2001 Ferrari Enzo ,1969 Ford Falcon are drop in sales by 3 times the previous sales and so on

-- 3.Customers Transactions per Year

select year(order_date) as years,count(distinct customer_id) as 'no of customers' from orders o
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
group by 1;

-- In the year 2004 there is increase in transcations by customers upto 15 but in the 2005 the transcations was dropped nearly low than the 2003 sales


-- 4. New customers over the years

with first as (
select customer_id,min(order_date) as first_order from orders o
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
where order_status in('shipped','in process')
group by 1)
select year(first_order) as years,count(customer_id) as 'new customers' from first
group by 1;

-- The growth of new customers for each year is decreasing and there are only 25 new customers in the year 2005.

-- 5. list of products ordered by axon retailer with more quantities

with max_qty_ordered as (
select product_name,category,product_vendor as vendor,
qty_instock as qty
from products)
select product_name,vendor,qty from max_qty_ordered
order by qty desc; 

-- 2002 Suzuki XREO was in the top of quantity ordered by vendor followed by 2002 Chevy Corvette which are up to 9997 units.
-- 1960 BSA Gold Star DBD34 was the lowest in quantity ordered by only 15 units.

-- 6. what are the top 10 products ordered the most by customers?

select product_name,sum(quantity_ordered) as qty_ordered from order_details od 
inner join orders o on o.order_id = od.order_id 
inner join products p on p.product_id = od.product_id
group by 1
order by 2 desc;

-- 1992 Ferrari 360 Spider red was ordered most by customers of 1808 units and 1956 Porsche 356A Coupe of 1052 units.
-- 1956 Porsche 356A Coupe was in the least of quantity ordered of 1052 units

-- 7 list the office collections country wise 

select o.country,sum(quantity_ordered*unit_price) as revenue from offices o 
inner join employees e on e.office_id = o.office_id
inner join customers c on c.emp_id = e.emp_id
inner join orders ods on ods.customer_id = c.customer_id
inner join order_details od on od.order_id = ods.order_id
inner join products pr on pr.product_id = od.product_id
group by 1
order by 2 desc;

-- The highest revenue was generated by USA which 3479191.91, then followed by France.
-- The lowest revenue was coming from Japan which is 457110.

-- 8. Report those who made payments greater than $100,000.

select customer_name,sum(amount) as payments from payments p 
inner join customers c on c.customer_id = p.customer_id 
inner join orders o on o.customer_id = c.customer_id 
inner join order_details od on od.order_id = o.order_id
inner join products pr on pr.product_id = od.product_id
where amount > 100000
group by 1
order by 2 desc;

-- The customer Euro + shopping channel had made payments of 61221119.
-- The mini gifts distributors ltd. and dragon souvenirs’ ltd. Stands at 2 and 3.
-- There are only 3 customers who made payments greater than 1,00,000

-- 9. What is the average shipping time?

SELECT round(Avg(DATEDIFF(Shipped_date,Order_date))) AS Avg_shipping_Time
FROM Orders o inner join order_details od on od.order_id = o.order_id 
inner join products p on p.product_id = od.product_id
where Shipped_date is not null;

-- The average shipping time is 4 days.

select * from pizza_sales;

-- Total Revenue
Select Round(sum(total_price),2) as Total_Revenue from pizza_sales;


-- Avg Order Value
Select round(sum(total_price) / count(Distinct(order_id)),2) as Avg_Order_Value from pizza_sales;


--Total Pizza Sold
select sum(quantity) as Total_Pizza_Sold from pizza_sales;


--Total Orders
select count(distinct(order_id)) As Total_Orders from pizza_sales;


--Average quantity per order
select cast(cast (sum(quantity)as decimal(10,2))/cast(count(distinct(order_id))as decimal(10,2)) as decimal(10,2)) from pizza_sales;


--Total Order per day
select datename(dw,order_date) as order_day , count(distinct(order_id)) as total_order from pizza_sales
group by datename(dw,order_date);


--Total Order per month
select datename(month,order_date)as order_month, count(distinct(order_id)) as total_order from pizza_sales
group by datename(month, order_date)
order by total_order desc;

-- Total sales per category
select pizza_category ,sum(total_price) as total_price, sum(total_price) * 100 /(select sum(total_price) from pizza_sales) as PCT
from pizza_sales
group by pizza_category
order by PCT desc;


--Total sales per size
select pizza_size ,round(sum(total_price),2) as total_sales, cast(sum(total_price) * 100 /(select sum(total_price) from pizza_sales) as decimal (10,2)) as PCT
from pizza_sales
group by pizza_size 
order by PCT desc;


-- Top 5 seller by revenue,orders,quantity
select top 5 pizza_name, sum(total_price) as total_price from pizza_sales
group by pizza_name
order by sum(total_price) desc;

select top 5 pizza_name, count(distinct(order_id)) as total_orders from pizza_sales
group by pizza_name
order by total_orders desc;

select top 5 pizza_name, sum(quantity) as total_quantity from pizza_sales
group by pizza_name
order by total_quantity desc;  



-- Bottom 5 seller by revenue,orders,quantity

select top 5 pizza_name, round(sum(total_price),2) as total_price from pizza_sales
group by pizza_name
order by sum(total_price) ;

select top 5 pizza_name, count(distinct(order_id)) as total_orders from pizza_sales
group by pizza_name
order by total_orders ;

select top 5 pizza_name, sum(quantity) as total_quantity from pizza_sales
group by pizza_name
order by total_quantity ; 
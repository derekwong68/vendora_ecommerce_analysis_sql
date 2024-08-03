--quarterly sales trend for Macbooks sold in North America across all years
--show number of region, orders, total sales, aov
select date_trunc(orders.purchase_ts, quarter) as purchase_quarter,
  geo_lookup.region as region,
  count(distinct orders.id) as order_count,
  round(sum(orders.usd_price),2) as total_sales,
  round(avg(orders.usd_price),2) as aov
from `vendora-431118.vendora.orders` orders
--join customers data
left join `vendora-431118.vendora.customers` customers
  on orders.customer_id = customers.id
--join geo_lookup data
left join `vendora-431118.vendora.geo_lookup` geo_lookup
  on geo_lookup.country = customers.country_code
--find Macbooks sold in North America
where lower(orders.product_name) like '%macbook%'
and region = 'NA'
group by 1,2
order by 1;

--Across 2019-2022, Vendora sold an average of 89 Macbooks to North American customers each quarter, with average quarterly sales of $143.5K. The average order price of these Macbooks was $1600.

--monthly refund rate for purchases made in 2020
--count the number of refunds per month (non-null refund date) and calculate the refund rate
--refund rate is equal to the total number of refunds divided by the total number of orders
select date_trunc(orders.purchase_ts, month) as month,
  sum(case when refund_ts is not null then 1 else 0 end) as refunds,
  sum(case when refund_ts is not null then 1 else 0 end)/count(distinct orders.id)*100 as refund_rate
from `vendora-431118.vendora.orders` orders
left join `vendora-431118.vendora.order_status` order_status
  on orders.id = order_status.order_id
where orders.purchase_ts between '2020-01-01' and '2020-12-31'
group by 1
order by 1;

--count the number of refunds, filtered to 2021
--only include products with 'apple' in the name - use lowercase to account for any differences in capitalization
select date_trunc(order_status.refund_ts, month) as month,
  sum(case when order_status.refund_ts is not null then 1 else 0 end) as refunds,
from `vendora-431118.vendora.orders` orders
left join `vendora-431118.vendora.order_status` order_status
  on orders.id = order_status.order_id
where order_status.refund_ts between '2021-01-01' and '2021-12-31' and lower(orders.product_name) like '%apple%'
group by 1
order by 1;


--Monthly refund rates of orders placed in 2020 ranged from 2-3%. In 2021, Apple products had 7 to 30 refunds per month, with the highest refunded-month being March 2021.

select sum(case when refund_ts is not null then 1 else 0 end) as refunds,
  sum(case when refund_ts is not null then 1 else 0 end)/(count(distinct orders.id)) as refund_rate
from `vendora-431118.vendora.orders` orders
left join `vendora-431118.vendora.order_status` order_status
  on orders.id = order_status.order_id
order by 2 desc;

--calculate refund rate across products
--order in descending order of refund rate to get the top 3 frequently refunded
select orders.product_name,
  sum(case when refund_ts is not null then 1 else 0 end) as refunds,
  sum(case when refund_ts is not null then 1 else 0 end)/(count(distinct orders.id)) as refund_rate
from `vendora-431118.vendora.orders` orders
left join `vendora-431118.vendora.order_status` order_status
  on orders.id = order_status.order_id
group by 1
order by 3 desc;

--order in descending order of refund count to get the top 3 refund count
select orders.product_name,
  sum(case when refund_ts is not null then 1 else 0 end) as refunds,
  sum(case when refund_ts is not null then 1 else 0 end)/(count(distinct orders.id)) as refund_rate
from `vendora-431118.vendora.orders` orders
left join `vendora-431118.vendora.order_status` order_status
  on orders.id = order_status.order_id
group by 1
order by 2 desc;

--The Thinkpad Laptop gets refunded the most at 17.6%, while the Macbook Air Laptop and Apple iPhone are the second and third most refunded items (16.7% and 11.6%). 
--However, this does not mean they have the highest number of refunds - the Apple Airpod Headphones have the highest count of refunds, at 3348 across all years. The gaming monitor and Macbook Air have 1824 and 564 refunds, respectively.


--aov and count of new customers by account creation channel in first 2 months of 2022
select customers.account_creation_method,
  avg(orders.usd_price) as aov,
  count(distinct customers.id) as num_customers,
  count(distinct purchase_ts) as num_products_sold
from `vendora-431118.vendora.orders` orders
join `vendora-431118.vendora.customers` customers
  on orders.customer_id = customers.id 
where created_on between '2022-01-01' and '2022-02-28'  
group by 1
order by 3 desc;

--Desktop had by far the most amount of new customers created in the first two months of 2022, with 2359 new customers compaared to 591 new customers on mobile. 
--Desktop-created accounts also make more expensive purchases, with an AOV of $231. 
--This AOV is lower than that of customers who created their account on tablets (AOV of $444), though there have only been 12 purchases made on tablets so far.




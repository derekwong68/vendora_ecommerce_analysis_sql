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


--quarterly sales trend for Macbooks sold in North America across all years
--show number of region, orders, total sales, aov
select date_trunc(orders.purchase_ts, quarter) as purchase_quarter,
  geo_lookup.region as region,
  count(distinct orders.id) as order_count,
  sum(orders.usd_price) as total_sales,
  avg(orders.usd_price) as aov
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

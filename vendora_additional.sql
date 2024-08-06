--What was the most often-bought product in 2020 in the APAC region?

select orders.product_name,
  count(orders.id) as order_count
from `vendora-431118.vendora.orders` orders
join `vendora-431118.vendora.customers`customers
  on orders.customer_id = customers.id
join `vendora-431118.vendora.geo_lookup` geo_lookup
  on geo_lookup.country = customers.country_code
where orders.purchase_ts between '2020-01-01' and '2020-12-31' and geo_lookup.region = 'APAC'
group by 1
order by 2 desc
limit 1;

Apple Airpods Headphones with 2656 sales

--Return the top marketing channel, ranked by which channel brings in the most expensive orders. 

--For each region, what’s the total number of orders and the total number of customers?

--Advanced: What’s the average time it takes for a customer to place their first order for customers in NA or APAC?

--Advanced: Of customers who bought an Apple product, how many of these orders were placed on the website?


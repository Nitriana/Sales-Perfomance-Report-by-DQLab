
---PROJECT DATA ANALYSIS: SALES PERFORMANCE REPORT

--Overall Performance by year---
SELECT 
YEAR([order_date] ) as years,
SUM(cast([sales] as bigint)) as sales,
SUM(cast([order_quantity] as bigint)) as number_of_order
FROM [Retail].[dbo].[dqlab-sales-store]
where [order_status] ='order finished'
group by YEAR([order_date])
order by YEAR([order_date]) asc;

--Menghitung year over year growth
With sales_store as 
(
SELECT YEAR(Order_date) as years,
SUM (Cast(sales as bigint)) as total_Sales,
LAG (SUM (cast(sales as bigint))) OVER (ORDER BY YEAR (ORDER_DATE)) AS previous_year
FROM [Retail].[dbo].[dqlab-sales-store]
where order_status = 'order finished'
GROUP BY YEAR (ORDER_DATE) 
)

Select years, total_sales, previous_year, CAST(100.0 * (total_Sales - previous_year) / previous_year AS DECIMAL(10, 2))  AS yoy_growth
from sales_store
order by years

--Overall performance by sub category product---
SELECT 
YEAR([order_date] ) as years,
[product_sub_category], 
SUM(CAST([sales] as bigint)) as sales
FROM [Retail].[dbo].[dqlab-sales-store]
where [order_status] ='order finished' and YEAR([order_date]) > 2010
group by YEAR([order_date]), product_sub_category
order by YEAR(order_date), sales desc;

--Calculate the burn rate of promotions by year
SELECT 
YEAR(order_date) as years,
SUM(cast(sales as decimal)) as sales, 
SUM(cast(discount_value as decimal)) as promotion_value,
ROUND((SUM(cast(discount_value as decimal))/ SUM (cast(Sales as decimal)))*100, 2) as burn_rate_percentage 
FROM [Retail].[dbo].[dqlab-sales-store]
Where order_status = 'Order Finished' 
group by YEAR(order_date)
order by YEAR(order_date) asc;

--Calculate the burn rate of promotion by sub-category
SELECT 
YEAR(order_date) as years,
product_sub_category, product_category,
SUM(cast(sales as decimal)) as sales, 
SUM(cast(discount_value as decimal)) as promotion_value,
ROUND((SUM(cast(discount_value as decimal))/ SUM (cast(Sales as decimal)))*100, 2) as burn_rate_percentage 
FROM [Retail].[dbo].[dqlab-sales-store]
Where order_status = 'Order Finished' and year(order_date) = '2012'
group by YEAR(order_date), product_sub_category,product_category
order by SUM(cast(sales as decimal)) desc;

--The number of customers who make transactions by year
SELECT 
YEAR(order_date) as years,
count(distinct customer) as number_of_customer
FROM [Retail].[dbo].[dqlab-sales-store]
Where order_status = 'Order Finished' 
group by YEAR(order_date)
order by year(order_date) asc;

---The new number of customers
SELECT YEAR(date_first_transaction) as years, COUNT(distinct customer) as new_number_of_customer
FROM
(Select customer, MIN(order_date) as date_first_transaction
FROM [Retail].[dbo].[dqlab-sales-store]
where order_status ='order finished'
group by customer) as table_a
group by YEAR(date_first_transaction)
order by YEAR(date_first_transaction);





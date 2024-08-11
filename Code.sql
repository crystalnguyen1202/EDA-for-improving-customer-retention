--1/ Ad-hoc tasks:
--1.1 Total number of buyers and number of orders completed per month (from 01/2019 – to 04/2022)
 SELECT
  FORMAT_TIMESTAMP('%Y-%m',created_at) AS month,
  COUNT(DISTINCT user_id) AS total_customer,
  COUNT(order_id) AS total_order
FROM
  bigquery-public-data.thelook_ecommerce.orders
WHERE
  created_at BETWEEN '2019-01-01' AND '2022-05-01'
  AND status = 'Complete'
GROUP BY month
ORDER BY month;

--1.2 Average order value (AOV) and number of customers per month
SELECT 
  FORMAT_TIMESTAMP('%Y-%m',created_at) AS year_month,
  COUNT(DISTINCT user_id) AS distinct_users,
  ROUND(SUM(sale_price)/COUNT(order_id),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE
  DATE(created_at) BETWEEN '2019-01-01' AND '2022-05-01'
  AND status = 'Complete'
GROUP BY year_month
ORDER BY year_month;

--1.3 Group of customers by age
WITH tab AS
(
SELECT
first_name,
last_name,
gender,
'oldest' as tag ,
MIN(age) OVER(PARTITION BY gender) AS age
FROM `bigquery-public-data.thelook_ecommerce.users` 
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age IN (SELECT MIN(age) 
             FROM `bigquery-public-data.thelook_ecommerce.users`)
UNION ALL
SELECT
first_name,	
last_name,
gender,
'youngest' as tag ,
MAX(age) OVER(PARTITION BY gender) AS age
FROM `bigquery-public-data.thelook_ecommerce.users` 
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age IN (SELECT MAX(age) 
             FROM `bigquery-public-data.thelook_ecommerce.users`)
ORDER BY age)

SELECT gender,age,tag, COUNT(*) AS num_of_customers
FROM tab
GROUP BY gender, age, tag
ORDER BY tag

--Diving customers by age into four main segments:
SELECT
gender,
segment,
COUNT(id) AS num_of_customers
FROM 
(
SELECT
gender,
id,
CASE
WHEN age BETWEEN 12 AND 19 THEN 'teenagers'
WHEN age BETWEEN 20 AND 34 THEN 'young adults'
WHEN age BETWEEN 35 AND 54 THEN 'middle-aged'
ELSE 'older adults'
END AS segment
FROM
bigquery-public-data.thelook_ecommerce.users
)
GROUP BY segment, gender
ORDER BY segment, gender

--1.4 Top 5 most profitable Products per Month
WITH tab AS
(
SELECT   
 FORMAT_TIMESTAMP('%Y-%m',o.created_at) AS year_month,
 p.id AS product_id,
 p.name AS product_name, 
 SUM(o.sale_price) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m',o.created_at)) AS sales,
 p.cost AS cost, 
 SUM(o.sale_price) OVER(PARTITION BY FORMAT_TIMESTAMP('%Y-%m',o.created_at)) - p.cost AS profit
FROM bigquery-public-data.thelook_ecommerce.products AS p JOIN bigquery-public-data.thelook_ecommerce.order_items AS o
ON p.id = o.product_id
WHERE
  DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
)
, tab2 AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY year_month ORDER BY profit DESC) AS profit_rank
FROM tab)
SELECT * FROM tab2 WHERE profit_rank <=5
ORDER BY year_month;

--1.5 Revenue at the current time for each category
SELECT 
FORMAT_TIMESTAMP('%Y-%m-%d', o.created_at) AS dates,
p.category AS product_categories,
ROUND(SUM(o.sale_price),2) AS revenue
FROM bigquery-public-data.thelook_ecommerce.products AS p JOIN bigquery-public-data.thelook_ecommerce.order_items AS o
ON p.id = o.product_id
WHERE
    CAST(FORMAT_TIMESTAMP('%Y-%m-%d', o.created_at) AS DATE) >= DATE_SUB('2022-04-15', INTERVAL 3 MONTH)
AND CAST(FORMAT_TIMESTAMP('%Y-%m-%d', o.created_at) AS DATE) <= '2022-04-15'
GROUP BY dates, product_categories 
ORDER BY dates;

--2/ Create metric & build a dashboard:
WITH tab AS
  (SELECT DISTINCT FORMAT_DATE('%Y-%m', o.created_at) AS MONTH,
                   extract(YEAR
                           FROM o.created_at) AS YEAR,
                   p.category AS product_category,
                   round(sum(oi.sale_price) OVER (PARTITION BY p.category
                                                  ORDER BY FORMAT_DATE('%Y-%m', o.created_at)),2) AS TPV,
                   count(*) OVER (PARTITION BY p.category
                                  ORDER BY FORMAT_DATE('%Y-%m', o.created_at)) AS TPO,
                                 round(sum(p.cost) OVER (PARTITION BY p.category
                                                         ORDER BY FORMAT_DATE('%Y-%m', o.created_at)),2) AS total_cost
   FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
   JOIN bigquery-public-data.thelook_ecommerce.orders AS o ON oi.order_id=o.order_id
   JOIN bigquery-public-data.thelook_ecommerce.products AS p ON oi.product_id=p.id
   ORDER BY MONTH)
SELECT MONTH,
       YEAR,
       product_category,
       TPV,
       TPO,
       round(((TPV-lag(TPV) OVER (PARTITION BY product_category
                                  ORDER BY MONTH))/ lag(TPV) OVER (PARTITION BY product_category
                                                                   ORDER BY MONTH))*100, 2)||'%' AS revenue_growth,
       round(((TPO-lag(TPO) OVER (PARTITION BY product_category
                                  ORDER BY MONTH))/ lag(TPO) OVER (PARTITION BY product_category
                                                                   ORDER BY MONTH))*100, 2)||'%' AS order_growth,
       total_cost,
       round(TPV-total_cost, 2) AS total_profit,
       round((TPV-total_cost)/total_cost, 2) AS profit_to_cost_ratio
FROM tab

--3/ Retention cohort analysis
WITH tab AS
(
SELECT user_id, amount, 
FORMAT_TIMESTAMP('%Y-%m', first_purchase_date) AS cohort_date,
date,
(EXTRACT(YEAR FROM date) - EXTRACT(YEAR FROM first_purchase_date))*12 + ((EXTRACT(MONTH FROM date) - EXTRACT(MONTH FROM first_purchase_date)) + 1) AS index
FROM
(SELECT 
user_id, 
sale_price AS amount,
MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date,
created_at AS date
FROM bigquery-public-data.thelook_ecommerce.order_items) AS a
)
, tab1 AS 
(
SELECT cohort_date, index,
COUNT(DISTINCT user_id) AS cnt,
SUM(amount) AS revenue
FROM tab
GROUP BY cohort_date, index
ORDER BY cohort_date, index
)
SELECT 
cohort_date,
SUM(CASE WHEN index = 1 THEN cnt ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN cnt ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN cnt ELSE 0 END) AS m3
FROM tab1
GROUP BY cohort_date
ORDER BY cohort_date

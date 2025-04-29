-- 1)
CREATE VIEW vw_ecommerce_analyst AS(
WITH cte AS (SELECT
FORMAT_TIMESTAMP('%Y-%m',a.created_at) AS month,
EXTRACT(YEAR FROM a.created_at) AS year,
b.category AS product_category,
ROUND(SUM(a.sale_price),2) AS tpv,
COUNT(DISTINCT a.order_id) AS tpo,
ROUND(SUM(b.cost),2) AS total_cost
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b ON a.product_id=b.id
WHERE a.status = 'Complete'
GROUP BY 1,2,3)
SELECT *,
ROUND(100*(tpv-LAG(tpv) OVER(PARTITION BY product_category ORDER BY month))/LAG(tpv) OVER(PARTITION BY product_category ORDER BY month),2)||'%' AS revenue_growth,
ROUND(100*(tpo-LAG(tpo) OVER(PARTITION BY product_category ORDER BY month))/LAG(tpo) OVER(PARTITION BY product_category ORDER BY month),2)||'%' AS order_growth,
(tpv-total_cost) AS total_profit,
ROUND((tpv-total_cost)/total_cost,2) AS profit_to_cost_ratio
FROM cte
ORDER BY product_category, monthmonth)

-- 2)
WITH cte AS (SELECT
FORMAT_TIMESTAMP('%Y-%m',first_purchase_date) AS cohort_date,
user_id,
(EXTRACT(year FROM created_at)-EXTRACT(year FROM first_purchase_date))*12
+ (EXTRACT(month FROM created_at)-EXTRACT(month FROM first_purchase_date))+1 AS index
FROM (SELECT
user_id,
created_at,
MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date -- id, ngày mua hàng, ngày đầu mua
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Complete'))
,cohort AS(SELECT DISTINCT cohort_date,
index,
COUNT(user_id) AS total_user
FROM cte
WHERE index<=4
GROUP BY 1,2)
,customer_cohort AS (SELECT cohort_date,
SUM(CASE WHEN index = 1 THEN total_user ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN total_user ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN total_user ELSE 0 END) AS m3,
SUM(CASE WHEN index = 4 THEN total_user ELSE 0 END) AS m4
FROM cohort
GROUP BY 1
ORDER BY 1)
,retention_cohort AS (SELECT cohort_date,
ROUND(100.00*m1/m1,2)||'%' AS m1,
ROUND(100.00*m2/m1,2)||'%' AS m2,
ROUND(100.00*m3/m1,2)||'%' AS m3,
ROUND(100.00*m4/m1,2)||'%' AS m4
FROM customer_cohort
ORDER BY 1)
SELECT cohort_date,
ROUND(100-100.00*m1/m1,2)||'%' AS m1,
ROUND(100-100.00*m2/m1,2)||'%' AS m2,
ROUND(100-100.00*m3/m1,2)||'%' AS m3,
ROUND(100-100.00*m4/m1,2)||'%' AS m4
FROM customer_cohort
ORDER BY 1

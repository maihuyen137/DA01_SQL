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



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
MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date
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
-- Insight:
- Số lượng khách mới tăng đều qua thời gian: Tháng 1/2019 có 1 khách mới, đến tháng 4/2022 tăng lên 259 khách
- Tỷ lệ quay lại mua hàng (retention) rất thấp: Hầu hết các cohort chỉ có 1–2 người quay lại ở M2, M3, M4
- Một số tháng có hiệu quả giữ chân tốt hơn: 3/2021 có 2 người quay lại trong M2, 3 người ở M3, 1 ở M4
- Giải pháp:
+ Tối ưu trải nghiệm mua hàng đầu tiên:
  Gửi email follow-up sau lần mua đầu để nhắc nhở/hỏi cảm nhận.
  Tặng coupon cho đơn tiếp theo trong vòng 30 ngày.
+ Chạy chương trình chăm sóc khách hàng trong 3 tháng đầu:
  Email/SMS với sản phẩm liên quan đến lần mua đầu; 
  Ưu đãi độc quyền cho "khách hàng mới".
+ Phân tích các cohort có retention tốt, làm rõ nguyên nhân và tái áp dụng chiến dịch đó cho các cohort sau
+ Tích điểm, tặng quà sinh nhật, miễn phí vận chuyển cho lần mua tiếp theo,...

-- 1)
SELECT
productline,
year_id,
dealsize,
SUM(sales) AS revenue
FROM sales_dataset_rfm_prj
WHERE status = 'Shipped'
GROUP BY productline,
year_id,
dealsize
ORDER BY productline, year_id;

-- 2)
WITH monthly_sales AS (SELECT year_id, month_id,
SUM(sales) AS revenue,
COUNT(DISTINCT ordernumber) AS order_number
FROM sales_dataset_rfm_prj
WHERE status = 'Shipped'
GROUP BY year_id, month_id)
,ranking AS (SELECT *,
RANK() OVER(PARTITION BY year_id ORDER BY revenue DESC) AS ranking
FROM monthly_sales)
SELECT year_id||'-'||month_id AS month_id,
revenue, order_number
FROM ranking
WHERE ranking = 1;

-- 3)
WITH revenue AS (SELECT year_id, month_id,
productline,
SUM(sales) AS revenue,
COUNT(DISTINCT ordernumber) AS order_number
FROM sales_dataset_rfm_prj
WHERE month_id=11
AND status = 'Shipped'
GROUP BY productline, year_id, month_id),
ranking AS (SELECT *,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY revenue DESC) AS ranking
FROM revenue)
SELECT year_id||'-'||month_id AS month_id,
productline,
revenue, order_number
FROM ranking
WHERE ranking = 1;

-- 4)
WITH revenue_UK AS (SELECT year_id,
productline,
SUM(sales) AS revenue
FROM sales_dataset_rfm_prj
WHERE country='UK'
AND status = 'Shipped'
GROUP BY year_id, productline)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY revenue DESC) AS rank
FROM revenue_UK;

-- 5) không có id nên em thêm sdt lỡ tên giống ạ
WITH customer_rfm AS
(SELECT customername,
phone,
current_date - MAX(orderdate) AS R,
COUNT(DISTINCT ordernumber)/NULLIF(DATE_PART('day', MAX(orderdate) - MIN(orderdate)), 0) AS F,
SUM(sales) AS M
FROM sales_dataset_rfm_prj
GROUP BY customername, phone),
rfm_score AS
(SELECT customername, phone,
ntile(5) OVER(ORDER BY R DESC) AS R_score,
ntile(5) OVER(ORDER BY F DESC) AS F_score,
ntile(5) OVER(ORDER BY M DESC) AS M_score
FROM customer_rfm),
rfm AS
(SELECT customername, phone,
CAST(R_score AS varchar)||CAST(F_score AS varchar)||CAST(M_score AS varchar) AS rfm_score
FROM rfm_score),
segment AS
(SELECT a.customername, a.phone,
b.segment
FROM rfm AS a
JOIN segment_score AS b ON a.rfm_score=b.scores
ORDER BY b.segment)
SELECT * FROm segment
WHERE segment = 'Champions'

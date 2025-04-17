-- Ex1:
WITH job_count AS
(SELECT company_id, title, description,
COUNT (job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT (DISTINCT company_id) AS duplicate_companies
FROM job_count
WHERE job_count>1;

-- Ex2:
WITH total_spend AS
(SELECT category, product,
SUM(spend) AS total_spend,
RANK() OVER
(PARTITION BY category
ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
GROUP BY category, product)
SELECT category, product, total_spend
FROM total_spend
WHERE ranking<=2;

-- Ex3:
WITH call_count AS
(SELECT policy_holder_id,
COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3)
SELECT
COUNT(policy_holder_id) AS policy_holder_count
FROM call_count;

-- Ex4:
SELECT page_id FROM pages
WHERE page_id NOT IN (SELECT page_id FROM page_likes);

-- Ex5:
WITH active_users_last_mth AS
(SELECT user_id
FROM user_actions
WHERE event_type IN ('sign-in','like','comment')
AND EXTRACT(MONTH FROM event_date) =6
AND EXTRACT(YEAR FROM event_date)=2022)
SELECT
EXTRACT(MONTH FROM event_date) AS mth,
COUNT(DISTINCT user_id) AS monthly_active_users
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date)=7

SELECT 
TO_CHAR(trans_date,'YYYY-MM') AS month,
country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
SUM (amount) AS trans_total_amount,
SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amout
FROM Transactions
GROUP BY country,TO_CHAR(trans_date,'YYYY-MM')
AND EXTRACT(YEAR FROM event_date)=2022
AND user_id IN (SELECT user_id FROM active_users_last_mth)
GROUP BY EXTRACT(MONTH FROM event_date);


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
AND EXTRACT(YEAR FROM event_date)=2022
AND user_id IN (SELECT user_id FROM active_users_last_mth)
GROUP BY EXTRACT(MONTH FROM event_date);

-- Ex6:
SELECT 
TO_CHAR(trans_date,'YYYY-MM') AS month,
country,
COUNT(*) AS trans_count,
SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
SUM (amount) AS trans_total_amount,
SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY TO_CHAR(trans_date,'YYYY-MM'),country;

-- Ex7:
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id,year) IN
(SELECT product_id, MIN (year)
FROM Sales
GROUP BY product_id);

-- Ex8:
SELECT customer_id 
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product);
mmnb
-- Ex9:
SELECT employee_id
FROM Employees
WHERE salary < 30000
AND manager_id NOT IN (SELECT employee_id FROM Employees)

-- Ex10: Bài này giống bài 1 ạ
-- Ex11:
WITH name AS
(SELECT b.name
FROM MovieRating AS a
JOIN Users AS b ON a.user_id=b.user_id
GROUP BY a.user_id, b.name
ORDER BY COUNT(*) DESC, b.name
LIMIT 1),
highest_avg_rating AS
(SELECT d.title
FROM MovieRating AS c
JOIN Movies AS d ON c.movie_id=d.movie_id
WHERE created_at BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY c.movie_id, d.title
ORDER BY AVG(c.rating) DESC, d.title
LIMIT 1)
SELECT name AS results FROM name
UNION ALL
SELECT title FROM highest_avg_rating

-- Ex12:
WITH ids AS
(SELECT requester_id AS id FROM RequestAccepted
UNION ALL
SELECT accepter_id AS id FROM RequestAccepted)
SELECT id,
COUNT(*) AS num
FROM ids
GROUP BY id
ORDER BY num DESC
LIMIT 1;

-- Ex1:
SELECT a.CONTINENT,
FLOOR(AVG(b.POPULATION))
FROM COUNTRY AS a
JOIN CITY AS b
ON a.CODE=b.COUNTRYCODE
GROUP BY a.CONTINENT;

-- Ex2:
SELECT
ROUND(SUM(CASE WHEN a.signup_action='Confirmed' THEN 1 ELSE 0 END)/COUNT (*)::DECIMAL,2)
FROM texts AS a
LEFT JOIN emails AS b
ON a.email_id=b.email_id;

-- Ex3:
SELECT b.age_bucket,
ROUND(100.00*SUM(CASE WHEN a.activity_type='open' THEN a.time_spent ELSE 0 END)/SUM(a.time_spent),2) AS open_perc,
ROUND(100.00*SUM(CASE WHEN a.activity_type='send' THEN a.time_spent ELSE 0 END)/SUM(a.time_spent),2) AS send_perc
FROM activities AS a
LEFT JOIN age_breakdown AS b
ON a.user_id=b.user_id
WHERE a.activity_type IN ('open','send')
GROUP BY b.age_bucket;

-- Ex4:
SELECT a.customer_id
FROM customer_contracts AS a
LEFT JOIN products AS b
ON a.product_id=b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category)=(SELECT COUNT(DISTINCT product_category) FROM products);

-- Ex5:
-- Ex7:
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.page_id IS NULL
ORDER BY a.page_id


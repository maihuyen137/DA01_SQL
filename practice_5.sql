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
SELECT mng.employee_id AS employee_id, mng.name AS name,
COUNT(emp.reports_to) AS reports_count,
ROUND(AVG(emp.age)) AS average_age
FROM Employees AS emp
LEFT JOIN Employees AS mng
ON emp.reports_to=mng.employee_id
GROUP BY mng.name
HAVING COUNT(emp.reports_to)>0
ORDER BY mng.employee_id

-- Ex6:
SELECT b.product_name,
SUM(a.unit) AS unit
FROM Orders AS a
JOIN Products AS b
ON a.product_id = b.product_id
WHERE MONTH(a.order_date)=2 AND YEAR(a.order_date)=2020
GROUP BY b.product_name
HAVING SUM(a.unit)>= 100;
  
-- Ex7:
SELECT a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.page_id IS NULL
ORDER BY a.page_id;

-- MID-COURSE TEST
-- Q1:
SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost -- 9.99

-- Q2:
SELECT
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	ELSE 'high'
END category,
COUNT (*)
FROM film
GROUP BY category -- 514

-- Q3:
SELECT a.title, a.length, c.name AS category_name
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY length DESC -- Phim dài nhất thuộc thể loại Sports - 184

-- Q4:
SELECT c.name AS category_name,
COUNT(*) AS so_luong
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
GROUP BY category_name
ORDER BY so_luong DESC -- Sports: 74 titles

-- Q5: Chị ơi câu này đáp án chị đưa là Susan Davids 54 movies nma có 2 Susan Davids có ator_id khác nhau ạ
SELECT a.first_name, a.last_name,
COUNT (b.film_id) AS so_luong
FROM actor AS a
JOIN film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY a.actor_id
ORDER BY so_luong DESC -- GINA DEGENERES: 42 movies

-- Q6:
SELECT
COUNT(a.address)
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id=b.address_id
WHERE b.customer_id IS NULL -- 4 dịa chỉ

-- Q7:
SELECT a.city,
SUM(d.amount) AS doanh_thu
FROM city AS a
JOIN address AS b ON a.city_id=b.city_id
JOIN customer AS c ON b.address_id=c.address_id
JOIN payment AS d ON c.customer_id=d.customer_id
GROUP BY a.city
ORDER BY doanh_thu DESC -- Cape Coral: 221.55

-- Q8: Đáp án chị đưa ra là doanh thu thấp nhất í ạ, còn đề bài là cao nhất
SELECT CONCAT(a.city,', ',e.country) AS city,
SUM(d.amount) AS doanh_thu
FROM city AS a
JOIN address AS b ON a.city_id=b.city_id
JOIN customer AS c ON b.address_id=c.address_id
JOIN payment AS d ON c.customer_id=d.customer_id
JOIN country AS e ON e.country_id=a.country_id
GROUP BY CONCAT(a.city,', ',e.country)
ORDER BY doanh_thu -- Tallahassee, United States: 50.85

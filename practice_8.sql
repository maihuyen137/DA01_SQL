-- Ex1:
WITH first_order AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS ranking
FROM Delivery)
SELECT
ROUND(100*SUM(CASE
WHEN order_date=customer_pref_delivery_date THEN 1 ELSE 0 
END)/COUNT(*),2) AS immediate_percentage
FROM first_order
WHERE ranking=1;

-- Ex2:
WITH login_date AS
(SELECT *,
LEAD(event_date) OVER(PARTITION BY player_id) AS next_login,
ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rank
FROM Activity)
SELECT
ROUND(SUM(CASE WHEN next_login-event_date=1 THEN 1
ELSE 0 END)/COUNT(*)::DECIMAL,2) AS fraction
FROM login_date
WHERE rank = 1;

-- Ex3:
SELECT
CASE
WHEN id%2=1 AND id+1 IN (SELECT id FROM Seat) THEN id+1
WHEN id%2=0 THEN id-1
ELSE id
END AS id,
student
FROM Seat
ORDER BY id;

-- Ex4:
WITH day_amount AS
(SELECT visited_on,
SUM(amount) AS amount
FROM Customer
GROUP BY visited_on)
SELECT visited_on,
SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
ROUND(AVG(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS average_amount
FROM day_amount
OFFSET 6;

-- Ex5:
WITH tiv AS
(SELECT tiv_2016,
COUNT(*) OVER(PARTITION BY tiv_2015) AS tiv_2015_count,
COUNT(*) OVER(PARTITION BY lat,lon) AS city_count
FROM Insurance)
SELECT ROUND(CAST(SUM(tiv_2016) AS DECIMAL),2) AS tiv_2016
FROM tiv
WHERE tiv_2015_count>1 AND city_count=1;
  
-- Ex6:
WITH top_salaries AS
(SELECT b.name AS Department, a.name AS Employee, a.salary AS Salary,
DENSE_RANK() OVER(PARTITION BY b.name ORDER BY a.salary DESC) AS rank
FROM Employee AS a
JOIN Department AS b ON a.departmentId=b.id)
SELECT Department, Employee, Salary
FROM top_salaries
WHERE rank<=3;

-- Ex7:
WITH total_weight AS
(SELECT *,
SUM(weight) OVER(ORDER BY turn) AS total_weight
FROM Queue)
SELECT person_name
FROM total_weight
WHERE total_weight<=1000
ORDER BY total_weight DESC
LIMIT 1;

-- Ex8:
WITH prices AS
(SELECT product_id,
FIRST_VALUE(new_price) OVER(PARTITION BY product_id ORDER BY change_date DESC) AS price
FROM Products
WHERE change_date<='2019-08-16')
SELECT DISTINCT product_id, price FROM prices
UNION ALL
SELECT product_id, 10 AS price FROM Products
WHERE Products.product_id NOT IN (SELECT product_id FROM prices);

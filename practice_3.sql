-- Ex1:
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name,3), ID
  
-- Ex2:
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM Users
ORDER BY user_id

-- Ex3:
SELECT manufacturer,
CONCAT('$',ROUND(SUM(total_sales)/10^6),' million') AS sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM((total_sales)/10^6) DESC, manufacturer

-- Ex4:
SELECT EXTRACT(month FROM submit_date) AS mth, product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id

-- Ex5:
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date)= 8 
AND EXTRACT(year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

-- Ex6:
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content)>15

-- Ex7:
SELECT activity_date AS day,
COUNT(DISTINCT(user_id)) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-27' AND '2019-07-28'
GROUP BY  activity_date

-- Ex8:
SELECT
COUNT(id) AS total_employees
FROM employees
WHERE EXTRACT(month FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(year FROM joining_date)=2022

-- Ex9:
SELECT
POSITION ('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah'

-- Ex10:
SELECT title,
SUBSTRING(title FROM LENGTH(winery)+2 FOR 4)::NUMERIC AS year
FROM winemag_p2
WHERE country = 'Macedonia'


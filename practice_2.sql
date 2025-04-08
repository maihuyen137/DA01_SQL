-- Ex1: Em dùng ID%2=0 bị lỗi ạ
SELECT DISTINCT CITY FROM STATION
WHERE MOD(ID,2)=0;

-- Ex2:
SELECT
COUNT(*) - COUNT(DISTINCT(CITY))
FROM STATION;

-- Ex3:

-- Ex4:
SELECT
ROUND (SUM(item_count*order_occurrences)::NUMERIC/SUM(order_occurrences),1)
FROM items_per_order

-- Ex5:
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill IN ('Python','Tableau','PostgreSQL')) =3
ORDER BY candidate_id

-- Ex6:
SELECT user_id,
MAX(DATE(post_date)) - MIN(DATE(post_date)) AS days_between
FROM posts
WHERE DATE(post_date) BETWEEN '01/01/2021' AND '12/31/2021' 
GROUP BY user_id
HAVING COUNT(post_id)>1
  
-- Ex7:
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

-- Ex8:
SELECT manufacturer,
COUNT (drug) AS drug_count,
ABS(SUM (total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC

-- Ex9:
SELECT * FROM Cinema
WHERE ID%2=1
AND description <> 'boring'
ORDER BY rating DESC

-- Ex10:
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt
FROM Teacher
GROUP BY teacher_id

-- Ex11:
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id

-- Ex12:
SELECT class FROM Courses
GROUP BY class
HAVING COUNT(student)>=5

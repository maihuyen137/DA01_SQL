-- Ex2:
SELECT
COUNT(*) - COUNT(DISTINCT(CITY))
FROM STATION;

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

-- Ex7:
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC


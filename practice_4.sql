-- Ex1:
SELECT
SUM(CASE 
  WHEN device_type = 'laptop' THEN 1 
  ELSE 0 
END) AS laptop_views,
SUM(CASE
  WHEN device_type IN ('phone','tablet') THEN 1
  ELSE 0
END) AS mobile_views
FROM viewership;

-- Ex2:
SELECT *,
CASE
    WHEN x+y>z AND y+z>x AND x+z>y THEN 'Yes'
    ELSE 'No'
END AS triangle
FROM Triangle

-- Ex3:
SELECT
ROUND(100.0*(SUM(CASE
  WHEN call_category = 'n/a' OR call_category IS NULL THEN 1
  ELSE 0
END))/COUNT (*),1) AS uncategorised_call_pct
FROM callers;

-- Ex4: Chị cho nhầm bài hay sao í ạ
SELECT name FROM Customer
WHERE NOT referee_id = 2
OR referee_id IS NULL

-- Ex5:
select survived,
SUM(CASE
    WHEN pclass=1 THEN 1
    ELSE 0
END) AS first_class,
SUM(CASE
    WHEN pclass=2 THEN 1
    ELSE 0
END) AS second_class,
SUM(CASE
    WHEN pclass=3 THEN 1
    ELSE 0
END) AS third_class
from titanic
GROUP BY survived

-- Ex1:
SELECT a.CONTINENT,
FLOOR(AVG(b.POPULATION))
FROM COUNTRY AS a
JOIN CITY AS b
ON a.CODE=b.COUNTRYCODE
GROUP BY a.CONTINENT;

-- Ex2:


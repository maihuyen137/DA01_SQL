-- Ex1:
SELECT NAME FROM CITY 
WHERE POPULATION > 120000
AND COUNTRYCODE = 'USA';

-- Ex2:
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN';

-- EX3: 
SELECT CITY, STATE FROM STATION;

-- Ex4:
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) IN ('A','E','I','O','U');
-- hoặc
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%';

-- Ex5:
SELECT DISTINCT CITY FROM STATION
WHERE RIGHT(CITY,1) IN ('a','e','i','o','u');

-- Ex6: 
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) NOT IN ('A','E','I','O','U');

-- Ex7:
SELECT name FROM Employee
ORDER BY name;

-- Ex8:
SELECT name FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id
  
-- Ex9: recyclable and low-fat products
SELECT product_id FROM Products
WHERE low_fats = 'Y'
AND recyclable = 'Y'
  
-- Ex10: find customer referee
SELECT name FROM Customer
WHERE NOT referee_id = 2
OR referee_id IS NULL
  
-- Ex11: big countries
SELECT name, population, area FROM World
WHERE area >= 3000000
OR population >= 25000000
  
-- Ex12: article views
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY id

-- Ex13: 
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

--Ex14:
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000
OR yearly_salary > 70000

-- Ex15:
SELECT advertising_channel FROM uber_advertising
WHERE money_spent > 100000
AND year = 2019


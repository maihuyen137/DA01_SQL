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
-- Ex12: 

-- 1) C ơi hôm qua e chạy ra 1 kq, nay lại ra kq khác. Vậy là ngta update lại số liệu ạ?
SELECT
FORMAT_TIMESTAMP('%Y-%m',created_at) AS month_year,
COUNT(user_id) AS total_user,
COUNT(order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Complete'
AND FORMAT_TIMESTAMP('%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY 1;
/* Insight: 
- Từ tháng 1/2019-4/2022, hầu như 1 khách hàng chỉ mua 1 đơn hàng; Tháng 10/2020, 1,6,7,11,12/2021, 1,4/2022: Có khách hàng mua nhiều hơn 1 đơn
- Về số lượng đơn và lượng khách:
+ Từ 01/2019 đến 04/2022, cả số người mua và số đơn hoàn thành đều tăng dần theo thời gian.
Có một số tháng bị giảm nhẹ, nhưng nhìn tổng thể là tăng trưởng ổn định.
+ Năm 2019: Số lượng người mua và đơn hàng tăng đều mỗi tháng, từ  người (1/2019) lên  người (12/2019).
Tăng trưởng mạnh mẽ, nhưng quy mô còn nhỏ, có một vài tháng giảm nhẹ (tháng 4, 6, 7).
+ Năm 2020: Số lượng người mua và đơn hàng tiếp tục tăng (tháng 1->8), 
có vài tháng giảm nhẹ (tháng 1 giảm nhẹ so với tháng 12/2019, tháng 9 và 12 giảm nhẹ so với tháng trước)
+ Năm 2021: Tiếp tục tăng nhanh, tháng 6, 12 có sự giảm nhẹ so với tháng trước. Tháng 11 đạt 285 người mua - 287 đơn 
+ Năm 2022: Tăng mạnh, tháng 2 giảm nhẹ, tháng 4/2022 đạt 305 người mua và 306 đơn.
*/

-- 2) Cái này lấy mình đơn hàng đã Complete thôi đúng ko ạ?
SELECT
FORMAT_TIMESTAMP('%Y-%m',a.created_at) AS month_year,
COUNT(DISTINCT a.user_id) AS  distinct_users,
SUM(b.sale_price)/COUNT(a.order_id) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.orders AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id = b.order_id
WHERE a.status = 'Complete'
AND FORMAT_TIMESTAMP('%Y-%m',a.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY 1;
/* Nhìn chung AOV của các tháng dao động chủ yếu trong khoảng 50-65.
+ Năm 2019, số lượng người mua nhìn chung tăng, có giảm nhẹ ở 1 vài tháng. Tháng 4 có 13 đơn nhưng AOV lớn nhất (~73,1),
Tháng 1 có 1 khách với AOV = 15,9 nhưng tháng 2 tăng lên AOV = 53,2 với 7 khách. Các tháng khác giá trị AOV dao động trong khoảng 47-69.
+ Năm 2020, số lượng khách tiếp tục tăng đều, đạt trung bình trên 100 khách mỗi tháng, AOV có dao động nhẹ quanh mức 50–60 USD.
+ Năm 2021, lượng khách hàng tăng vọt lên gần 300 khách/tháng, AOV ổn định ở mức trên 60 USD => khách hàng không chỉ tăng về số lượng mà còn duy trì mức chi tiêu tốt.
+ Đầu 2022, xu hướng tăng trưởng tiếp tục được giữ vững, với số lượng khách tháng 4/2022 đạt 305 người, và AOV giữ vững quanh 58–62 USD*/

-- 3)
WITH twt_age AS (SELECT gender,
MAX(age) AS max,
MIN(age) AS min
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 1),
customers AS (
SELECT first_name, last_name, gender, age,
'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age IN (SELECT min FROM twt_age)
UNION ALL
SELECT first_name, last_name, gender, age,
'oldest' AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE age IN (SELECT max FROM twt_age))
SELECT DISTINCT gender, age,
COUNT(*) OVER (PARTITION BY gender, age)
FROM customers;
/* Với khách hàng nam, trẻ nhất là 12 tuổi với 859 người, lớn nhất là 70 tuổi với 851 người
Với khách hàng nữ, trẻ nhất là 12 tuổi với 837 người, lớn nhất là 70 tuổi với 871 người*/

-- 4)
WITH products AS (SELECT
FORMAT_TIMESTAMP('%Y-%m',a.created_at) AS month_year,
a.product_id,
b.name AS product_name,
SUM(a.sale_price) AS sales,
COUNT(*)*AVG(b.cost) AS cost,
SUM(a.sale_price) - (COUNT(*)*AVG(b.cost)) AS profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id=b.id
WHERE a.status = 'Complete'
GROUP BY 1, 2, 3)
SELECT *,
DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
FROM products
QUALIFY rank_per_month <=5
ORDER BY month_year;

-- 5)
SELECT
DATE(a.created_at) AS dates,
b.category AS product_category,
SUM(a.sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id=b.id
WHERE DATE(a.created_at) BETWEEN '2020-01-15' AND '2020-04-15'
AND a.status='Complete'
GROUP BY 1,2
ORDER BY dates;

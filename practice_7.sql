-- Ex1:
WITH yearly_spend AS
(SELECT
EXTRACT(year FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_date) AS prev_year_spend
FROM user_transactions)
SELECT *,
ROUND(100*(curr_year_spend-prev_year_spend)/prev_year_spend,2) AS yoy_rate
FROM yearly_spend;

-- Ex2:
SELECT DISTINCT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC;

-- Ex3:
WITH ranking AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rank
FROM transactions)
SELECT user_id, spend, transaction_date
FROM ranking
WHERE rank=3;

-- Ex4:
WITH recent_date AS
(SELECT transaction_date,
user_id, product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rank
FROM user_transactions)
SELECT transaction_date, user_id,
COUNT(product_id) AS purchase_count
FROM recent_date
WHERE rank=1
GROUP BY transaction_date, user_id;

-- Ex5:
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;

-- Ex6:
WITH next_trans AS
(SELECT *,
LEAD(transaction_timestamp) OVER(PARTITION BY merchant_id ORDER BY transaction_timestamp) AS next_trans,
LEAD(amount) OVER(PARTITION BY merchant_id ORDER BY transaction_timestamp) AS next_amount,
LEAD(credit_card_id) OVER(PARTITION BY merchant_id ORDER BY transaction_timestamp) AS next_card_id
FROM transactions)
SELECT
SUM(CASE WHEN amount=next_amount AND credit_card_id=next_card_id
AND next_trans-transaction_timestamp<=INTERVAL '10 minutes' THEN 1
ELSE 0 END) AS payment_count
FROM next_trans;
  
-- Ex7:
WITH total_spend AS
(SELECT category, product,
SUM(spend) AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS rank
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
GROUP BY category, product)
SELECT category, product, total_spend
FROM total_spend
WHERE rank<=2

-- Ex8:
WITH ranking AS
(SELECT a.artist_name,
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS artist_rank
FROM artists AS a
JOIN songs AS b ON a.artist_id=b.artist_id
JOIN global_song_rank AS c ON b.song_id=c.song_id
WHERE rank<=10
GROUP BY a.artist_name)
SELECT * FROM ranking
WHERE artist_rank<=5

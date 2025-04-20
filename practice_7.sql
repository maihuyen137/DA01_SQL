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

-- Ex5:
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tưeets;

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

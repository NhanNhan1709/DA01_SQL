--Ex1 
WITH year_spend AS (
SELECT 
  product_id,
  spend AS curr_year_spend,
  EXTRACT (YEAR FROM transaction_date) AS Y, 
  LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id) AS prev_year_spend 
FROM user_transactions) 

SELECT Y,
product_id, 
curr_year_spend,
prev_year_spend, 
ROUND(100*(curr_year_spend -prev_year_spend)/prev_year_spend,2) AS year_growth_rate
FROM year_spend; 

--Ex2 
-- CACH 1 : 
SELECT DISTINCT card_name, 
FIRST VALUE (issued_amount) OVER(PARTITION BY card_name ORDER BY CONCAT(issue_year,issue_month,'01')) as amount
FROM monthly_cards_issued
ORDER BY amount DESC;

-- CACH 2 : 
WITH cte AS (
SELECT issue_month,
card_name, 
first_value (issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued ) 

SELECT card_name,
issued_amount
FROM cte 
GROUP BY card_name, issued_amount 
ORDER BY issued_amount  DESC
  

--Ex3 
WITH trans_num AS (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS ranking
  FROM transactions)
 
SELECT 
  user_id, 
  spend, 
  transaction_date 
FROM trans_num 
WHERE ranking = 3;

--Ex4 
WITH transaction_new AS (
SELECT *, 
COUNT(product_id) OVER(PARTITION BY user_id ORDER BY transaction_date) AS purchase_count,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) AS ranking
FROM user_transactions) 

SELECT 
transaction_date, 
user_id,
purchase_count
FROM transaction_new 
WHERE ranking = 1 

--Ex5 
WITH cte1 AS (
SELECT user_id,
tweet_date,
tweet_count AS cur_tweet,
LAG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) AS before_date 
FROM tweets)
,
cte2 AS (
SELECT user_id,
tweet_date,
cur_tweet,
before_date,
LAG(before_date) OVER (PARTITION BY user_id ORDER BY tweet_date),
COALESCE(cur_tweet,0) + COALESCE(before_date,0) + COALESCE(LAG(before_date) OVER (PARTITION BY user_id ORDER BY tweet_date),0) AS sum,
row_number () OVER(PARTITION BY user_id ORDER BY tweet_date) AS rank 
FROM cte1) 
  


--Ex6 
WITH cte AS (
SELECT merchant_id,
credit_card_id,
amount, 
transaction_timestamp,
EXTRACT (hour FROM transaction_timestamp - LAG(transaction_timestamp) OVER 
                    (PARTITION BY merchant_id, credit_card_id, amount))*60 + EXTRACT (minute FROM transaction_timestamp - LAG(transaction_timestamp) OVER 
                    (PARTITION BY merchant_id, credit_card_id, amount)) AS time
                    
FROM transactions)

SELECT 
COUNT(*) AS payment_count
FROM cte 
WHERE time <=10 

--Ex7 
SELECT *
FROM 
(SELECT
category,
product,
SUM(spend)  AS total_spend,
RANK() OVER( PARTITION BY category ORDER BY SUM(spend) DESC ) AS RANKING
FROM product_spend
WHERE EXTRACT( 'year' FROM transaction_date) = 2022
GROUP BY category, product) AS ss
WHERE ranking <= 2

--Ex8 
WITH top_10 AS (
  SELECT 
    a.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(b.song_id) DESC) AS artist_rank
  FROM artists AS a 
  INNER JOIN songs AS b 
    ON a.artist_id = b.artist_id
  INNER JOIN global_song_rank AS c
    ON b.song_id = c.song_id
  WHERE c.rank <= 10
  GROUP BY a.artist_name
)

SELECT artist_name, artist_rank
FROM top_10
WHERE artist_rank <= 5;


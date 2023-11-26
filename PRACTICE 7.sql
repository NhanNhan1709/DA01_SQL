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
SELECT DISTINCT card_name, 
FIRST VALUE (issued_amount) OVER(PARTITION BY card_name ORDER BY CONCAT(issue_year,issue_month,'01')) as amount
FROM monthly_cards_issued
ORDER BY amount DESC;

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

--Ex5 Cách tính rolling average tweet count by 3-day period 


--Ex6 
 WITH A AS (
SELECT 
  *,
  LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp)
  AS previous_transaction,
  RIGHT(transaction_timestamp - LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp),1) AS time_difference
FROM transactions;) 

SELECT COUNT(merchant_id) AS payment_count
FROM A
WHERE minute_difference <= 10;

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


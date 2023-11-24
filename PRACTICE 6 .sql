--Ex1 
WITH job_count AS (
SELECT 
  company_id, 
  title, 
  description, 
  COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id,title, description) 

SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_count
WHERE job_count > 1;

--Ex2 
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

--Ex3 Không chạy ra bảng dữ liệu 


--Ex4 
SELECT 
a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id 
WHERE b.liked_date IS NULL
ORDER BY a.page_id ASC

--Ex6 
SELECT 
 LEFT(trans_date,7) as month, 
 country, 
 COUNT(*) AS trans_count,
 SUM(
     CASE 
       WHEN state = 'approved' THEN 1 ELSE 0
     END) AS approved_count, 
 SUM(amount) AS trans_total_amount, 
 SUM( 
     CASE 
       WHEN state = 'approved' THEN amount ELSE 0
       END) AS approved_total_amount
FROM Transactions
GROUP BY month, country

--Ex7 
SELECT 
product_id, 
year as first_year, 
quantity,
price
FROM Sales
GROUP BY product_id
HAVING MIN(year)

--Ex8 
SELECT customer_id FROM customer 
GROUP BY 
customer_id
HAVING COUNT(DISTINCT product_key ) = (SELECT COUNT(product_key ) FROM product)

--Ex9 
SELECT 
employee_id 
FROM employees 
WHERE salary < 30000 AND manager_id NOT IN (SELECT employee_id FROM Employees)

--Ex10 Trùng bài 1 

--Ex11 
(SELECT name
FROM users AS a
JOIN MovieRating AS b
ON a.user_id = b.user_id
WHERE RATING = 5 )

UNION

(SELECT title
FROM Movies AS a
JOIN MovieRating AS b
ON a.movie_id = b.movie_id
WHERE RATING = 5 )

--Ex12 
SELECT id, 
COUNT(*) as number_friends
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id FROM RequestAccepted ) as total
 GROUP BY id 
ORDER BY number_friends DESC 
LIMIT 1;




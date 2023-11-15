---PRACTICE 5 
--Ex1: 
SELECT b.continent, 
FLOOR(AVG(a.population))
FROM CITY AS a 
JOIN COUNTRY AS b 
ON a.countrycode=b.code
GROUP BY b.continent

--Ex2 ( lúc làm tròn và chuyển decimal dùng hàm ROUND(CAST(COUNT(b.email_id)/COUNT(a.email_id) AS DECIMAL),2) -> ko đúng ??? 
SELECT 
  ROUND(COUNT(b.email_id)/COUNT(a.email_id) :: DECIMAL,2) AS activation_rate 
FROM emails AS a
LEFT JOIN texts AS b
  ON a.email_id = b.email_id
  AND b.signup_action = 'Confirmed';

--Ex3 ( hiểu phải tính tổng thời gian spend/ tổng thời gian và tổng thời gian open/tổng thời gian nhưng ko biết diễn giải phải tham khảo đáp án dùng hàm FILTER ) 
SELECT 
b.age_bucket,
ROUND(100.0 * SUM(a.time_spent) FILTER (WHERE a.activity_type = 'send')/
      SUM(a.time_spent),2) AS send_perc ,
ROUND(100.0 * SUM(a.time_spent) FILTER (WHERE a.activity_type = 'open')/
      SUM(a.time_spent),2) AS open_perc
FROM activities AS a 
JOIN age_breakdown AS b 
ON a.user_id = b.user_id
WHERE a.activity_type IN ('send', 'open') 
GROUP BY b.age_bucket;

--Ex4 

SELECT 
a.customer_id
FROM customer_contracts AS a  
LEFT JOIN products AS b 
ON a.product_id = b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) >=3 

--Ex5 

SELECT 
a.employee_id,
a.name,
COUNT(b.employee_id) AS report_count, 
ROUND(AVG(b.age)) AS average_age 
FROM Employees AS a
LEFT JOIN Employees AS b 
ON a.employee_id = b.reports_to 

--Ex6 
SELECT 
a.product_name, 
SUM(b.unit) AS unit 
FROM Products AS a 
LEFT JOIN Orders AS b 
ON a.product_id = b.product_id 
WHERE MONTH(b.order_date) = '02' AND YEAR(b.order_date) = '2020'
GROUP BY a.product_name
HAVING SUM(b.unit) >= 100 

--Ex7 
SELECT 
a.page_id
FROM pages AS a
LEFT JOIN page_likes AS b
ON a.page_id = b.page_id 
WHERE b.liked_date IS NULL
ORDER BY a.page_id ASC


-----MID COURSE TEST 

--Q1 
TASK : 
SELECT
DISTINCT replacement_cost 
FROM film;

SELECT
min(replacement_cost)
FROM film;

--Q2 




































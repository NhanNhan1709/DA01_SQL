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
SELECT 
COUNT(film_id),
CASE 
  WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1
  WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 2
  WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 3
  ELSE 0 
END AS chi_phi 
FROM film
GROUP BY chi_phi 

--Q3 
SELECT
a.title,
a.length,
c.name 
FROM film AS a 
JOIN film_category AS b 
ON a.film_id = b.film_id
JOIN category AS c 
ON b.category_id=c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY a.length DESC

--Q4
SELECT
c.name, 
COUNT(a.title) AS so_luong_phim
FROM film AS a 
JOIN film_category AS b 
ON a.film_id = b.film_id
JOIN category AS c 
ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY so_luong_phim DESC

--Q5 
SELECT
c.first_name || ' '|| c.last_name AS HO_VA_TEN,
COUNT(a.title) AS so_luong_phim_tham_gia
FROM film AS a 
JOIN film_actor AS b 
ON a.film_id = b.film_id
JOIN actor AS c 
ON b.actor_id=c.actor_id
GROUP BY HO_VA_TEN
ORDER BY so_luong_phim_tham_gia DESC

--Q6 KHÔNG HIỂU ĐỀ 
SELECT 
a.address_id
FROM customer AS a 
LEFT JOIN address AS b 
ON a.address_id=b.address_id
WHERE b.address IS NULL

--Q7 
SELECT 
d.city,
SUM(a.amount) AS doanh_thu
FROM payment AS a
JOIN customer AS b 
ON a.customer_id = b.customer_id
JOIN address AS c 
ON b.address_id = c.address_id
JOIN city AS d 
ON c.city_id = d.city_id
GROUP BY d.city 
ORDER BY doanh_thu DESC

--Q8 : KHÔNG HIỂU ĐỀ 
SELECT 
d.city || ',' || e.country AS noi_chon,
SUM(a.amount) AS doanh_thu
FROM payment AS a
JOIN customer AS b 
ON a.customer_id = b.customer_id
JOIN address AS c 
ON b.address_id = c.address_id
JOIN city AS d 
ON c.city_id = d.city_id
JOIN country AS e 
ON d.country_id = e.country_id
GROUP BY noi_chon
ORDER BY doanh_thu DESC

 



































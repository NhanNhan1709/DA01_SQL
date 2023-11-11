-EX1: 
SELECT Name
FROM STUDENTS
WHERE Marks >75
ORDER BY RIGHT (Name,3),ID

--EX2: 
SELECT
user_id,
CONCAT(UPPER(left(name,1)), lower(right(name,length(name)-1))) AS name
FROM Users
ORDER BY user_id

--EX3: 
SELECT 
manufacturer,
'$' || ROUND(SUM(total_sales)/1000000,0) || ' ' || 'million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC ,manufacturer 

--EX4: 
SELECT 
EXTRACT(month FROM submit_date) AS mth,
product_id, 
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY mth,product_id
ORDER BY mth ASC, product_id ASC

--EX5 
SELECT 
sender_id,
count(message_id) AS mess_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 8 
AND EXTRACT (year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY mess_count DESC 
LIMIT 2 

--EX6 
ELECT
tweet_id
FROM Tweets
WHERE LENGTH(content) >15

--EX7 


--EX8 
Select 
COUNT(id)
From employees;
WHERE EXTRACT(month FROM joining_date) BETWEEN 1 AND 7 
AND EXTRACT(year FROM joining_date) =2022

--EX9 
SELECT 
position('a' in first_name) AS pos
FROM worker
WHERE first_name='Amitah' 

--EX10 
select 
substring(title FROM length(winery)+2 TO 4 )
from winemag_p2;
WHERE country='Macedonia'

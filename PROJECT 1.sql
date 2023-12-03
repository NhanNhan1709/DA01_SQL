---1) 
SELECT * 
FROM sales_dataset_rfm_prj;

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE numeric USING ordernumber::numeric; 

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE numeric USING quantityordered::numeric; 


ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING priceeach ::numeric; 

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE numeric USING orderlinenumber::numeric; 

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING sales ::numeric;

ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE DATE USING orderdate::date; 

---2) 
SELECT *
FROM sales_dataset_rfm_prj
WHERE  ORDERNUMBER IS NULL OR ORDERNUMBER = ''

SELECT *
FROM sales_dataset_rfm_prj
WHERE  quantityordered IS NULL OR quantityordered = ''

SELECT *
FROM sales_dataset_rfm_prj
WHERE priceeach  IS NULL OR priceeach  = ''

SELECT *
FROM sales_dataset_rfm_prj
WHERE orderlinenumber  IS NULL OR orderlinenumber = ''

SELECT *
FROM sales_dataset_rfm_prj
WHERE sales IS NULL OR sales = ''

SELECT *
FROM sales_dataset_rfm_prj
WHERE orderdate IS NULL OR orderdate = ''

---3) TRÍCH DỮ LIỆU QUA CỘT MỚI NHƯ THẾ NÀO ? THÊM TAY bằng INSERT TỪNG DỮ LIỆU ?  
SELECT 
contactfullname
FROM sales_dataset_rfm_prj; 

ALTER TABLE sales_dataset_rfm_prj
ADD conatactfirstname VARCHAR;

ALTER TABLE sales_dataset_rfm_prj
ADD conatactlastname VARCHAR; 

---4) TRÍCH DỮ LIỆU QUA CỘT MỚI NHƯ THẾ NÀO ? THÊM TAY bằng INSERT TỪNG DỮ LIỆU ?  

ALTER TABLE sales_dataset_rfm_prj
ADD YEAR_ID numeric;

INSERT sales_dataset_rfm_prj ('YEAR_ID')
VALUE( 
SELECT 
EXTRACT(YEAR FROM orderdate) AS YEAR_ID
FROM sales_dataset_rfm_prj)


---5) C1 : 
WITH cte AS (
SELECT 
Q1-1.5*IQR AS min_value, 
Q3+1.5*IQR AS max_value 
FROM(
SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS Q1,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS Q3,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS IQR 
FROM sales_dataset_rfm_prj) AS a)

SELECT * 
FROM sales_dataset_rfm_prj
WHERE QUANTITYORDERED < (SELECT min_value FROM cte ) OR QUANTITYORDERED > (SELECT max_value FROM cte )


--C2 : 

SELECT avg(QUANTITYORDERED),
stddev (QUANTITYORDERED)
FROM sales_dataset_rfm_prj;  

WITH cte AS (
SELECT ordernumber,
QUANTITYORDERED, 
(SELECT avg(QUANTITYORDERED)FROM sales_dataset_rfm_prj) AS AVG_quantityorder,
(SELECT stddev (QUANTITYORDERED) FROM sales_dataset_rfm_prj) AS std_quantityorder
FROM sales_dataset_rfm_prj) 

SELECT 
ordernumber,
QUANTITYORDERED, 
(QUANTITYORDERED - AVG_quantityorder)/std_quantityorder AS z_score 
FROM cte 
WHERE abs((QUANTITYORDERED - AVG_quantityorder)/std_quantityorder) > 3 

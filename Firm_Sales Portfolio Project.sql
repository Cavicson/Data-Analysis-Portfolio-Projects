--Some Skills used: CTE's, CTID’s, Windows Functions, Aggregate Functions, Creating Views, Clustered Indexing etc…


--Checking the entire data...

SELECT * FROM firmsales



--Checking for Nulls and updating them to UNKNOWN...

UPDATE firmsales 
SET postalcode = 'UNKNOWN'
WHERE postalcode IS NULL

UPDATE firmsales 
SET status = 'UNKNOWN'
WHERE status IS NULL

UPDATE firmsales 
SET productline = 'UNKNOWN'
WHERE productline IS NULL

UPDATE firmsales 
SET customername = 'UNKNOWN'
WHERE customername IS NULL

UPDATE firmsales 
addressline1 = 'UNKNOWN'
WHERE addressline2 IS NULL

UPDATE firmsales 
SET city = 'UNKNOWN'
WHERE city IS NULL

UPDATE firmsales 
SET state = 'UNKNOWN'
WHERE state IS NULL

UPDATE firmsales 
SET country = 'UNKNOWN'
WHERE country IS NULL

UPDATE firmsales 
SET territory = 'UNKNOWN'
WHERE territory IS NULL

UPDATE firmsales 
SET dealsize = 'UNKNOWN'
WHERE dealsize IS NULL



--Checking for duplicates

WITH CTE AS (
			SELECT ordernumber,productcode, CTID,
			ROW_NUMBER() OVER (PARTITION BY ordernumber,productcode ORDER BY ordernumber)
			AS row_no FROM firmsales
) 
SELECT * FROM CTE
WHERE row_no > 1



--Adjusting some values...

UPDATE firmsales
SET territory = 'Australia'
WHERE territory = 'APAC';

UPDATE firmsales
SET territory = 'North America'
WHERE territory = 'NA';

UPDATE firmsales
SET territory = 'Asia'
WHERE territory ILIKE '%japan%';

UPDATE firmsales
SET territory = 'Europe'
WHERE territory = 'EMEA';


--Creating an index on the sales column...

CREATE INDEX sales_index ON firmsales(sales)



--Creating a View for monthly sales data storage

CREATE VIEW monthly AS 
SELECT monthid,
	CASE 
		WHEN monthid = 1 THEN 'January'
		WHEN monthid = 2 THEN 'February'
		WHEN monthid = 3 THEN 'March'
		WHEN monthid = 4 THEN 'April'
		WHEN monthid = 5 THEN 'May'
		WHEN monthid = 6 THEN 'June'
		WHEN monthid = 7 THEN 'July'
		WHEN monthid = 8 THEN 'August'
		WHEN monthid = 9 THEN 'September'
		WHEN monthid = 10 THEN 'October'
		WHEN monthid = 11 THEN 'November'
		WHEN monthid = 12 THEN 'December'
		ELSE 'UNKNOWN' END AS Months, 
ROUND(SUM(sales)) AS total_sales
FROM firmsales
GROUP BY months, monthid ORDER BY monthid;



--Checking for Top Selling year, quatre, customer, country, territory, productline...

SELECT yearid, SUM(sales) 
FROM firmsales
GROUP BY yearid ORDER BY SUM(sales) DESC

SELECT qtrid, SUM(sales) 
FROM firmsales
GROUP BY qtrid ORDER BY SUM(sales) DESC 

SELECT customername, SUM(sales) 
FROM firmsales
GROUP BY customername ORDER BY SUM(sales) DESC
LIMIT 10

SELECT country, SUM(sales) 
FROM firmsales
GROUP BY country ORDER BY SUM(sales) DESC

SELECT territory, SUM(sales) 
FROM firmsales
GROUP BY territory ORDER BY SUM(sales) DESC

SELECT productline, SUM(sales) 
FROM firmsales
GROUP BY productline ORDER BY SUM(sales) DESC




--Checking for Top Selling City in the US...

SELECT city, country, SUM(sales) 
FROM firmsales WHERE country = 'USA'
GROUP BY city, country ORDER BY SUM(sales) DESC




--Checking for total number of dealsizes...

SELECT dealsize, COUNT(*) 
FROM firmsales
GROUP BY dealsize ORDER BY COUNT(*)



--Checking for which Customer has the most number of large dealsizes...

SELECT customername, COUNT(dealsize) AS large_deals 
FROM firmsales
WHERE dealsize ILIKE '%large%' 
GROUP BY customername ORDER BY large_deals DESC



--Finding the Total Revenue

SELECT ROUND(SUM(sales)) AS total_sales FROM firmsales




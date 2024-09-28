  
  -- Bike sales EDA analysis
CREATE DATABASE IF NOT EXISTS bike_sales;
USE bike_sales;
SHOW TABLES;

SELECT *
FROM addresses; 
-- rename the column_name
ALTER TABLE addresses RENAME COLUMN `ï»¿ADDRESSID` TO ADDRESSID;

-- total number of products for each product category
SELECT * FROM products;
SELECT PRODCATEGORYID, COUNT(*) AS total_no
FROM products
GROUP BY PRODCATEGORYID;

-- List the top 5 most expensive products.
SELECT PRODUCTID, PRICE
FROM PRODUCTS
GROUP BY  PRODUCTID, PRICE
ORDER BY PRICE DESC
LIMIT 5;

-- List the total sales amount (gross) for each product category.
SELECT P.PRODCATEGORYID, SUM(GROSSAMOUNT) AS total_sales_amount
FROM products P
LEFT JOIN salesorders S 
ON P.SUPPLIER_PARTNERID = S.PARTNERID
GROUP BY PRODCATEGORYID
ORDER BY total_sales_amount DESC;

-- -- total gross amount for each sales order.
SELECT SALESORDERID, SUM(GROSSAMOUNT) AS gross_amount
FROM salesorders
GROUP BY SALESORDERID
ORDER BY gross_amount DESC;

-- Find all products that belong to the 'Mountain Bike' category
SELECT *
FROM products P 
LEFT JOIN productcategorytext PC
ON P.PRODCATEGORYID = PC.PRODCATEGORYID
WHERE SHORT_DESCR = 'Mountain Bike';

-- Find the total number of products for each product category
SELECT PRODCATEGORYID, COUNT(PRODCATEGORYID) AS total_no_products
FROM products
GROUP BY PRODCATEGORYID;

-- Calculate the total gross amount for each sales order.
SELECT SALESORDERID, SUM(GROSSAMOUNT) AS gross_amount
FROM salesorders
GROUP BY SALESORDERID
ORDER BY gross_amount ASC;

-- Trends in sales over different fiscal year periods.
SELECT SUBSTR((FISCALYEARPERIOD),1,4) AS `year`, SUM(NETAMOUNT) AS total_sales
FROM salesorders
GROUP BY `year`;
			-- change the fiscalyear period from int to dates
UPDATE salesorders
SET FISCALYEARPERIOD = STR_TO_DATE(
CONCAT( LEFT(FISCALYEARPERIOD,4), '-' ,MID(FISCALYEARPERIOD , 5,3)), '%Y-%j');

ALTER TABLE salesorders
MODIFY COLUMN FISCALYEARPERIOD DATE;

WITH rolling_total AS (
SELECT YEAR(FISCALYEARPERIOD) AS `year`, SUM(NETAMOUNT) AS total_sales
FROM salesorders
GROUP BY `year`
)
SELECT *, SUM(total_sales)  
OVER(ORDER BY total_sales DESC) AS Rolling_total FROM rolling_total;

-- How many business partners are there for each partner role
SELECT PARTNERROLE, COUNT(*) AS bus_partners
FROM businesspartners
GROUP BY PARTNERROLE;

-- Find the number of employees for each sex
SELECT SEX, COUNT(*) AS nos_employees
FROM employees
GROUP BY SEX;

-- List the employees who have 'W' in their firstname
SELECT EMPLOYEEID, CONCAT(NAME_FIRST, ' ', NAME_LAST) AS Full_name
FROM employees WHERE NAME_FIRST LIKE 'W%';

-- List the top 5 employees who have created the most sales orders.
SELECT e.EMPLOYEEID, CONCAT(NAME_FIRST, ' ', NAME_LAST) AS Full_name, COUNT(*) AS sales_order
FROM employees e
LEFT JOIN salesorders s
ON e.EMPLOYEEID = s.CREATEDBY
GROUP BY EMPLOYEEID, Full_name
ORDER BY sales_order DESC
LIMIT 5;

-- Which products contribute the most to revenue when the billing status is 'Complete'
SELECT 
    p.PRODUCTID,
    p.PRODCATEGORYID,
    pct.SHORT_DESCR,
    SUM(NETAMOUNT) AS revenue
FROM products p
LEFT JOIN salesorders s
ON p.SUPPLIER_PARTNERID = S.PARTNERID
LEFT JOIN productcategorytext pct 
ON pct.PRODCATEGORYID = p.PRODCATEGORYID
WHERE BILLINGSTATUS = 'C'
GROUP BY
	 p.PRODUCTID ,
	 p.PRODCATEGORYID , 
	 pct.SHORT_DESCR
ORDER BY revenue DESC;


-- find the top-selling products within each category with its sale amount.
WITH Top_selling AS (
SELECT 
    p.PRODUCTID,
    p.PRODCATEGORYID,
    pct.SHORT_DESCR,
    p.CURRENCY,
    p.PRICE,
    SUM(soi.QUANTITY * p.PRICE) AS sales_amount
FROM products p
LEFT JOIN productcategories pc 
ON p.PRODCATEGORYID = pc.PRODCATEGORYID
LEFT JOIN salesorderitems soi
ON soi.PRODUCTID = p.PRODUCTID
LEFT JOIN productcategorytext pct
ON p.PRODCATEGORYID = pct.PRODCATEGORYID
GROUP BY p.PRODUCTID , p.PRODCATEGORYID , p.CURRENCY , p.PRICE, pct.SHORT_DESCR
), Top_ranking AS
(
SELECT *, RANK() OVER(PARTITION BY PRODCATEGORYID ORDER BY sales_amount DESC) AS ranks
 FROM Top_selling
 )
 SELECT 
	 PRODUCTID,
	 PRODCATEGORYID,
	 SHORT_DESCR AS PRODUCT_NAMES,
	 CURRENCY, 
	 sales_amount
 FROM Top_ranking WHERE ranks = 1;
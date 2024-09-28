
-- ------ create database.
CREATE DATABASE IF NOT EXISTS walmart;
USE walmart;

-- ------ create table.
CREATE TABLE IF NOT EXISTS sales (
      invoice_id VARCHAR (30) NOT NULL PRIMARY KEY,
      branch VARCHAR (5) NOT NULL,
      city VARCHAR (30) NOT NULL,
      customer_type VARCHAR (30) NOT NULL,
      gender VARCHAR (30) NOT NULL,
      product_line VARCHAR (100) NOT NULL,
      unit_price DECIMAL (10, 2) NOT NULL,
      quantity INT NOT NULL,
      tax_pct FLOAT (6, 4) NOT NULL,
      total DECIMAL (12, 4) NOT NULL,
      date DATETIME NOT NULL,
      time TIME NOT NULL,
      payment_method VARCHAR (30) NOT NULL,
      cogs DECIMAL (10, 2) NOT NULL,
      gross_margin FLOAT (11, 9) NOT NULL,
      gross_income DECIMAL (12, 4) NOT NULL,
      ratings FLOAT (2, 1) NOT NULL
);

-- import data from your csv file and data wrangling.
-- Data wrangling is the inspection of data to make sure NULL values are detected & replacement methods are used to replace the NULL.
-- Therefore the Constraint NOT NULL was used while the table was created.

SELECT 
    *
FROM
    sales;

-- ------ To add the time_of_day.
SELECT 
    time,
    (CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END
    ) AS time_of_day
FROM  sales; 

-- ------ To Add a new column called time_of_day and Update the table.
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (30);
UPDATE sales
SET time_of_day = (
    CASE
        WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN `time` BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END
);  

-- ------ To Add a Day_name -----------------------
SELECT 
    date,
    DAYNAME(date)
FROM
    Sales;
    
-- ------ To Add a new column called day_name and Update the table.
ALTER TABLE sales ADD COLUMN day_name VARCHAR(30);   
UPDATE sales
 SET day_name = DAYNAME(date);

-- ------ To Add a Month_name -----------------------
SELECT 
    date,
    MONTHNAME(date)
FROM
    Sales;

-- ------ To Add a new column called Month_name and Update the table.
ALTER TABLE sales ADD COLUMN month_name VARCHAR(30);   
UPDATE sales
 SET month_name = MONTHNAME(date);      
 
 
 -- ---------EXPLORATORY DATA ANALYSIS (EDA)-------------------------
 -- -------------------PRODUCTS--------------------------------------
 -- How many unique cities and branch does the data have?
 SELECT DISTINCT
    city, 
    branch
FROM
    sales;
    
-- How many product_lines does the data have/count?
 SELECT DISTINCT
    product_line
FROM
    sales;
    
-- What is the most common payment method?
SELECT 
	payment_method,
    COUNT(payment_method) AS cnt
FROM
    sales
    GROUP BY payment_method
    ORDER BY cnt DESC;
    
-- What is the most selling product_line?    
SELECT 
	product_line,
    COUNT(product_line) AS cnt
FROM
    sales
    GROUP BY product_line
    ORDER BY cnt DESC; 
 
-- What is the total revenue by month?    
SELECT 
    month_name,
    SUM(total) AS Total_Revenue
FROM
    sales
GROUP BY month_name
ORDER BY Total_Revenue;    

-- What month had the largest cogs?
SELECT 
    month_name,
    SUM(cogs) AS cnt
FROM
    sales
GROUP BY month_name
ORDER BY cnt DESC;

-- What product_line had the largest revenue?
SELECT 
    product_line, 
    SUM(total) AS Revenue
FROM
    sales
GROUP BY product_line 
ORDER BY Revenue DESC ;

-- What is the city with the largest revenue?
SELECT 
    city, 
    branch, 
    SUM(total) AS Revenue
FROM
    sales
GROUP BY city , branch
ORDER BY Revenue DESC;

-- `What product_line has the largest VAT?`
SELECT 
    product_line,
    ROUND(AVG(tax_pct), 2) AS VAT
FROM
    sales
GROUP BY product_line
ORDER BY VAT DESC;

-- Which branch sold more products than average products sold?
SELECT 
    branch,
    SUM(quantity) AS qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product_line by gender?
SELECT 
    product_line,
    gender,
    COUNT(gender) AS total_cnt
FROM
    sales
    GROUP BY gender, product_line
    ORDER BY total_cnt DESC;
    
-- What is the average rating of each product line?
SELECT 
    product_line,
   ROUND(AVG(ratings), 2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;
    
    
         -- -------------------SALES ANALYSIS--------------------------------------    
-- Number of sales made in each time of the day per weekday 
SELECT 
    time_of_day, 
    COUNT(*) AS total_sales
FROM
    sales
    WHERE day_name = 'tuesday'
GROUP BY time_of_day
ORDER BY total_sales DESC;   

-- Which customer type brings the most revenue?
SELECT 
    customer_type, 
    SUM(total) AS revenue
FROM
    sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/VAT (value added tax)?
SELECT 
    city, 
    ROUND(AVG(tax_pct), 2) AS vat
FROM
    sales
GROUP BY city
ORDER BY vat DESC;

-- Which customer_type pays the most in VAT?
SELECT 
    customer_type,
    AVG(tax_pct) AS vat
FROM
    sales
GROUP BY customer_type
ORDER BY vat DESC;


  -- -------------------CUSTOMER'S ANALYSIS--------------------------------------  
-- How many unique customer_type does the data have.?
SELECT
   DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
   DISTINCT payment_method
FROM sales;

-- What is the most common customer_type?
SELECT
   customer_type,
   COUNT(invoice_id) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC ;

-- Which customer_type buys the most?
SELECT
   customer_type,
   COUNT(*) AS cst_cnt
FROM sales
GROUP BY customer_type
ORDER BY cst_cnt DESC ;

-- What is the gender of most of the customers?
SELECT 
    gender, 
    COUNT(*) AS gender_cnt
FROM
    sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT 
    gender, 
    COUNT(*) AS gender_cnt
FROM
    sales
    WHERE branch = 'C'
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What time of the day do customers give most ratings?
SELECT 
    time_of_day,
   ROUND(AVG(ratings), 2) AS cst_ratings
FROM
    sales
GROUP BY time_of_day
ORDER BY cst_ratings DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT 
    time_of_day,
   ROUND(AVG(ratings), 2) AS cst_ratings
FROM
    sales
    WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY cst_ratings DESC;

-- Which day of the week has the best avg ratings?
SELECT 
    day_name, 
    ROUND(AVG(ratings), 3) AS avg_ratings
FROM
    sales
GROUP BY day_name
ORDER BY avg_ratings DESC;

-- Which day of the week has the best avg ratings per branch?
SELECT 
    day_name, 
    ROUND(AVG(ratings), 3) AS avg_ratings
FROM
    sales
    WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_ratings DESC;


/* Revenue and Profit Calculation.
$ COGS = units¬_Price * quantity $
$ VAT = 5% * COGS $
VAT is added to the COGS and this is what is billed to the customer
$ total(gross_sales) = VAT + COGS $
$ gross_Profit(gross_Income) = total(gross_sales) - COGS $
Gross Margin is gross profit expressed in percentage of the total (gross profit/revenue)
$ \text {Gross Margin} = \frac {\text {gross income}}{\text{total revenue}} $ */


-- $ COGS = units¬_Price * quantity $
SELECT
	unit_price,
	quantity,
	(unit_price * quantity) AS cogs
FROM sales;


-- To calculate the gross_sales
SELECT 
 tax_pct + cogs
 FROM sales;
 
 -- $ gross_Profit(gross_Income) = total(gross_sales) - COGS $
 SELECT 
    total - cogs
FROM
    sales;
    
-- $ \text {Gross Margin} = \frac {\text {gross income}}{\text{total revenue}} $ */
SELECT
 total,
 gross_income,
(gross_income / total) * 100 
 FROM sales;


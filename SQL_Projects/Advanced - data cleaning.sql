
-- SQL Project - Advanced Data Cleaning
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

USE world_layoffs;
SELECT *
FROM layoffs;

-- create a Staging table
/*staging table are temp tables that are used to hold data during data loading,
transformation, or integration processes. They serve as a buffer b/w the 
source data and the final destination tables */

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Inserting raw data into the staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Removing Duplicates
-- First let's check for duplicates

SELECT *,
        ROW_NUMBER() OVER(
               PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS (
  SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
) 
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- lets use oda company to confirm the duplicates
SELECT * FROM layoffs_staging
WHERE company = 'oda';

-- these are our real duplicates rows
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_staging
) duplicate_cte
WHERE 
	row_num > 1;
    
SELECT * FROM layoffs_staging
WHERE company = 'casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_staging;

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- Deleting the duplicates from our table
DELETE FROM layoffs_staging2
WHERE row_num > 1;
SELECT * FROM layoffs_staging2;


-- Data Standardization
/*This is the process of transforming data into a common format to 
enable users to process and analyze it. This involves ensuring that data 
from different sources is formatted, categorized and coded in a uniform way */

SELECT *
FROM layoffs_staging2;

SELECT company, (TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- if we look at the industry column it looks like we have some null and empty rows, let's take a look at these
SELECT *
FROM
    layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE  layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';


SELECT DISTINCT
    country, TRIM(TRAILING '.' FROM country)
FROM
    layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

-- Let's also fix the date columns:
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM  layoffs_staging2;

UPDATE  layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Look at Null Values
-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. 
-- I like having them null because it makes it easier for calculations during the EDA phase

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ' ';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
   ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = ' ')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
    JOIN layoffs_staging2 t2
         ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;   -- Null query gone wrong...opps


-- Delete Useless data we can't really use
SELECT * FROM layoffs_staging2;

DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

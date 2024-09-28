-- Exploratory Data Analysis
-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers
-- normally when you start the EDA process you have some idea of what you're looking for

SELECT *
FROM
layoffs_staging2;

SELECT 
    MAX(total_laid_off)
FROM
    layoffs_staging2;
    
  -- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),
       MIN(percentage_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

   -- Which companies had 1 which is basically 100 of their laid off
SELECT *
FROM  layoffs_staging2
WHERE  percentage_laid_off = 1;
   -- these are mostly startups it looks like they all went out of business or they folded during this time

  -- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
   
    -- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY 2 DESC
LIMIT 5;

    -- Companies with the most Total Layoffs
SELECT 
    company, 
    SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

   -- by location
SELECT 
    location, 
    SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- by country
SELECT 
    country, 
    SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- laid_off by date(year)
SELECT 
    YEAR(`date`),
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`) DESC;

-- laid_off by industry
SELECT 
    industry, 
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;


    -- Rolling Total of Layoffs Per Month
SELECT 
    SUBSTRING(`date`, 1, 7) AS dates,
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC;

         -- now use it in a CTE 
WITH Rolling_total AS
(SELECT 
    SUBSTRING(`date`, 1, 7) AS dates,
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off,
 SUM(total_laid_off) OVER (ORDER BY dates) AS rolling_total
FROM Rolling_total;


SELECT 
    country, 
    SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    company,
    YEAR(`date`) AS years,
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

-- Companies with the most Layoffs per year
WITH Company_year AS
(
SELECT 
    company,
    YEAR(`date`) AS years,
    SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
), Company_year_rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS dense_ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE dense_ranking <= 5;





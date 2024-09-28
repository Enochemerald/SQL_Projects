-- Window Functions
-- windows functions are really powerful and are somewhat like a group by - except they don't roll everything up into 1 row when grouping. 
-- windows functions allow us to look at a partition or a group, but they each keep their own unique rows in the output
-- These functions include Row Numbers, rank, and dense rank

USE parks_and_recreation;

-- what is the average salary of both genders.
SELECT 
    dem.gender, 
    ROUND(AVG(sal.salary), 2) AS avg_sal
FROM employee_demographics dem
JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id
GROUP BY gender;


-- using partition is kind of like the group by except it doesn't roll up/collapse - 
-- it just partitions or breaks based on a column when doing the calculation
SELECT 
    dem.first_name, dem.last_name,dem.gender, 
    AVG(sal.salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;
  
  
-- to get salaries by gender using the rolling_total.
-- the rolling_total adds up the next salary on the row.
SELECT 
    dem.first_name, dem.last_name,dem.gender, sal.salary,
    SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics dem
INNER JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;
  
  
-- this assigns a sequencial nos to each row within a partition
-- it is used to rank rows based on their position within a table
SELECT 
    dem.first_name, dem.last_name,dem.gender, sal.salary,
    ROW_NUMBER() OVER( PARTITION BY gender) AS row_num
FROM employee_demographics dem
INNER JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;


-- let's ORDER by salary so we can see the order of highest paid employees by gender
SELECT 
    dem.first_name, dem.last_name,dem.gender, sal.salary,
    ROW_NUMBER() OVER( PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
INNER JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;


-- let's compare this to rank
SELECT 
    dem.first_name, dem.last_name,dem.gender, sal.salary,
    ROW_NUMBER() OVER( PARTITION BY gender ORDER BY salary DESC) AS row_num,
    RANK() OVER( PARTITION BY gender ORDER BY salary DESC) AS rank_num
FROM employee_demographics dem
INNER JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;


  -- then dense_ranking  
SELECT 
    dem.employee_id, dem.first_name, dem.last_name,dem.gender, sal.salary,
    ROW_NUMBER() OVER( PARTITION BY gender ORDER BY salary DESC) AS row_num,          -- row_num does not accept duplicates, it gives unique nums
    RANK() OVER( PARTITION BY gender ORDER BY salary DESC) AS rank_num,               -- rank_num duplicates and gives the next num positionally
   DENSE_RANK() OVER( PARTITION BY gender ORDER BY salary DESC) AS dense_ranking      -- rank_num duplicates and gives the next num numerically
FROM employee_demographics dem
INNER JOIN employee_salary sal
  ON dem.employee_id = sal.employee_id;
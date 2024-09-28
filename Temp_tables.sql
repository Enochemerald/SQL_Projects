-- Using Temporary Tables
-- Temporary tables are tables that are only visible to the session that created them. 
-- They can be used to store intermediate results for complex queries or to manipulate data before inserting it into a permanent table.

-- There's 2 ways to create temp tables:
-- 1. This is the less commonly used way - which is to build it exactly like a real table and insert data into it
CREATE TEMPORARY TABLE `temp_table` (
   `first_name` VARCHAR (50),
   `last_name` VARCHAR (50),
   `favorite_movie` VARCHAR (100),
   PRIMARY KEY (`first_name`)            -- this table doesn't appear on our schema because It isn't an actual table. It's just a table in memory.
);
INSERT INTO temp_table VALUES 
  ('John', 'Doe', 'Merlin'),
  ('Charles', 'Darwin', 'Money Heist'),
  ('Kelvin', 'Stravet', 'Law abiding citizen'),
  ('Micheal', 'Durant', 'Seal Team');
SELECT * FROM temp_table;

-- 2. Build it by inserting data into it 
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

SELECT * FROM salary_over_50k;
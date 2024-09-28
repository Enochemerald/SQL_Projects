
-- TRIGGERS
-- a Trigger is a block of code that executes automatically executes when an event takes place in a table.

USE parks_and_recreation;
SELECT * 
FROM employee_salary;

SELECT * 
FROM employee_demographics;

DELIMITER $$
CREATE TRIGGER employee_insert2   --  what events needs to take place inorder for this to be triggered
  AFTER INSERT ON employee_salary    -- after a row is been inserted into the employee_salary
  FOR EACH ROW
BEGIN
	INSERT INTO  employee_demographics( employee_id, first_name, last_name)    -- Command to trigger
    VALUES (NEW.employee_id, NEW.first_name, NEW. last_name);
END $$
DELIMITER ;  

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES ( 13, 'Enoch', 'Emerald','Data analyst', 50000, NULL);
  
  
  DELETE FROM employee_demographics 
  WHERE employee_id = 13;
  
  
  -- Using another database
USE newdf;
SELECT * 
FROM workers;

-- lets add a salary column
ALTER TABLE workers ADD COLUMN salary DECIMAL(10,2)
AFTER hourly_pay;
UPDATE workers
SET salary = hourly_pay * 2080;
-- to update their salaries automatically once a new person is added to the company

CREATE TRIGGER before_hourly_pay_update
  BEFORE UPDATE ON workers
  FOR EACH ROW
  SET NEW.salary = (NEW.hourly_pay * 2080);
  
  
  UPDATE workers
  SET hourly_pay = 30
  WHERE employee_id = 1;
  SELECT * FROM workers;        -- here we calculated the new salary automatically immediately we updated our hourly_pay
  
  UPDATE workers
  SET hourly_pay = hourly_pay + 1;  
  -- this is a trigger that kicks in whenever we update our hourly_pay column
  
DELETE FROM workers
WHERE employee_id = 5;

CREATE TRIGGER before_hourly_pay_insert
  BEFORE INSERT ON workers
  FOR EACH ROW
  SET NEW.salary = (NEW.hourly_pay * 2080);

INSERT INTO workers VALUES
(5, 'Queen', 'Joseph','Queenjoseph@gmail.com', 26.08, NULL, 'Janitor', '2023-08-06');

ALTER TABLE workers DROP COLUMN salary;
SELECT * FROM workers;




-- EVENTS
-- a trigger happens when an event takes place while an event occurs when its scheduled.
-- Events are task or block of code that gets executed according to a schedule. 
-- you can schedule all of this to happen every day, every monday, every first of the month at 10am. Really whenever you want

USE parks_and_recreation;
SELECT *
FROM employee_demographics;
-- let's say Parks and Rec has a policy that anyone over the age of 60 is immediately retired or fired
-- All we have to do is delete them from the demographics table

DELIMITER $$
CREATE EVENT delete_retires
ON SCHEDULE EVERY 1 MONTH
DO BEGIN
    DELETE
    FROM employee_demographics
    WHERE age > 60;
END $$
DELIMITER ;


-- if we run it again you can see Jerry is now fired -- or retired
SELECT *
FROM employee_demographics;

SHOW VARIABLES LIKE '%events%';
SHOW EVENTS;
DROP EVENT delete_retires;

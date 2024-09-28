USE newdf;
SHOW TABLES;  
  
  CREATE TABLE workers (
     employee_id INT,
     first_name VARCHAR (50),
     last_name VARCHAR (50),
     email VARCHAR (100),
     hourly_pay DECIMAL (5, 2),
     job VARCHAR (50),
     hire_date DATE
);     

INSERT INTO workers VALUES
        (1, 'Eugene', 'Krabs','eugenekrabs@gmail.com',25.50,'Manager','2024-01-05'),
        (2, 'Micheal', 'Jackson','michealjackson@gmail.com', 15.50, 'VP sales','2024-01-06'),
        (3, 'Kevin', 'Hart','kevinhart@gmail.com', 32.10, 'cook','2024-01-07'),
        (4, 'Tom', 'Cruise','tomcruise@gmail.com', 28.20, 'janitor','2024-01-08'),
        (5, 'Queen', 'Joseph','queenjoseph@gmail.com', 55.20, 'Sales rep','2024-01-09'),
        (6, 'Miracle', 'Auta','miracleauta@gmail.com', 76.20, 'cook','2024-01-10'),
        (7, 'John', 'Bradly','johnbradly@gmail.com',12.50 ,'cook','2024-01-11');
  
     SELECT * FROM workers;
  
  
  
  
  #------------------VIEWS----------------------------------
 # a view is a Virtual table based on the result-set of an SQL statement
 # The fields in the view are fields from one or more real tables in the database
 # They are not real tables, but they can be interacted with.alter
 
 
 CREATE VIEW workers_attendance AS 
 SELECT * FROM 
 workers;
 
 SELECT * FROM workers_attendance;
 SELECT * FROM workers_attendance
 WHERE employee_id =  4;
 
 
 
 
 
 #----------------------STORED PROCEDURES---------------------------------------
 # A stored procedures is a prepared SQL code that is stored in a database.
 #it is a subprogram in the regular computing language.
 # Stored procedures increases the performance of the applications. Once stored produres are created,
 #they are compiled and stored in the DB.
 
 
 USE parks_and_recreation;
 CREATE PROCEDURE large_salaries()
 SELECT * 
 FROM employee_salary
 WHERE salary >= 50000;
 
 CALL large_salaries();
 
 DELIMITER $$
 CREATE PROCEDURE large_salaries2()
 BEGIN
    SELECT *
    FROM employee_salary
    WHERE salary >= 50000;
	SELECT *
    FROM employee_salary
    WHERE salary >= 10000;
END $$
DELIMITER ;
CALL large_salaries2();

-- passing into parameters
DELIMITER $$
 CREATE PROCEDURE large_salaries3(IN id INT)
 BEGIN
    SELECT *
    FROM employee_salary
    WHERE employee_id = id;
END $$
DELIMITER ;
CALL large_salaries3(9);


DELIMITER $$
 CREATE PROCEDURE employee(IN f_name VARCHAR(50))
 BEGIN
    SELECT *
    FROM employee_salary
    WHERE first_name = f_name;
    END $$
DELIMITER ;
CALL employee('Ben');

-- End of procedures/ drop all procedures
DROP PROCEDURE large_salaries3;



-- Using another database
 USE newdf;
 DELIMITER $$
 CREATE PROCEDURE call_workers()
 BEGIN
     SELECT * FROM workers;
 END $$
 DELIMITER ;
 
 CALL call_workers;
DROP PROCEDURE call_workers;

-- passing into parameters
		DELIMITER $$
		CREATE PROCEDURE find_workers(IN id INT)
		BEGIN
		   SELECT * FROM workers
		   WHERE employee_id = id;
		END $$
		DELIMITER ;
        
        
  CALL find_workers(6);    
  DROP PROCEDURE find_workers
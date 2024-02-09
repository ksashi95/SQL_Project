-- 

USE sql_project;

-- SELECT COMMAND 
SELECT * FROM diabetes;

SELECT age FROM diabetes;

SELECT max(age),min(age) FROM diabetes;

-- --------------------------------------------------------------------------------------------------


-- OPERATORS

-- Select all columns for patients who are at least 30 years old.
SELECT * 
FROM diabetes
WHERE Age >= 30;

-- Retrieve the number of pregnancies with a BMI greater than 25.
SELECT count(Pregnancies)
FROM diabetes 
WHERE BMI > 25;

-- Find patients who have diabetes (Outcome=1) and a DiabetesPedigreeFunction greater than 0.5.
SELECT * 
FROM diabetes 
WHERE Outcome = 1 AND DiabetesPedigreeFunction > 0.5;

-- Get the average BloodPressure for patients who are not diabetic (Outcome=0).
SELECT avg(BloodPressure) AS AvgBP
FROM diabetes 
WHERE Outcome = 0;

-- Retrieve patients with a SkinThickness between 20 and 30 (inclusive).
SELECT * 
FROM diabetes 
WHERE SkinThickness BETWEEN 20 AND 30;

-- --------------------------------------------------------------------------------------------------

-- AGGREGATE FUNCTIONS

-- Count the number of instances in the dataset
SELECT COUNT(*) AS total_instances 
FROM diabetes;

-- Find the average number of pregnancies
SELECT AVG(Pregnancies) AS avg_pregnancies 
FROM diabetes;

-- Calculate the maximum and minimum BMI in the dataset
SELECT MAX(BMI) AS max_bmi, MIN(BMI) AS min_bmi 
FROM diabetes;

-- Sum of insulin levels for all instances
SELECT SUM(Insulin) AS total_insulin 
FROM diabetes;

-- Find the average age of patients with diabetes (Outcome=1)
SELECT AVG(Age) AS avg_age_diabetes 
FROM diabetes 
WHERE Outcome = 1;

-- --------------------------------------------------------------------------------------------------


-- GROUP BY, HAVING, ORDER BY

-- List the maximum and minimum BMI for each age group (let's say in increments of 5 years)
SELECT FLOOR(Age / 5) * 5 AS AgeGroup, MAX(BMI) AS MaxBMI, MIN(BMI) AS MinBMI
FROM diabetes
GROUP BY AgeGroup
ORDER BY AgeGroup;


-- Show the average glucose level for individuals with a BMI greater than 30, grouped by the outcome
SELECT Outcome, AVG(Glucose) AS AvgGlucose
FROM diabetes
WHERE BMI > 30
GROUP BY Outcome;

/*List the total number of pregnancies for each age group (grouped in ranges like 20-30, 31-40, etc.) 
and display only those with a total count greater than 10 */
SELECT FLOOR(Age/10)*10 AS AgeGroup, SUM(Pregnancies) AS TotalPregnancies
FROM diabetes
GROUP BY AgeGroup
HAVING TotalPregnancies > 10
ORDER BY AgeGroup;




SELECT sum(pregnancies)
FROM diabetes 
WHERE age BETWEEN 20 AND 29;
-- --------------------------------------------------------------------------------------------------

DESCRIBE diabetes;
-- ALTER

-- Add Column 
ALTER TABLE diabetes
ADD id int;

ALTER TABLE diabetes
DROP COLUMN id;

--  Modify Column data type
ALTER TABLE diabetes
MODIFY COLUMN BloodPressure FLOAT;

SELECT * FROM diabetes;

-- --------------------------------------------------------------------------------------------------

-- JOINS
/* 
WHAT IS A JOIN?
Joins in SQL are used to combine rows from two or more tables based on a related coumn between them.

JOINs are of 3 types :
INNER JOIN - Returns when there is a match in both tables.

OUTER JOIN - OUTER JOIN is subdivied into 2 type: LEFT JOIN & RIGHT JOIN
LEFT JOIN (or LEFT OUTER JOIN) - Returns all rows from the left table and the matvhed rows from the right table.
RIGHT JOIN ( or RIGHT OUTER JOIN) - Returns all rows from the right table and the matvhed rows from the left table.

CROSS JOIN - Combines every row from the first table with every row from the second table.
*/

-- --------------------------------------------------------------------------------------------------


-- SUBQUERIES

-- Find the number of pregnancies for individuals with a BMI greater than the average BMI
SELECT Pregnancies, BMI
FROM diabetes
WHERE BMI > (SELECT AVG(BMI) FROM diabetes);


select AVG(BMI)
FROM diabetes;

/* Retrieve the age, number of pregnancies, and blood pressure of individuals 
who have had fewer pregnancies than the maximum number of pregnancies recorded in the dataset. 
Display the results in descending order based on the number of pregnancies */

SELECT age,pregnancies,bloodpressure FROM diabetes 
WHERE pregnancies < 
	(SELECT max(pregnancies) FROM diabetes)
ORDER BY Pregnancies DESC ;

-- --------------------------------------------------------------------------------------------------


-- VIEWS


-- Create a view that includes only the records where the Outcome is 1 (indicating diabetes)
CREATE VIEW DiabetesCases AS
SELECT * FROM diabetes
WHERE Outcome = 1;

select * FROM diabetescases;
-- Create a view that shows the average BMI for different age groups
CREATE VIEW AvgBMIByAge AS
SELECT Age, AVG(BMI) AS AvgBMI
FROM diabetes
GROUP BY Age;

-- Create a view that displays the top 10 records with the highest Glucose levels
CREATE VIEW TopGlucoseCases AS
SELECT *
FROM diabetes
ORDER BY Glucose DESC
LIMIT 10;


-- CASE STATEMENT 


-- STORE PROCEDURE

DELIMITER //
CREATE PROCEDURE custom()
BEGIN
	SELECT *,
		CASE
		WHEN Age >= 21 AND Age <= 39 THEN 'Young Adult'
		WHEN Age >= 40 AND Age <= 59 THEN 'Middle Aged'
		WHEN Age >= 60 THEN 'Old Aged'
		ELSE 'Unknown'
		END AS Age_Group,
        
		CASE
		WHEN Outcome = 1 THEN 'Diabetic'
		WHEN Outcome = 0 THEN 'Non-Diabetic'
		END AS Result
	FROM diabetes;
END //
DELIMITER ;

CALL custom;

-- ----------------------------------------------------------------------------------------------------------------------------------------- --
SELECT * FROM diabetes;

SET AUTOCOMMIT = 0;


-- TRIGERRS

delimiter //
CREATE TRIGGER A
BEFORE DELETE ON diabetes
FOR EACH ROW
BEGIN
signal sqlstate '45000' SET message_text = 'Not Allowed';
END //
delimiter ;

DELETE FROM diabetes 
WHERE pregnancies =6;

SELECT * FROM diabetes;

-- WINDOWS FUNCTION

-- assigning a unique row number to each record
SELECT *,
ROW_NUMBER() OVER (ORDER BY Age) AS RowNumber
FROM diabetes;
    
-- calculate the average glucose level for each age group    
    
SELECT Age,Glucose,
AVG(Glucose) OVER (PARTITION BY Age) AS AvgGlucoseByAge
FROM diabetes;

-- find the average BMI for each outcome (1 for Yes, 0 for No) and order the results by age in descending order

SELECT Age,BMI,Outcome,
AVG(BMI) OVER (PARTITION BY Outcome ORDER BY Age DESC) AS AvgBMIByOutcome
FROM diabetes;
    




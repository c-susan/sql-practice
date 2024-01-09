--The SQL practice exercises below references Jose Portilla's "The Complete SQL Bootcamp: Go from Zero to Hero" course on Udemy.com. 
--Portilla, J. (2022, May). The Complete SQL Bootcamp: Go from Zero to Hero. Udemy. https://www.udemy.com/course/the-complete-sql-bootcamp/
--https://pieriantraining.com
--https://www.linkedin.com/in/jmportilla


------------------------------
--SQL Basics and Fundamentals
------------------------------
--We want to send out a promotional email to existing customers. To do this, we query the existing customers' 
---first name, last name, and email from the 'customer' table.  
SELECT first_name, last_name, email 
FROM customer;

--What are the different unique movie ratings in the database? 
SELECT DISTINCT rating FROM film; 


--A customer, Nancy Thomas, forgot their wallet in the store. Let's track down their email from our database to inform them. 
SELECT email FROM customer 
WHERE first_name = 'Nancy'
AND last_name = 'Thomas'; 

--A customer wants to know what the movie "Outlaw Hanky" is about. 
SELECT description FROM film
WHERE title = 'Outlaw Hanky'; 

--A customer with the address '259 Ipoh Drive' is late on their movie return. Let's find their phone number to call them. 
SELECT phone FROM address
WHERE address = '259 Ipoh Drive';


--We want to reward our first 10 paying customers. Let's find their customer ids. 
SELECT customer_id FROM payment
ORDER BY payment_date ASC
LIMIT 10;

--What are the titles of the 5 shortest (length of runtime) movies? 
SELECT title, length FROM film
ORDER BY length
LIMIT 5;

--How many movies have a runtime the is 50 minutes or less? 
SELECT COUNT(title) FROM film
WHERE length <=50;


--How many payment transactions were greater than $5.00? 
SELECT COUNT(amount) FROM payment
WHERE amount >5;

--How many actors have have a first name that starts with the letter 'P'?
SELECT COUNT(*) FROM actor
WHERE first_name LIKE 'P%';

--How many unique districts are our customers from?
SELECT COUNT(DISTINCT(district))
FROM address; 

--What are the names of each of the unique districts? 
SELECT DISTINCT district 
FROM address; 

--How many films have a rating of R and a replacement cost between $5 and $15?
SELECT COUNT(*) FROM film
WHERE rating = 'R'
AND replacement_cost BETWEEN 5 AND 15; 

--How many films have the word 'Truman' somewhere in the title?
SELECT COUNT(title) FROM film
WHERE title LIKE '%Truman%';


--We want to give a bonus to the staff member who processed the most number of payments.
--How many payments did each staff member handle and who gets the bonus?
SELECT staff_id, COUNT(amount)
FROM payment
GROUP BY staff_id;

--What is the average replacement cost per movie MPAA rating? 
SELECT rating, AVG(replacement_cost)
FROM film
GROUP BY rating;

--What are the customer ids of the top 5 customers by total spend?
SELECT customer_id, SUM(amount)
FROM payment 
GROUP BY customer_id
ORDER BY SUM(amount) DESC 
LIMIT 5; 


--What are the customer ids of customers who have had 40 or more transaction payments? 
SELECT customer_id, COUNT(*) 
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40; 

--What are the customer ids of customers who have spent more than $100 in payment transactions with staff_id member 2? 
SELECT customer_id, SUM(amount)
FROM payment 
WHERE staff_id = 2
GROUP BY customer_id
HAVING SUM(amount) >100; 


------------------------------
        --Joins
------------------------------
--What are the emails of customers living in California? 
SELECT district, email FROM address
INNER JOIN customer ON 
address.address_id = customer.address_id
WHERE district = 'California';

--Getting a list of all the movies the actor 'Nick Wahlberg' is in.
SELECT title, first_name, last_name FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
INNER JOIN actor ON 
film_actor.actor_id = actor.actor_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg';


------------------------------
--Timestamps and Extract 
------------------------------
--During which months did payments occur? 
SELECT DISTINCT(TO_CHAR(payment_date,'MONTH'))
FROM payment; 

--How many payments occurred on a Monday?
SELECT COUNT(*) 
FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1


------------------------------
--Creating Databases and Tables
------------------------------
--Creating a new database called 'school' that contains 2 tables: students and teachers.
---Students table:
CREATE TABLE students (
	student_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL, 
	homeroom_number INT, 
	phone VARCHAR(50) UNIQUE NOT NULL,
	email VARCHAR(100) UNIQUE,  
	graduation_year INT
);

---Teachers table: 
CREATE TABLE teachers (
	teacher_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL, 
	last_name VARCHAR(50) NOT NULL,
	homeroom_number INT, 
	department VARCHAR(50), 
	email VARCHAR(50) UNIQUE,  
	phone VARCHAR(50) UNIQUE
);


--Now let's insert some values into the 2 tables. 
---Students table:
INSERT INTO students (
	first_name,
	last_name,
	homeroom_number,
	phone,
	graduation_year
)
VALUES (
	'Mark',
	'Watney',
	'507',
	'123-123-1234',
	'2024'
);

---Teachers table:
INSERT INTO teachers (
	first_name,
	last_name,
	homeroom_number,
	department, 
	email,
	phone
)
VALUES (
	'Jonas',
	'Salk',
	'507',
	'Biology',
	'jsalk@school.org',
	'231-321-4321'
);


------------------------------
--Conditional Expressions and Procedures
------------------------------
--Let's assign tiers/statuses to each customer based on their customer ids of either Premium, Plus, or Normal. 
SELECT customer_id 
CASE
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 AND 200) THEN 'Plus'
	ELSE 'Normal'
END AS customer_status
FROM customer;

--A raffle was held where results were the customer id 2 was the winner and customer id 5 was second place. 
--Let's replicate the results below:
SELECT customer_id, 
CASE customer_id
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN 'Second Place'
	ELSE ''
END AS raffle_results
FROM customer;

--We want to know and compare the various amounts of films we have per movie rating: 
SELECT 
SUM(CASE rating 
	WHEN  = 'R'  THEN 1 ELSE 0 
	END) AS r, 
SUM(CASE rating 
	WHEN  = 'PG'  THEN 1 ELSE 0 
	END) AS pg, 
SUM(CASE rating 
	WHEN  = 'PG-13'  THEN 1 ELSE 0 
	END) AS pg-13
FROM film;


--Here we are trying to find out how many digits are in the inventory id: 
---CAST function changes one datatype to another. 
SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR)) 
FROM rental;


--Let's create a view consisting of customer first_name, last_name, and address:
CREATE VIEW customer_info AS
SELECT first_name,last_name,address
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;
---To call the view, simply: 
SELECT * FROM customer_info;

--We now want to change the view and and add in the district: 
CREATE OR REPLACE VIEW customer_info AS
SELECT first_name,last_name,address,district 
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id;
---To call the view, simply: 
SELECT * FROM customer_info;

--To drop the view: 
DROP VIEW customer_info;
--OR:
DROP VIEW IF EXISTS customer_info;

--To rename the view: 
ALTER VIEW customer_info RENAME TO c_info; 


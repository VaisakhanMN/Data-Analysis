-- Create the database
CREATE DATABASE employee_1;
USE employee_1;

-- Create Departments table
CREATE TABLE Departments (
    department_id INT,
    department_name VARCHAR(100),
    PRIMARY KEY (department_id)
);

-- Create Location table
CREATE TABLE Location (
    location_id INT,
    location VARCHAR(30),
    PRIMARY KEY (location_id)
);

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT,
    employee_name VARCHAR(50),
    gender ENUM('M', 'F'),
    age INT,
    hire_date DATE,
    designation VARCHAR(100),
    department_id INT,
    location_id INT,
    salary DECIMAL(10, 2),
    PRIMARY KEY (employee_id),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- 1. Add a new column named "email"
ALTER TABLE Employees 
ADD email VARCHAR(100);

-- 2. Modify "designation" to support wider range (increasing size)
ALTER TABLE Employees 
MODIFY designation VARCHAR(150);

-- 3. Drop the "age" column
ALTER TABLE Employees 
DROP COLUMN age;

-- 4. Rename "hire_date" to "date_of_joining"
ALTER TABLE Employees 
RENAME COLUMN hire_date TO date_of_joining;

-- Rename Departments to Departments_Info
RENAME TABLE Departments TO Departments_Info;

-- Rename Location to Locations
RENAME TABLE Location TO Locations;

-- Truncate the Employees table
TRUNCATE TABLE Employees;

-- Drop the Employees table
DROP TABLE Employees;

-- Drop the database
DROP DATABASE employee_1;

DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee;
USE employee;

CREATE TABLE Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE Departments_1 (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Employees_3 (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    gender ENUM('M', 'F'),
    age INT,
    hire_date DATE DEFAULT (CURRENT_DATE),
    designation VARCHAR(100),
    department_id INT,
    location_id INT,
    salary DECIMAL(10, 2),
    
    -- Constraint: Age must be 18 or above
    CONSTRAINT chck_age CHECK (age >= 18),
    
    -- Constraint: Link to Departments table
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    
    -- Constraint: Link to Location table
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
);

-- ASSIGNMENT-2

-- Insert Departments (using the renamed table 'Departments_Info')
SELECT * FROM Departments;
INSERT INTO Departments (department_id, department_name) VALUES 
(1, 'HR'), 
(2, 'Finance'), 
(3, 'IT'),
(4, 'Data Science');

-- Insert Locations (using the renamed table 'Locations')
INSERT INTO Location (location_id, location) VALUES 
(1, 'New York'), (2, 'London'), (3, 'Bangalore');

-- Insert Employees 



INSERT INTO Employees_3 (employee_id, employee_name, gender, age, hire_date, designation, department_id, location_id, salary) 
VALUES
(101, 'John Doe', 'M', 30, '2015-06-15', 'HR Manager', 1, 1, 60000),
(102, 'Jane Smith', 'F', 25, '2018-05-20', 'Data Analyst', 2, 2, 55000),
(103, 'Robert Brown', 'M', 45, '2014-02-10', 'Senior Analyst', 2, 1, 80000),
(104, 'Emily Davis', 'F', 22, '2019-01-01', 'Intern', 3, 3, 20000),
(105, 'Michael Wilson', 'M', 35, '2018-11-12', 'Developer', 3, 3, 75000),
(106, 'Sarah Johnson', 'F', 28, '2017-03-23', NULL, 4, 2, 72000);
SELECT * FROM Employees_3 ;
SELECT DISTINCT salary 
FROM Employees_3;

SELECT age AS Employee_Age, 
    salary AS Employee_Salary 
FROM Employees_3;

SELECT * FROM Employees_3 
WHERE salary > 50000 
  AND hire_date < '2016-01-01';

SET SQL_SAFE_UPDATES = 0;

UPDATE Employees_3 
SET designation = 'Data Scientist' 
WHERE designation IS NULL;

SELECT * FROM Employees_3 ;

-- Find employees sorted by department ID in ascending order and salary in descending order.
SELECT * FROM Employees_3 
ORDER BY department_id ASC, salary DESC;

-- Display the first 5 employees hired in the year 2018.
SELECT * FROM Employees_3 
WHERE YEAR(hire_date) = 2018 
LIMIT 5;

-- Calculate the sum of all salaries in the Finance department.
SELECT SUM(e.salary) 
FROM Employees_3 e
JOIN Departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

-- Find the minimum age among all employees
SELECT MIN(age) 
FROM Employees_3;

-- List the maximum salary for each location.
SELECT location_id, MAX(salary) 
FROM Employees_3 
GROUP BY location_id;

-- Calculate the average salary for each designation containing the word 'Analyst'.
SELECT designation, AVG(salary) 
FROM Employees_3 
WHERE designation LIKE '%Analyst%' 
GROUP BY designation;

-- Find departments with less than 3 employees.
SELECT department_id, COUNT(employee_id) 
FROM Employees_3 
GROUP BY department_id 
HAVING COUNT(employee_id) < 3;

-- Find locations with female employees whose average age is below 30.
SELECT location_id 
FROM Employees_3 
WHERE gender = 'F' 
GROUP BY location_id 
HAVING AVG(age) < 30;

-- List employee names, their designations, and department names where employees are assigned to a department.
SELECT e.employee_name, e.designation, d.department_name 
FROM Employees_3 e
INNER JOIN Departments d ON e.department_id = d.department_id;

-- List all departments along with the total number of employees in each department, including departments with no employees.
SELECT d.department_name, COUNT(e.employee_id) as total_employees
FROM Departments d
LEFT JOIN Employees_3 e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Display all locations along with the names of employees assigned to each location. If no employees are assigned to a location, display NULL for employee name.
SELECT l.location, e.employee_name
FROM Employees_3 e
RIGHT JOIN Location l ON e.location_id = l.location_id;
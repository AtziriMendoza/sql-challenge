--INCORRECT CODE BELOW for Step 1 but keeping it creating the tables in PostGre and importing the CSVs
-- CREATE TABLE departments (
-- 	dept_no VARCHAR,
-- 	dept_name VARCHAR
-- );
--right click the created table and import the CSV tables to their SQL tables
-- checking to see if the data imported
-- select *
-- from departments;
-- repeating the above process for the rest of the tables
 
-- CREATE TABLE dept_emp (
-- 	emp_no INT
-- 	, dept_no VARCHAR
-- );
-- select *
-- from dept_emp;
-- CREATE TABLE dept_manager (
-- 	dept_no VARCHAR
-- 	, emp_no INT	
-- );
-- select *
-- from dept_manager;
-- CREATE TABLE employees (
-- 	emp_no INT
-- 	, emp_title VARCHAR
-- 	, birth_date DATE
-- 	, first_name VARCHAR
-- 	, last_name VARCHAR
-- 	, sex VARCHAR
-- 	, hire_date DATE
-- );
-- select *
-- from employees;
-- CREATE TABLE salaries (
-- 	emp_no INT
-- 	, salary VARCHAR
-- );
-- select *
-- from employees;
-- CREATE TABLE titles (
-- 	title_id VARCHAR
-- 	, title VARCHAR
-- );
-- select *
-- from titles;

--dropping tables

-- DROP TABLE departments; 
-- DROP TABLE dept_emp;
-- DROP TABLE dept_manager;
-- DROP TABLE salaries;
-- DROP TABLE titles;
-- DROP TABLE employees;

--STEP 1) DATA ENGINEERING IMPORT EACH CSV FILE INTO ITS CORRESPONDING SQL TABLE & TABLE SCHEMA (https://app.quickdatabasediagrams.com/#/d/iu44M5)
-- CREATE TABLE "departments" (
--     "dept_no" varchar   NOT NULL,
--     "dept_name" varchar   NOT NULL,
--     CONSTRAINT "pk_departments" PRIMARY KEY (
--         "dept_no"
--      )
-- );

-- SELECT *
-- FROM departments

-- CREATE TABLE "dept_emp" (
--     "emp_no" int   NOT NULL,
--     "dept_no" varchar   NOT NULL,
--     CONSTRAINT "pk_dept_emp" PRIMARY KEY (
--         "emp_no"	
--      )
-- );

-- CREATE TABLE "dept_manager" (
--     "dept_no" varchar   NOT NULL,
--     "emp_no" int   NOT NULL,
--     CONSTRAINT "pk_dept_manager" PRIMARY KEY (
--         "dept_no" --dept_no is not the correct primary key because it has duplicate values below I will switch it to emp_no
--      )
-- );

-- CREATE TABLE "employees" (
--     "emp_no" int   NOT NULL,
--     "emp_title_id" varchar   NOT NULL,
--     "birth_date" date   NOT NULL,
--     "first_name" varchar   NOT NULL,
--     "last_name" varchar   NOT NULL,
--     "sex" varchar   NOT NULL,
--     "hire_date" date   NOT NULL,
--     CONSTRAINT "pk_employees" PRIMARY KEY ("emp_no")
-- );


-- CREATE TABLE "salaries" (
--     "emp_no" int   NOT NULL,
--     "salary" int   NOT NULL,
--     CONSTRAINT "pk_salaries" PRIMARY KEY (
--         "emp_no"
--      )
-- );

-- CREATE TABLE "titles" (
--     "title_id" varchar   NOT NULL,
--     "title" varchar   NOT NULL,
--     CONSTRAINT "pk_titles" PRIMARY KEY ("title_id")
-- );

--CORRECTING ERRORS IN THE TABLE CREATION
-- STEP 1) CORRECTING dept_emp
-- ALTER TABLE dept_emp DROP CONSTRAINT "pk_dept_emp";
-- ALTER TABLE dept_emp ADD CONSTRAINT "pk_dept_emp" PRIMARY KEY ("emp_no", "dept_no");
-- ALTER TABLE dept_emp DROP CONSTRAINT "fk_dept_emp_dept_no";
-- ALTER TABLE dept_emp DROP CONSTRAINT "fk_dept_emp_emp_no";

-- STEP 2) CORRECTING dept_manager
-- ALTER TABLE dept_manager DROP CONSTRAINT "pk_dept_manager";
-- ALTER TABLE dept_manager ADD CONSTRAINT "pk_dept_manager" PRIMARY KEY ("emp_no");
-- ALTER TABLE "dept_manager" DROP CONSTRAINT "fk_dept_manager_emp_no";
-- ALTER TABLE "salaries" DROP CONSTRAINT "fk_salaries_emp_no";
-- STEP 3) CORRECTING employees
-- ALTER TABLE "employees" DROP CONSTRAINT "uq_emp_title_id" 
-- STEP 4) NO ISSUES WITH salaries AND titles

--RERAN -ALTER TABLES WITH DATA IMPORTED
-- ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
-- REFERENCES "departments" ("dept_no");
-- ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
-- REFERENCES "employees" ("emp_no");
-- ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY ("dept_no")
-- REFERENCES "departments" ("dept_no");
-- ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY ("emp_no")
-- REFERENCES "employees" ("emp_no");
-- ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
-- REFERENCES "employees" ("emp_no");
-- ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
-- REFERENCES "titles" ("title_id");
-- ALTER TABLE "employees" ADD CONSTRAINT "uq_emp_title_id" UNIQUE ("emp_title_id")


--STEP 2) DATA ANALYSIS
--List the employee number, last name, first name, sex, and salary of each employee
SELECT
	EMP.emp_no --I ran it wrapped in distinct just in case there may be a duplicate and there wasn't
	, EMP.last_name
	, EMP.first_name
	, EMP.sex
	, SAL.salary
FROM employees EMP 
INNER JOIN salaries SAL ON (EMP.emp_no = SAL.emp_no);

--List the first name, last name, and hire date for the employees who were hired in 1986.
-- SELECT
-- 	first_name
-- 	, last_name
-- 	, hire_date
-- FROM employees
-- WHERE extract(year from hire_date) = '1986'

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
-- SELECT
-- DM.dept_no
-- , DEP.dept_name
-- , EMP.emp_no
-- , EMP.last_name
-- , EMP.first_name
-- FROM employees EMP
-- INNER JOIN dept_manager DM ON (EMP.emp_no = DM.emp_no)
-- INNER JOIN departments DEP ON (DM.dept_no = DEP.dept_no)

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name
-- SELECT
-- DE.dept_no
-- , EMP.emp_no
-- , EMP.last_name
-- , EMP.first_name
-- , DEP.dept_name
-- FROM employees EMP
-- INNER JOIN dept_emp DE ON (EMP.emp_no = DE.emp_no)
-- INNER JOIN departments DEP ON (DE.dept_no = DEP.dept_no)

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
-- SELECT
-- first_name
-- , last_name
-- , sex
-- FROM employees
-- WHERE first_name = 'Hercules' and last_name LIKE 'B%' --when using the wild card character use the command LIKE
--List each employee in the Sales department, including their employee number, last name, and first name.
-- SELECT
-- DEP.dept_name
-- , DE.emp_no
-- , EMP.last_name
-- , EMP.first_name 
-- FROM employees EMP
-- INNER JOIN dept_emp DE ON (EMP.emp_no = DE.emp_no)
-- INNER JOIN departments DEP ON (DE.dept_no = DEP.dept_no )
-- WHERE DEP.dept_name = 'Sales'

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- SELECT
-- DEP.dept_name
-- , DE.emp_no
-- , EMP.last_name
-- , EMP.first_name 
-- FROM employees EMP
-- INNER JOIN dept_emp DE ON (EMP.emp_no = DE.emp_no)
-- INNER JOIN departments DEP ON (DE.dept_no = DEP.dept_no )
-- WHERE DEP.dept_name = 'Sales' OR DEP.dept_name = 'Development' --using the OR clause because the row can satisfy the condition set by either or both of the search condition
--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
-- SELECT
-- DISTINCT(last_name),
-- count(last_name) count
-- FROM employees
-- GROUP BY last_name 
-- ORDER BY count DESC
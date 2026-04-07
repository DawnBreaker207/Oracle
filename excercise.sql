-- Oracle practice question on HR schema:
-- Link: https://github.com/oracle-samples/db-sample-schemas

-- 1. Display details of jobs where the minimum salary is greater than 10000.
SELECT * FROM jobs WHERE jobs.min_salary > 10000;


-- 2. Display the first name and join date of the employees who joined between 2002 and 2005.
 SELECT first_name, last_name, start_date 
 FROM employees e 
 JOIN job_history j ON e.employee_id = j.employee_id 
 WHERE start_date 
 BETWEEN DATE '2002-01-01' AND  DATE '2005-12-31';


-- 3. Display first name and join date of the employees who is either IT Programmer or Sales Man.
SELECT first_name, start_date 
FROM employees e 
JOIN job_history jh ON e.employee_id = jh.employee_id 
JOIN jobs j ON e.job_id = j.job_id  
WHERE j.job_title 
IN ('IT Programmer', 'Sales Man');


-- 4. Display employees who joined after 1st January 2008.
SELECT * FROM employees e 
JOIN job_history jh ON e.employee_id = jh.employee_id 
WHERE jh.start_date > DATE '2008-01-01';


-- 5. Display details of employee with ID 150 or 160.
SELECT *
FROM employees
WHERE employee_id IN (150, 160);


-- 6. Display first name, salary, commission pct, and hire date for employees with salary less than 10000.
SELECT first_name, salary, commission_pct, hire_date
FROM employees
WHERE salary < 10000;


-- 7. Display job Title, the difference between minimum and maximum salaries for jobs with max salary in the range 10000 to 20000.
SELECT job_title,
       max_salary - min_salary AS salary_difference
FROM jobs
WHERE max_salary BETWEEN 10000 AND 20000;


-- 8. Display first name, salary, and round the salary to thousands.
SELECT first_name,
       salary,
       ROUND(salary, -3) AS rounded_salary
FROM employees;


-- 9. Display details of jobs in the descending order of the title.
SELECT *
FROM jobs
ORDER BY job_title DESC;


-- 10. Display employees where the first name or last name starts with S.
SELECT first_name, last_name, salary
FROM employees
WHERE first_name LIKE 'S%'
   OR last_name LIKE 'S%';


-- 11. Display employees who joined in the month of May.
SELECT *
FROM employees
WHERE EXTRACT(MONTH FROM hire_date) = 5;


-- 12. Display details of the employees where commission percentage is null and salary in the range 5000 to 10000 and department is 30.
SELECT *
FROM employees
WHERE commission_pct IS NULL
  AND salary BETWEEN 5000 AND 10000
  AND department_id = 30;


-- 13. Display first name and date of first salary of the employees.
SELECT first_name, hire_date
FROM employees;


-- 14. Display first name and experience of the employees.
SELECT first_name,
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)/12) AS experience_years
FROM employees;


-- 15. Display first name of employees who joined in 2001.
SELECT first_name
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2001;


-- 16. Display first name and last name after converting the first letter of each name to upper case and the rest to lower case.
SELECT INITCAP(first_name) AS first_name,
       INITCAP(last_name) AS last_name
FROM employees;


-- 17. Display the first word in job title.
SELECT job_title,
       SUBSTR(job_title, 1, INSTR(job_title, ' ') - 1) AS first_word
FROM jobs;


-- 18. Display the length of first name for employees where last name contain character ‘b’ after 3rd position.
SELECT first_name,
       LENGTH(first_name) AS name_length
FROM employees
WHERE INSTR(LOWER(last_name), 'b') > 3;


-- 19. Display first name in upper case and email address in lower case for employees where the first name and email address are same irrespective of the case.
SELECT UPPER(first_name) AS first_name,
       LOWER(email) AS email
FROM employees
WHERE LOWER(first_name) = LOWER(email);


-- 20. Display employees who joined in the current year.
SELECT *
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = EXTRACT(YEAR FROM SYSDATE);


-- 21. Display the number of days between system date and 1st January 2011.
SELECT SYSDATE - DATE '2011-01-01' AS days_difference
FROM dual;


-- 22. Display how many employees joined in each month of the current year.
SELECT EXTRACT(MONTH FROM hire_date) AS month,
       COUNT(*) AS total_employees
FROM employees
WHERE hire_date >= TRUNC(SYSDATE, 'YEAR')
  AND hire_date < ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 12)
GROUP BY EXTRACT(MONTH FROM hire_date)
ORDER BY month;


-- 23. Display manager ID and number of employees managed by the manager.
SELECT manager_id,
       COUNT(*) AS total_employees
FROM employees
GROUP BY manager_id;


-- 24. Display number of employees joined after 15th of the month.
SELECT COUNT(*) AS total_employees
FROM employees
WHERE EXTRACT(DAY FROM hire_date) > 15;


-- 25. Display the country ID and number of cities we have in the country.
SELECT country_id,
       COUNT(*) AS total_cities
FROM locations
GROUP BY country_id;
-- 26. Display average salary of employees in each department who have commission percentage.
-- 27. Display job ID, number of employees, sum of salary, and difference between highest salary and lowest salary of the employees of the job.
-- 28. Display job ID for jobs with average salary more than 10000.
-- 29. Display years in which more than 10 employees joined.

-- 30. Display departments in which more than five employees have commission percentage.
-- 31. Display employee ID for employees who did more than one job in the past.
-- 32. Display job ID of jobs that were done by more than 3 employees for more than 100 days.
-- 33. Display department ID, year, and Number of employees joined.
-- 34. Display departments where any manager is managing more than 5 employees.
-- 35.Change salary of employee 115 to 8000 if the existing salary is less than 6000.
-- 36. Insert a new employee into employees with all the required details.
-- 37. Delete department 20.
-- 38.Change job ID of employee 110 to IT_PROG if the employee belongs to department
-- 10 and the existing job ID does not start with IT.
-- 39. Insert a row into departments table with manager ID 120 and location ID in any location ID for city Tokyo.
-- 40. Display department name and number of employees in the department.
-- 41. Display job title, employee ID, number of days between ending date and starting date for all jobs in department 30 from job history.
-- 42. Display department name and manager first name.
-- 43. Display department name, manager name, and city.
-- 44. Display country name, city, and department name.
-- 45. Display job title, department name, employee last name, starting date for all jobs from 2000 to 2005.
-- 46. Display job title and average salary of employees
-- 47. Display job title, employee name, and the difference between maximum salary for the job and salary of the employee.
-- 48. Display last name, job title of employees who have commission percentage and belongs to department 30.
-- 49. Display details of jobs that were done by any employee who is currently drawing more than 15000 of salary.
-- 50. Display department name, manager name, and salary of the manager for all managers whose experience is more than 5 years.
-- 51. Display employee name if the employee joined before his manager.
-- 52. Display employee name, job title for the jobs employee did in the past where the job was done less than six months.
-- 53. Display employee name and country in which he is working.
-- 54. Display department name, average salary and number of employees with commission within the department.
-- 55. Display the month in which more than 5 employees joined in any department located in Sydney.
-- 56. Display details of departments in which the maximum salary is more than 10000.
-- 57. Display details of departments managed by ‘Smith’.
-- 58. Display jobs into which employees joined in the current year.
-- 59. Display employees who did not do any job in the past.
-- 60. Display job title and average salary for employees who did a job in the past.
-- 61. Display country name, city, and number of departments where department has more than 5 employees.
-- 62. Display details of manager who manages more than 5 employees.
-- 63. Display employee name, job title, start date, and end date of past jobs of all employees with commission percentage null.
-- 64. Display the departments into which no employee joined in last two years.
-- 65. Display the details of departments in which the max salary is greater than 10000 for employees who did a job in the past.
-- 66. Display details of current job for employees who worked as IT Programmers in the past.
-- 67. Display the details of employees drawing the highest salary in the department.
-- 68. Display the city of employee whose employee ID is 105.
-- 69. Display third highest salary of all employees
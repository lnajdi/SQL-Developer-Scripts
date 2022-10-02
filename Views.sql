--DML Operations and Views

CREATE OR REPLACE VIEW view_employees
AS SELECT employee_id,first_name, last_name, email
FROM employees
WHERE employee_id BETWEEN 100 and 124;


select *  from user_views;  
desc user_views;

-- make a copy  of the employee table
create table copy_employees as select * from employees;

CREATE OR replace VIEW view_dept50
AS SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id= 50;

-- In order to verify that the view has been generated
select * from view_dept50;

--or consult the data dictionary 
select * from user_views where VIEW_NAME = 'VIEW_DEPT50';

select employee_id , department_id 
from  copy_employees where employee_id = 144;
select count(*) from view_dept50;

UPDATE view_dept50
SET department_id= 90
WHERE employee_id= 144;

select employee_id , department_id 
from  copy_employees where employee_id = 144;
select count(*) from view_dept50;


--Let's try WITH THE CHECK OPTION.
CREATE OR REPLACE VIEW view_dept50
AS SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id= 50
WITH CHECK OPTION CONSTRAINT view_dept50_check;

UPDATE view_dept50
SET department_id= 90
WHERE employee_id= 144;
-- we get ORA-01402: vue WITH CHECK OPTION - violation de clause WHERE

select * from user_constraints
where constraint_name = 'VIEW_DEPT50_CHECK';

--C (check constraint on a table)
--P (primary key)
--U (unique key)
--R (referential integrity)
--V (with check option, on a view)
--O (with read only, on a view)


CREATE OR REPLACE VIEW view_dept50
AS SELECT department_id, employee_id, first_name, last_name, salary
FROM employees
WHERE department_id= 50
WITH READ ONLY;


select * from user_constraints
where table_name = 'VIEW_DEPT50';


--Managing Views
select * from user_views
where view_name = 'VIEW_DEPT50';

drop view VIEW_DEPT50;


--Inline Views
SELECT e.last_name, e.salary, e.department_id, d.maxsal
FROM employees e,
(SELECT department_id, max(salary) maxsal
FROM employees
GROUP BY department_id) d
WHERE e.department_id = d.department_id
--AND e.salary = d.maxsal
order by e.last_name;


SELECT last_name, salary, department_id,
    max(salary) over(PARTITION BY department_id) as maxsal    
FROM employees 
order by last_name;


SELECT last_name, salary, department_id,
    max(salary) over(partition by department_id) as maxsal_dep ,
    max(salary) over(partition by job_id) as maxsal_job    
FROM employees 
order by last_name;

desc employees;

select max(salary) from employees;

--TOP-N-ANALYSIS
SELECT ROWNUM AS "Longest employed", last_name, hire_date
FROM (SELECT last_name, hire_date
FROM employees
ORDER BY hire_date)
WHERE ROWNUM <=5;

SELECT last_name, hire_date
FROM employees
ORDER BY hire_date
fetch first 5 rows only;

--using rank 
SELECT last_name, hire_date , 
    RANK() OVER (ORDER BY hire_date) "Longest employed"
FROM employees;



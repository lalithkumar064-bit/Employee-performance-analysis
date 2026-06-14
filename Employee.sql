create database project;
use project
create table employee(
Employee_ID int,
First_Name varchar(500),
Last_Name varchar(500),
Age int,
Department_Region varchar(500),
Statuss varchar(1000),
Join_Date varchar(100),
Salary decimal(7,2),
Email varchar(300),
Phone int,
Performance_Score varchar(400),
Remote_Work varchar(600));
select*from employee

alter table employee
modify salary varchar(300)

desc employee

SET autocommit = 1;
CREATE TABLE employee_backup AS
SELECT *
FROM employee;

select * from employee

select count(*),
substring_index(department_Region,'-',1)as department,
substring_index(department_Region,'-',-1)as department from employee
group by substring_index(department_Region,'-',1),
substring_index(department_Region,'-',-1)

alter table employee
add column region varchar(100)

start transaction;
update employee
set region = substring_index(department_region,'-',-1);
commit
set sql_safe_updates=0

select count(department) from employee

alter table employee
drop column first_name,
drop column last_name

alter table employee
add column name varchar(1000)

start transaction;
update employee
set name = concat(first_name,' ',last_name)

start transaction;
UPDATE employee
SET Phone = REPLACE(Phone, '-', '');
SET @avg_age = (
    SELECT ROUND(AVG(Age))
    FROM employee
);

UPDATE employee
SET Age = @avg_age
WHERE Age ='';

SELECT statuss
FROM employee
WHERE statuss <> 'Active'
  AND statuss <> 'Pending'
  AND statuss <> 'Inactive';
  
  select * from employee
  
  select sum(statuss is null or trim(statuss)=''),
  sum(join_date is null or trim(join_date)=''),
  sum(salary is null or trim(salary)=''),
  sum(email is null or trim(email)='') ,
  sum(phone is null or trim(phone)=''),
  sum(performance_score is null or trim(performance_score)=''),
  sum(remote_work is null or trim(remote_work)='')
  from employee
  
  select count(join_date) from employee
  where str_to_date(join_date,'%Y-%m-%d') is null
  and join_date is not null
  

SELECT *
FROM employee
WHERE STR_TO_DATE(join_date,'%d/%m/%Y') IS NULL;

  select distinct(join_date) from employee
  where str_to_date(join_date,'%Y-%m-%d') is null
  and join_date is not null
  
  SELECT join_date,
       STR_TO_DATE(join_date,'%Y.%m.%d') AS converted
FROM employee
LIMIT 20;

ALTER TABLE employee
ADD clean_join_date DATE;

START TRANSACTION;
UPDATE employee
SET clean_join_date =
CASE
    WHEN join_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        THEN STR_TO_DATE(join_date,'%m/%d/%Y')

    WHEN join_date REGEXP '^[0-9]{1,2}-[0-9]{1,2}-[0-9]{4}$'
        THEN STR_TO_DATE(join_date,'%d-%m-%Y')

    WHEN join_date REGEXP '^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}$'
        THEN STR_TO_DATE(join_date,'%Y-%m-%d')

    WHEN join_date REGEXP '^[0-9]{4}/[0-9]{1,2}/[0-9]{1,2}$'
        THEN STR_TO_DATE(join_date,'%Y/%m/%d')

    ELSE clean_join_date
END;

select clean_join_date from employee
where clean_join_date is null

select clean_join_date from  employee 
where str_to_date(clean_join_date,'%Y-%m-%d') is null
and clean_join_date is not null

commit

start transaction;
alter table employee
drop column join_date;

select*from employee

WITH q AS (
    SELECT
        salary,
        NTILE(4) OVER (ORDER BY salary) AS quartile
    FROM employee
)
SELECT
    MAX(CASE WHEN quartile = 1 THEN salary END) AS q1,
    MAX(CASE WHEN quartile = 3 THEN salary END) AS q3
FROM q; exp

alter table employee
modify column salary decimal(10,2)

UPDATE employee
SET statuss =
CONCAT(
    UPPER(LEFT(TRIM(statuss),1)),
    LOWER(SUBSTRING(TRIM(statuss),2))
)

SELECT
    MIN(CAST(salary AS DECIMAL(10,2))) AS min_salary,
    MAX(CAST(salary AS DECIMAL(10,2))) AS max_salary,
    avg(cast(salary as decimal(10,2))) as avg_salary
FROM employee
WHERE salary REGEXP '^[0-9]+(\\.[0-9]+)?$';


select salary from employee 
where salary not regexp '^[0-9]+'

start transaction;
UPDATE employee
SET Salary = NULL
WHERE Salary NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
rollback

select salary from employee
where salary is not null
order by salary


select max(salary),department from employee
group by department 
limit 5

with total_salary as (select department,sum(salary)tt from employee group by department)

select department, tt*100.0/sum(tt) over() from total_salary

WITH total_salary AS (
    SELECT
        department,
        SUM(CAST(salary AS DECIMAL(10,2))) AS dept_salary
    FROM employee
    GROUP BY department
)
select*from employee

SELECT
    department,
    ROUND(
        dept_salary * 100.0 /
        SUM(dept_salary) OVER (),
        2
    ) AS salary_percentage
FROM total_salary;


select department,sum(salary) from employee group by department order by sum(salary) desc  

select statuss,count(*) from employee
group by statuss
order by statuss desc


with avg_salary as (select avg(salary)avs from employee)
select employee_id,salary,performance_score from employee
where performance_score ='excellent'
and salary<(select avg(salary) from employee)

select department,count(*) from employee
group by department

select employee_id,department,salary from
(select *,rank() over(partition by department order by salary desc)rnk from employee)x where rnk =1

with total_salary as(select department,sum(salary)tt from employee group by department)
select department,round(tt*100.0/sum(tt) over() ,2)as percent from total_salary

select remote_work , count(*) from employee group by remote_work

select remote_work,sum(salary) from employee
group by remote_work order by sum(salary) desc

select age , sum(salary) from employee group by age

select performance_score,count(*) from employee group by performance_score

select employee_id,salary,performance_score from employee
where performance_score ='poor'
and salary>(select avg(salary) from employee)
order by salary desc


select year(clean_join_date),count(*) from employee
group by year(clean_join_date)

WITH avg_sales AS (
    SELECT
        department,
        performance_score,
        AVG(salary) AS ai
    FROM employee
    GROUP BY department, performance_score
)

SELECT
    a.department,
    a.performance_score,
    a.salary
FROM employee a
JOIN avg_sales d
    ON d.department = a.department
   AND d.performance_score = a.performance_score
WHERE LOWER(a.performance_score) = 'excellent'
  AND a.salary < d.ai
ORDER BY a.salary DESC;

select department,avg(salary) from employee
where department = 'devops'

with avg_dep as(select name,department,salary,avg(salary) over(partition by department)average from employee)
select* from avg_dep
where salary>average
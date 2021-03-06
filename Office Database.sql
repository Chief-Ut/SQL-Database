CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER table employee
add foreign key(branch_id) references branch(branch_id) on delete set null;

alter table employee
add foreign key (super_id) references employee(emp_id) on delete set null;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);


CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
  branch_id INT,
  supplier_names varchar(40),
  supplier_type varchar(40),
  primary key(branch_id, supplier_names),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE cascade
);

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

update employee
set branch_id = 1
where emp_id= 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- scranton branch

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);
---------------------------------------------------
select * from employee;
select * from branch;
select * from client;
select * from branch_supplier;

----------------------------------------------------------------

-- Find all employee
select * from employee;
-- Find all employee ordered by

select * from employee
order by salary desc;

-- Find all employees ordered by sex then name
select * from employee
order by sex, first_name,last_name;

-- Find the first 5 employees in the table
select * from employee
limit 5;

-- Find forename and surname of employee
 select first_name as forename, last_name as surname
 from employee;
 
 -- Find out all the differentt genders
 select distinct sex 
 from employee;
 
 -- FUNCTIONS
 
 -- Find number of salesman
 select count(emp_id) as count
 from employee;
 
 -- Find the number of females employees born after 1970
 select count(emp_id) 
 from employee
 where sex = 'F' and birth_day > '1970-01-01';
 
 -- Find the average of all employee's salaries 
 select avg(salary)
 from employee;
 
 
-- Find out how mamy males and feamales are there 
select count(sex), sex
from employee
group by sex;

-- find the total sales of each salesman

select  emp_id, sum(total_sales) as total_sales
from works_with
group by emp_id
order by emp_id asc ;

-- find any branch suppliers who are in label business

select supplier_names
from branch_supplier
where supplier_names like '%label%';

-- select employee born in october
select *
from employee
where birth_day like '____-10%';

-- find any client who are schools

select * 
from client
where client_name like '%school%';

-- JOINS
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);
-- Find all branches and the names of their managers

select  employee.first_name, branch.branch_name
from employee
right join branch
on employee.emp_id= branch.mgr_id;

-- Nested Queries

-- Find names of all employees who have sold over 50,000
select employee.first_name, employee.last_name
from employee
where employee.emp_id in (
        select works_with.emp_id
		from works_with
		where works_with.total_sales > 30000
);


 -- Find all clients who are handled by the branch that Michael Scott manages
 -- Assume you know Michael's ID

 select client.client_id, client.client_name
 FROM client
 where branch_id in(
      select branch.branch_id
      from branch
      where mgr_id= 102
);

 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 
  select client.client_id, client.client_name
 FROM client
 where branch_id in(
      select branch.branch_id
      from branch
      where mgr_id in (
			select employee.emp_id
            from employee
            where employee.first_name like 'Michael%'
)
);
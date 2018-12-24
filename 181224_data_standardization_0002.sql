drop table if exists Job;
create table Job (
   id varchar(45) not null,
   title varchar(45) not null,
   min_salary int default 0,
   max_salary int default 0,
   primary key(id)
);


drop table if exists Department;
create table Department (
   id int default 0 not null,
   name varchar(45) not null,
   manager_id int default 0,
   primary key(id)
);


drop table if exists Employee;
create table Employee (
   id int default 0 not null,
   first_name varchar(45),
   last_name varchar(45) not null,
   email varchar(45) not null,
   tel varchar(45),
   hire_date datetime default current_timestamp not null,
   job varchar(45) not null default '',
   salary int default 0,
   commission_pct int default 0,
   manager_id int default 0,
   department int default 0,
   primary key(id)
);


drop table if exists JobHistory;
create table JobHistory (
   employee int not null,
   start_date datetime not null,
   end_date datetime not null,
   job varchar(45) not null,
   department int default 0,
   primary key(employee, start_date)
);


select * from Job;
desc Job;
select * from Department;
desc Department;
select * from Employee;
desc Employee;
select * from JobHistory;
desc Jobhistory;



alter table Employee
add constraint uq_email unique (email);

alter table Employee
add constraint f_employee_id_manager_id foreign key (manager_id) references Employee(id);

alter table Employee
add constraint f_employee_job_id foreign key (job) references Job(id);

alter table Employee
add constraint f_employee_department_id foreign key (department) references Department(id);

alter table Department
add constraint f_department_manager_id_employee_id foreign key (manager_id) references Employee(id);

alter table JobHistory
add constraint f_jobhistory_employee_id foreign key (employee) references Employee(id);

alter table JobHistory
add constraint f_jobhistory foreign key (job) references Job(id);

alter table Employee
add constraint f_jobhistory_department_id foreign key (manager_id) references Department(id);



show index from Employee;
show index from Job;
show index from JobHistory;
show index from Department;

import migration_oracle_to_mysql_util_0001 as mu



source_tables ={"JOBS" : "JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY", 
                "DEPARTMENTS" : "DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID", 
                "EMPLOYEES" : "EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID", 
                "JOB_HISTORY" : "EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID"}


target_tables ={"Job" : '''id varchar(45) not null,
                         title varchar(45) not null,
                         min_salary int default 0,
                         max_salary int default 0,
                         primary key(id)''', 
                "Department" : '''id int,
                                 name varchar(45) not null,
                                 manager_id int default 0,
                                 primary key(id)''', 
                "Employee" : '''id int default 0 not null,
                                first_name varchar(45),
                                last_name varchar(45) not null,
                                email varchar(45) not null,
                                tel varchar(45),
                                hire_date datetime not null,
                                job varchar(45) not null,
                                salary int default 0,
                                commission_pct float(4,2) default 0,
                                manager_id int default 0,
                                department int default 0,
                                primary key(id)''', 
                "JobHistory" : '''employee int not null,
                                  start_date datetime not null,
                                  end_date datetime not null,
                                  job varchar(45) not null,
                                  department int default 0,
                                  primary key(employee, start_date)'''}


conn_mysql = mu.connect_mysql("dooodb")

with conn_mysql:
    cur_mysql = conn_mysql.cursor()

    for target_table_name in target_tables:
        print(1)
        sql_sp = "call sp_drop_fk_refs(" + '"' + target_table_name + '"' + ")"
        print(sql_sp)
        cur_mysql.execute(sql_sp)
        print(2)
        sql_drop = "drop table if exists " + target_table_name
        print(sql_drop)
        cur_mysql.execute(sql_drop)
        print(3)
        sql_create = 'create table ' + target_table_name + ' (' + target_tables[target_table_name] + ')'
        cur_mysql.execute(sql_create)
        print(4)

        if target_table_name == "Job":
            conn_oracle = mu.connect_oracle()
            with conn_oracle:
                # cursor를 만들어줍니다
                cursor = conn_oracle.cursor()
                sql = 'select ' + source_tables["JOBS"] + ' from JOBS'
                cursor.execute(sql)
                rows = cursor.fetchall()
            print(5)
            sql_insert = "insert into " + target_table_name + "(id, title, min_salary, max_salary) values(%s, %s, %s, %s)"
            print(6)
            cur_mysql.executemany(sql_insert, rows)
            print(7)
        elif target_table_name == "Department":
            conn_oracle = mu.connect_oracle()
            with conn_oracle:
                # cursor를 만들어줍니다
                cursor = conn_oracle.cursor()
                sql = 'select ' + source_tables["DEPARTMENTS"] + ' from DEPARTMENTS'
                cursor.execute(sql)
                rows = cursor.fetchall()
            print(5)
            sql_insert = "insert into " + target_table_name + "(id, name, manager_id) values(%s, %s, %s)"
            print(6)
            cur_mysql.executemany(sql_insert, rows)
            print(7)
        elif target_table_name == "Employee":
            conn_oracle = mu.connect_oracle()
            with conn_oracle:
                # cursor를 만들어줍니다
                cursor = conn_oracle.cursor()
                sql = 'select ' + source_tables["EMPLOYEES"] + ' from EMPLOYEES'
                cursor.execute(sql)
                rows = cursor.fetchall()
            print(5)
            sql_insert = "insert into " + target_table_name + "(id, first_name, last_name, email, tel, hire_date, job, salary, commission_pct, manager_id, department) values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
            print(6)
            print(sql_insert)
            cur_mysql.executemany(sql_insert, rows)
            print(7)
        else:
            conn_oracle = mu.connect_oracle()
            with conn_oracle:
                # cursor를 만들어줍니다
                cursor = conn_oracle.cursor()
                sql = 'select ' + source_tables["JOB_HISTORY"] + ' from JOB_HISTORY'
                cursor.execute(sql)
                rows = cursor.fetchall()
            print(5)
            sql_insert = "insert into " + target_table_name + "(employee, start_date, end_date, job, department) values(%s, %s, %s, %s, %s)"
            print(6)
            cur_mysql.executemany(sql_insert, rows)
            print(7)

    cur_mysql.execute('''alter table Employee
                        add constraint uq_email unique (email)''')

    cur_mysql.execute('''alter table Employee
                        add constraint f_employee_id_manager_id foreign key (manager_id) references Employee(id)''')

    cur_mysql.execute('''alter table Employee
                        add constraint f_employee_job_id foreign key (job) references Job(id)''')

    cur_mysql.execute('''alter table Employee
                        add constraint f_employee_department_id foreign key (department) references Department(id)''')

    cur_mysql.execute('''alter table Department
                        add constraint f_department_manager_id_employee_id foreign key (manager_id) references Employee(id)''')
                                            
    cur_mysql.execute('''alter table JobHistory
                        add constraint f_jobhistory_employee_id foreign key (employee) references Employee(id)''')

    cur_mysql.execute('''alter table JobHistory
                        add constraint f_jobhistory foreign key (job) references Job(id)''')

    cur_mysql.execute('''alter table JobHistory
                        add constraint f_jobhistory_department_id foreign key (department) references Department(id);''')


    print("AffectedRowCount is ", cur_mysql.rowcount)




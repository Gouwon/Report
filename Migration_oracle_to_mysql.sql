import migration_oracle_to_mysql_util_0001 as mu

target_to_source ={"Job" : "JOBS", "Department" : "DEPARTMENTS", "Employee" : "EMPLOYEES", "JobHistory": "JOB_HISTORY"}

conn_mysql = mu.connect_mysql("dooodb")

with conn_mysql:
    cur_mysql = conn_mysql.cursor()

    for target_table_name in target_to_source:
        mu.create_table(target_table_name)
        mu.set_data(cur_mysql, target_table_name)


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



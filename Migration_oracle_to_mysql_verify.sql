import migration_oracle_to_mysql_util_0001 as mu

conn_oracle = mu.connect_oracle()
conn_mysql = mu.connect_mysql("dooodb")

source_tables ={"JOBS" : "JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY", 
                "DEPARTMENTS" : "DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID", 
                "EMPLOYEES" : "EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID", 
                "JOB_HISTORY" : "EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID"}
target_tables ={"Job" : "id, title, min_salary, max_salary",
                "Department" : "id, name, manager_id",
                "Employee" : "id, first_name, last_name, email, tel, hire_date, job, salary, commission_pct, manager_id, department",
                "JobHistory" : "employee, start_date, end_date, job, department"}
target_to_source ={"Job" : "JOBS", "Department" : "DEPARTMENTS", "Employee" : "EMPLOYEES", "JobHistory": "JOB_HISTORY"}


with conn_mysql:
    cur_mysql = conn_mysql.cursor()

    for target_to_source_name in target_to_source:
        mysql_cnt = mu.get_count(conn_mysql, target_to_source_name)
        mysql_smpls = mu.get_sample(conn_mysql, target_to_source_name, "5")
           
        conn_oracle = mu.connect_oracle()
        with conn_oracle:
            cursor = conn_oracle.cursor()
            oracle_cnt = mu.get_count(conn_oracle, target_to_source[target_to_source_name])

            if oracle_cnt != mysql_cnt:
                print("NOT VALIED!!!! \nmysql_cnt = ", mysql_cnt, "\noracle_cnt = ", oracle_cnt)
                break
            else:
                print("Count is OK")
                for i, j in enumerate(mysql_smpls):
                    oracle_smpls = mu.get_sample_verify1(conn_oracle, target_to_source[target_to_source_name], source_tables[target_to_source[target_to_source_name]], j[0], j[1] )
                    print("mysql_smpls >>>>>>>>>>>>>>>>>>>>",j)
                    print("<<<<<<<<<<<<<<<<<<< oracle_smpls",oracle_smpls[0])
                    if j[0:] == oracle_smpls[0][0:]:
                        print("SQL {:d} of {} : OOOOOKKKKK".format(i + 1, target_to_source_name))
                        print("==========================================================================================================================================")
                    else:
                        print("NOT MATCHED!!!!!")
                        break
    

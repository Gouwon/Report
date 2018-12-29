import migration_oracle_to_mysql_util_0001 as mu

conn_oracle = mu.connect_oracle()
conn_mysql = mu.connect_mysql("dooodb")

table_name = 'Subject'
column_name = "id, name, profm classroom"


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
        print(target_to_source_name)
        print(mysql_cnt, mysql_smpls)
        print(len(mysql_smpls))
           
        conn_oracle = mu.connect_oracle()
        with conn_oracle:
            # cursor를 만들어줍니다
            cursor = conn_oracle.cursor()
            oracle_cnt = mu.get_count(conn_oracle, target_to_source[target_to_source_name])
            print("------------------------", target_to_source[target_to_source_name],oracle_cnt, mysql_cnt)

            if oracle_cnt != mysql_cnt:
                print("NOT VALIED!!!! \nmysql_cnt = ", mysql_cnt, "\noracle_cnt = ", oracle_cnt)
                break
            else:
                print("Count is OK")
                for i, j in enumerate(mysql_smpls):
                    oracle_smpls = mu.get_sample_verify1(conn_oracle, target_to_source[target_to_source_name], source_tables[target_to_source[target_to_source_name]], mysql_smpls, mysql_smpls[i][0], mysql_smpls[i][1] )
                    print(">>>>>>>>>>>>>>>>>>>",mysql_smpls)
                    print("<<<<<<<<<<<<<<<<<<<",oracle_smpls)
                    if mysql_smpls[i][0:] == oracle_smpls[0][0:]:
                        print("OOOOOKKKKK")
                    else:
                        print("NOT MATCHED!!!!!")
                        break
        
                    # rows = cursor.fetchall()



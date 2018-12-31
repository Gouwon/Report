import pymysql
import cx_Oracle

def connect_mysql(db):
    return pymysql.connect(
        host='localhost',
        user='dooo',
        password='root1!',
        port=3306,
        db=db,
        charset='utf8')

def connect_oracle():
    return cx_Oracle.connect("hr", "hrpw", "localhost:1521/xe")

    
def get_count(dbms, tbl, where = ''):
    if dbms == "mysql":
        conn = connect_mysql("dooodb")
        print("Connecting to MySQL .........")
    elif dbms == "oracle":
        conn = connect_oracle()
        print("Connecting to Oracle .........")
    else:
        print("Wrong DBMS! Please Check again")
        exit()
    with conn:
        cur = conn.cursor()
        sql = "select count(*) from " + tbl
        if where != '':
            sql = sql + " where " + where
        print("SQL from {} : {}\n".format(dbms, sql))
        cur.execute(sql)
        return cur.fetchone()[0]

def get_sample(dbms, tbl, n):
    target_tables ={"Job" : "id, title, min_salary, max_salary",
                    "Department" : "id, name, manager_id",
                    "Employee" : "id, first_name, last_name, email, tel, hire_date, job, salary, commission_pct, manager_id, department",
                    "JobHistory" : "employee, start_date, end_date, job, department"}

    if dbms == "mysql":
        conn = connect_mysql("dooodb")
        print("Connecting to MySQL .........")
    elif dbms == "oracle":
        conn = connect_oracle()
        print("Connecting to Oracle .........")
    else:
        print("Wrong DBMS! Please Check again")
        exit()
    with conn:
        cur = conn.cursor()
        sql = "select " + target_tables[tbl] +" from " + tbl + " order by rand() limit " + str(n)
        cur.execute(sql)
        rows = cur.fetchall()
    print("Getting Sample Data from {}".format(dbms))
    return rows
        
def get_sample_to_verify(tbl, condition1, condition2):    
    source_tables ={"JOBS" : "JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY", 
                    "DEPARTMENTS" : "DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID", 
                    "EMPLOYEES" : "EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID", 
                    "JOB_HISTORY" : "EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID"}

    rows = []
    if tbl == "JOBS":
        where = "where job_id = " + "'" + str(condition1) + "'"
    elif tbl == "DEPARTMENTS":
        where = "where department_id = " + str(condition1)
    elif tbl == "EMPLOYEES":
        where = "where employee_id = " + "'" + str(condition1) + "'"
    else:
        where = "where employee_id = " + "'" + str(condition1) + "'" + " and start_date =  to_date(" + "'" +  str(condition2) + "', 'YY/MM/DD HH24:MI:SS')"

    columns = source_tables[tbl]    
    sql = 'select ' + columns + ' from ' + tbl + ' ' + where
    print("from Oracle : \n{} \n".format(sql))
    conn = connect_oracle()
    with conn:
        cur = conn.cursor()
        cur.execute(sql)
        rows.append(cur.fetchone()) 
    return rows

def set_data(db, target_table_name):
    target_to_source ={"Job" : "JOBS", "Department" : "DEPARTMENTS", "Employee" : "EMPLOYEES", "JobHistory": "JOB_HISTORY"}
    source_tables ={"JOBS" : "JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY", 
                "DEPARTMENTS" : "DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID", 
                "EMPLOYEES" : "EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID", 
                "JOB_HISTORY" : "EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID"}
    target_tables ={"Job" : "id, title, min_salary, max_salary",
                   "Department" : "id, name, manager_id",
                   "Employee" : "id, first_name, last_name, email, tel, hire_date, job, salary, commission_pct, manager_id, department",
                   "JobHistory" : "employee, start_date, end_date, job, department"}

    conn_oracle = connect_oracle()
    with conn_oracle:
        cursor = conn_oracle.cursor()
        sql = 'select ' + source_tables[target_to_source[target_table_name]] + ' from ' + target_to_source[target_table_name]
        print("Oracle SQL : ", sql)
        cursor.execute(sql)
        rows = cursor.fetchall()

    conn_mysql = connect_mysql(db)
    with conn_mysql:
        cur_mysql = conn_mysql.cursor()

        if target_table_name == "Job":
            sql_insert = "insert into " + target_table_name + "(" + target_tables[target_table_name] + ") values(%s, %s, %s, %s)"
        elif target_table_name == "Department":
            sql_insert = "insert into " + target_table_name + "(" + target_tables[target_table_name] + ") values(%s, %s, %s)"
        elif target_table_name == "Employee":
            sql_insert = "insert into " + target_table_name + "(" + target_tables[target_table_name] + ") values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        else:
            sql_insert = "insert into " + target_table_name + "(" + target_tables[target_table_name] + ") values(%s, %s, %s, %s, %s)"
        
        print("MySQL  SQL : ", sql_insert)
        cur_mysql.executemany(sql_insert, rows)
        print("AffectedRowCount is ", cur_mysql.rowcount)
    print("====================================================================== END " + target_table_name)


def create_table(db, target_table_name):
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
                                salary float(10,2) default 0,
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
    
    conn_mysql = connect_mysql(db)
    with conn_mysql:
        cur_mysql = conn_mysql.cursor()

        sql_sp = "call sp_drop_fk_refs(" + '"' + target_table_name + '"' + ")"
        cur_mysql.execute(sql_sp)
        sql_drop = "drop table if exists " + target_table_name
        cur_mysql.execute(sql_drop)
        sql_create = 'create table ' + target_table_name + ' (' + target_tables[target_table_name] + ')'
        cur_mysql.execute(sql_create)
    
    print("create table {} complete! \n".format(target_table_name))

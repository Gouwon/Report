-- importing modules and declaring functions

import pymysql
import cx_Oracle

def get_oracle_conn():
    return cx_Oracle.connect("hr", "hrpw", "localhost:1521/xe")

def get_mysql_conn(_db):
    return pymysql.connect(
    host='localhost',
    user='dooo',
    password='1',
    port=3307,
    db=_db,
    charset='utf8')


-- 1. JOBS to Job table
    
connection = mu.get_oracle_conn()
myconn = mu.get_mysql_conn('doodb')

with connection:
    
    cursor = connection.cursor()
    sql = '''select * from JOBS'''
    cursor.execute(sql)
    rows = cursor.fetchall()

for row in rows:
    print(row)

with myconn:
    cur =  myconn.cursor()
    cur.execute("call sp_drop_fk_refs('Job')")
    
    cur.execute("drop table if exists Job")

    sql_create = '''
        create table Job (
            id varchar(45) not null,
            title varchar(45) not null,
            min_salary int default 0,
            max_salary int default 0,
            primary key(id)
        )
    '''

    cur.execute(sql_create)

    sql_insert = "insert into Job(id, title, min_salary, max_salary) values(%s, %s, %s, %s)"
    
    cur.executemany(sql_insert, rows)
    print("Affected Row Count is", cur.rowcount)


-- 2. DEPARTMENTS to Department

connection = mu.get_oracle_conn()
myconn = mu.get_mysql_conn('doodb')

with connection:
    
    cursor = connection.cursor()
    sql = '''select DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID from DEPARTMENTS'''
    cursor.execute(sql)
    rows = cursor.fetchall()

for row in rows:
    print(row)

with myconn:
    cur =  myconn.cursor()
    cur.execute("call sp_drop_fk_refs('Department')")
    
    cur.execute("drop table if exists Department")

    sql_create = '''
        create table Department (
            id int default 0 not null,
            name varchar(45) not null,
            manager_id int default 0,
            primary key(id)
        )
    '''

    cur.execute(sql_create)

    sql_insert = "insert into Department(id, name, manager_id) values(%s, %s, %s)"
    
    cur.executemany(sql_insert, rows)
    print("Affected Row Count is", cur.rowcount)
    
    
-- 3. EMPLOYEES to Employee

connection = mu.get_oracle_conn()
myconn = mu.get_mysql_conn('doodb')

with connection:
    
    cursor = connection.cursor()
    sql = '''select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE,
                    JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID from EMPLOYEES'''
    cursor.execute(sql)
    rows = cursor.fetchall()

for row in rows:
    print(row)

with myconn:
    cur =  myconn.cursor()
    cur.execute("call sp_drop_fk_refs('Employee')")
    
    cur.execute("drop table if exists Employee")

    sql_create = '''
        create table Employee (
            id int default 0 not null,
            first_name varchar(45),
            last_name varchar(45) not null,
            email varchar(45) not null,
            tel varchar(45),
            hire_date datetime not null default current_timestamp,
            job varchar(45) not null default ' ',
            salary int default 0,
            commission_pct decimal(4,2) default 0,
            manager_id int default 0,
            department int default 0,
            primary key(id)
        )
    '''

    cur.execute(sql_create)

    sql_insert = '''insert into Employee(id, first_name, last_name, email, tel, hire_date,
                                         job, salary, commission_pct, manager_id, department) 
                    values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'''

    
    cur.executemany(sql_insert, rows)
    print("Affected Row Count is", cur.rowcount)
    
    
    
-- 4. JOB_HISTORY to JobHistory

connection = mu.get_oracle_conn()
myconn = mu.get_mysql_conn('doodb')

with connection:
    
    cursor = connection.cursor()
    sql = '''select EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID from JOB_HISTORY'''
    cursor.execute(sql)
    rows = cursor.fetchall()


for row in rows:
  print(row)

with myconn:
    cur =  myconn.cursor()
    cur.execute("call sp_drop_fk_refs('JobHistory')")

    cur.execute("drop table if exists JobHistory")

    sql_create = '''
        create table JobHistory (
            employee int not null,
            start_date datetime not null,
            end_date datetime not null,
            job varchar(45) not null,
            department int default 0,
            primary key(employee, start_date)
    )
    '''

    cur.execute(sql_create)

    sql_insert = "insert into JobHistory(employee, start_date, end_date, job, department) values(%s, %s, %s, %s, %s)"

    
    cur.executemany(sql_insert, rows)
    print("Affected Row Count is", cur.rowcount)

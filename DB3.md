 # 오라클과 MySQL에서 데이터베이스(Schema)와 사용자(USER)를 생성하는 과정을 각각 쓰시오.
 ***
 
  + 오라클에서의 데이터베이스, 사용자 생성과정
    대부분의 관계형 DB에서는 데이터베이스와 사용자는 다르지만, 오라클에서 `Schema`로 보기 때문에 사용자도 `Schema`, 데이터베이스도 `Schema`이고, 사용자와 데이터베이스를 하나로 인식한다. 따라서 사용자를 생성하면 데이터베이스도 생성된다.
    
    1. DBA의 사용자 생성( `접속 > 다른 사용자 > 마우스 우측 클릭 後 사용자 생성` )
       DB 관리자인 DBA가 사용자를 생성할 수 있는 권한을 가지고 있다. DBA가 오라클 **SQL Developer**에 들어가서 들어가서 좌측 상단 베너인 **접속창**에서 하위 목록들을 보면 그 중 '**다른 사용자**' 항목이 있고, 이 곳에서 마우스 우측 클릭을 하면 '**사용자 생성(B)**'을 클릭하면 된다.
    
    2. DBO의 권한 설정 및 생성( 설정 후 `적용(A)` 클릭 )
       DBA는 먼저 *시스템 테이블 스페이스(SYSTEM)* 을 설정 후에 DBO, DB 사용자에게 *기본 테이블 스페이스* 를 할당해 줄 수 있다. 또한 기본적인 사용자의 정보들 - 이름, 비밀번호 - 를 줄 수 있으며, 기본적으로 DBO에 맞는 권한과 테이블 스페이스 할당량을 주지만, 여기서는 전권한을 부여한다. 이후 설정할 것이 끝났다면 '**사용자 생성**'창의 '**적용(A)**'를 눌러주면 사용자 및 데이터베이스 생성은 끝난다.
       
       
  
  + MySQL에서의 데이터베이스, 사용자 생성과정
    MySQL에서는 데이터베이스와 사용자는 별개의 존재이며 이들을 만드는 권한은 DBA, DB관리자 최상위사용자 root 계정이 가지고 있다.
    
    1. 데이터베이스의 생성( `create database <db-name>;` )
    ```sql
     create database <db-name>;
     show databases;
     use <db-name>
     create table <table-name> (column 설정);
     ```
       MySQL에 root 게정으로 들어간 DBA는 `create database <db-name>;` 명령어를 통해서 데이터베이스를 생성해낼 수 있다. 생성된 데이터베이스가 잘 있는지는 `show databases;` 명령어로 확인가능하며, 해당 데이터베이스를 사용하길 원한다면 `use <db-name>` 명령어를 사용하면 된다. 지금 만들어진 데이터베이스는 빈 DB임으로 따로 `create table <table-name> (column 설정);`을 해줘야 한다.
       
       
    2. DBO 사용자 계정 생성하기
       DBA, DB관리자는 사용자 계정을 생성할 수 있다. MySQL에서는 크게 사용자 생성과 권한 부여 및 적용의 2단계를 거친다.
       
       2-1. 사용자 계정 생성하기( `create user <user-name>@'<host>' identified by '<pw>';` )
        ```sql
         create user <user-name>@'<host>' identified by '<pw>';
        ```
           사용자 계정을 생성할 때는 
       2-2. 사용자 권한 부여 및 적용( `grant all privileges on <DB>.* to '<user-name>'@'<host>';` )
        ```sql
         grant all privileges on *.* to '<user-name>'@'<host>';
         grant all privileges on <DB>.* to '<user-name>'@'<host>';
        ```

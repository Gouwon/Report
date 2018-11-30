 # Docker를 활용하여 MySQL 5.7을 설치하는 과정을 기술하시오.
 ***
 
 ## 1. `docker search mysql`
  ```vim
    docker search mysql
  ```
   도커는 많은 이미지들을 받을 수 있다. 세계 곳곳에서 이미지를 만들어서 공유 중이기 때문이다.
   이런 이미지들이 모인 곳이 https://hub.docker.com/ 이다. `docker search` 명령어는 해당 사이트에서 mysql 이미지가 있는지 검색하는 명령어이다.
   
   
 ## 2. `docker pull mysql:5.7`
   ```vim
    docker pull mysql:5.7
  ```
   설치할 이미지를 찾았다면 해당 이미지를 다운받아야 하는 데, 이 때 `docker pull mysql:5.7`을 사용한다. MySQL에는 여러 버전이 있기 때문에 만약 자신의 요망 버전이 있다면 `:`을 쓰고 버전을 쓰면 된다. 버전이 없으면 최신버전의 것으로 pull 받게 된다.
   
   
 ## 3. `docker image ls`
   ```vim
    docker image ls
  ```
   `docker pull` 받은 이미지가 잘 받아졌는지 확인하기 위한 명령어이다.
   
   
 ## 4. `docker container run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=r! --name mysql5 mysql:5.7`
   ```vim
    docker container run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=r! --name mysql5 mysql:5.7
  ```
  이미지가 잘 있다면 이제 이 이미지를 기반으로 컨테이너를 생성해야 한다. 컨테이너느 한 번 생성되면 수정하기 어렵기 때문에 여러 옵션 명령어를 함께 사용해야 한다. 특이할 점은 Mysql은 최상위 사용자의 PW를 초기화해서 생성해줘야 한다. 여기서는 임의로 PW를 `r!`로 한다.
  
  
 ## 5. `docker container ps`
   ```vim
    docker container ps
  ```
  컨테이너 생성이 잘 되었는 지 확인하기 위해 현재 프로세스 중인 컨테이너 목록을 확인하자.
  
  
 ## 6. `docker exec -it mysql5 bash`
   ```vim
    docker exec -it mysql5 bash
  ```
  컨테이너 생성되어 잘 돌아간다면 접속을 해 봐야 한다. 여기서 옵션 명령어 `-it`는 사용자에게 input을 받아서 표준출력한다는 옵션으로 간단히 말하면 사용자와의 상호작용을 한다는 의미이며, `docker exec` 명령어는 맨 끝에 `bash` 명령어를 실행하라는 명령어이다.

 # 문제 1) Docker를 활용하여 오라클 Express Edition을 설치하는 과정을 기술하시오.
 ***
 
  도커는 이미지를 기반으로 컨테이너를 구동하기 때문에, 일반적으로 https://hub.docker.com에 등록된 이미지들을 받아서 설치한다.
  이 때, 해당 웹사이트에 이미지가 있는지 확인하는 명령어가 `docker search oracle`이다 
  이 중에서 오라클 Express Edition은 여러 이미지가 있는데, 안정적으로 사용할 수 있는 것들은 다운받은 수와 Star 수가 많은 것들이다.
  여기서는 `sath89/oracle-xe-11g`를 받기로 한다. 
  
  해당 이미지를 다운받기 위해서는 `docker pull sath89/oracle-xe-11g` 명령어를 통해 pull 받고, 해당 이미지가 잘 받아졌는지 `docker image ls`로 확인한다.
  이미지가 잘 받아졌다면, 이 이미지를 기반으로 컨테이너를 생성해야 한다.
  이 때 사용하는 명령어가 `docker container run`이다 .
  그러나 여기서 주의할 것은 컨테이너 생성 이후에는 설정을 변경하기 어렵기 때문에 처음 `docker run` 명령어를 사용할 때 여러 옵션 명령어를 사용해야 한다.
  그리고 추가로 오라클은 포트를 2개 사용함으로 포트 옵션도 2개 줘야 한다.
  `-d`는 백그라운드에서 실행하고, `-p-는 포트를 할당하라는 옵션이다.
  이를 이용해서 `docker container run -d --name oracle -p 8080:8080 -p 1521:1521 sath89/oracle-xe-11g`를 작성하여 컨테이너를 구성한다.
  여기서 `--name oracle`은 생성되는 컨테이너의 이름을 'oracle' 이라고 설정하는 부분이며, 마지막 부분의 `sath89/oracle-xe-11g`는 pull받은 이미지의 이름을 적은 것이다.
  
  이후 해당 컨테이너가 잘 동작하는지는 `docker container ps`를 통해 확인할 수 있고, 이를 실행하려고 할 때는 `docker container exec -it oracle bash`를 하면 된다.
  참고로 `-it`는 사용자와 상호작용하는 옵션 명령어이다.
  
  추가로 윈도우에서 도커를 통해 오라클 설치 시, Virtual Box에서 `설정 > 네트워크 > 고급의 포트 포워딩` 설정을 해줘야 한다.

 # Linux(Ubuntu) Docker Container를 구동하기 위한 절차를 쓰고, 설치된 Ubuntu Container에 Telnet daemon 구동하기, 한글 사용 설정하기, Git 사용 설정하기 등의 작업절차를 기술하시오.
 ***
 
  1. Linux(Ubuntu) Docker Container를 구동
     처음 시작이라고 가정하면 다음과 같다.
     ```vim
      docker search ubuntu
      docker image pull ubuntu
      docker image ls
      docker container run -itd --restart=always --name <container-name><sub>[^1]</sub> ubuntu bash
      docker container ps
     
     ```
     <sub>[^1]: 임의로 컨테이너 이름은 `ubt`라 한다.</sub>
     
     
  2. 설치된 Ubuntu Container에 Telnet daemon 구동 및 한글 사용 설정하기
      ## Docker 창에서
      ---
       ```vim
      docker container attach ubt
      locale
      locale -a
      apt-get install locales
      localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
      locale -gen ko.KR.UTF-8
      vi /bin/docker_bash<sub>[^2]</sub>
          #!bin/sh
          /etc/init.d/xinetd restart
          export LANGUAGE=ko
          LC_ALL=ko_KR.UTF-8 bash
          :wq
      docker commit ubt ubx
      docker container run -itd --restart=always --name ubx -p 23:23 ubx /bin/docker_bash
      docker attach ubx
     
     ```
     <sub>[^2]: 새로운 컨테이너, 이미지의 이름은 임의로 `ubx`라 한다.</sub>
     
     
     ## 오라클 Virtualbox 포트 포워딩 설정 추가
     ---
     Virtualbox와 윈도우 간의 포트 뚫어 주는 과정이 필요하다.
     
     > 실행 중인 Virtualmachine 선택 후 마우스 우측 클릭
     > `설정( <kbd>Ctrl</kbd> + <kbd>s</kbd> ) > 네트워크 탭 > 어댑터1 NAT화면의 '고급' 선택 > 포트포워딩`
     > 해당 창에서 호스트IP와 Telnet 포트 23:23을 게스트포트, 호스트포트에 추가.
     
     
  3. Git 사용 설정하기
      ## Docker `ubx` 컨테이너에 들어간 상태에서
      ---
      ```vim
        apt-get update
        apt-get install git
        which git
        git config --list
        git config --global user.name <github-username>
        git config --global user.email <email>
        git config credential.helper store<sub>[^3]</sub>
        git clone <github-url>
        git add --all
        git commit -am "<message>
        git push
     
      ```      
      
      <sub>[^3]: Git 로그인 게정과 비밀번호 입력값 기억.</sub>

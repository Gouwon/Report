# 데이터 수집 계획서

## 데이터 수집의 목적
####  + 해당 데이터 수집은 어디까지나 학습을 목적으로 한다.(상업적 사용은 하지 않는다.)



## 데이터 수집의 계획 
####  +   수집된 데이터는 RDBMS MySQL에 저장한다.
####  +   저장될 데이터베이스 내에 테이블을 미리 생성하여, 데이터 저장을 실시한다.
####  +  테이블에는 기본적으로 id를 primary key로 auto-increment한다.
####  +  다른 테이블의 참조 및 관계 설정은 unique key를 통해서 한다.
####  +  칼럼 및 프로그램의 변수 명명은 카멜케이스를 준용한다.
####  +  데이터베이스 테이블의 이름은 대문자로 시작하여, 각 단어의 시작은 대문자, 단어의 연결은 공백이 없도록 한다.



## 데이터 수집의 실행 
####  +  데이터 수집 대상은 멜론 Top 100으로 한다.
####  +  수집된 랭킹 순위는 매일 csv 파일로 저장되어, MySQL DB의 MelList 테이블에 저장된다.
####  +  MelList 테이블에서 crawl 여부를 확인하여, 각 노래들에 대한 자료들을 프로그램이 자동 수집하여 Album, Song, Artist, ArtistSong에 차례대로 입력 후, MelList 테이블에서 crawl 여부를 변경한다.
####  +  마지막으로 SongRank 테이블에 수집된 멜론 Top 100을 저장한다.



## 프로그램의 사용
#### 해당 프로그램은 main.py, melon_utils.py 가 같은 디렉터리 안에 존재하고, 동 위치 내의 results 디렉터리가 존재하여야지 사용이 가능하다.
#### 해당 프로그램은 수집한 데이터는 csv 파일로 results 디렉터리에 저장되며, MySQL DB에 바로 저장함으로, 프로그램 내에서 연결할 DB 이름을 설정해주어야 한다.
#### 해당 프로그램은 main.py를 1일 1회 실행함을 원칙으로 한다.
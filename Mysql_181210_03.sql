/* 3번문제) 동아리(Club)별 회원테이블(ClubMember)을 다음과 같이 만들고, 동아리별 50명 내외로 가입시키시오.
(단, Club 테이블의 leader 컬럼을 삭제하고, 리더를 회원테이블의 레벨(level) 2로 등록하시오.) */


start transaction;

select * from Club;
desc Club;

create table ClubMember(
	id int(10) unsigned not null auto_increment,
    club smallint(5) unsigned comment '클럽번호',
    student int(11) unsigned comment '학번',
    level smallint default 0,
    primary key(id),
    constraint foreign key fk_club(club) references Club(id) on delete cascade,
    constraint foreign key fk_student(student) references Student(id) on delete cascade
    ) charset=utf8;
    
select * from Club;
select * from ClubMember;

-- 기등록된 리더 등록
insert into ClubMember(club, student, level)
select id, leader, 2 from Club;
select * from ClubMember;

-- 기존의 외래키 및 leader 칼럼 삭제
show index from Club;
ALTER TABLE `dooodb`.`Club` 
DROP FOREIGN KEY `Club_ibfk_1`;
ALTER TABLE `dooodb`.`Club` 
DROP COLUMN `leader`,
DROP INDEX `fk_leader_student` ;
show index from Club;
desc Club;


insert into ClubMember(club, student)
select clm.id, s.id
  from (select id from Club where id = 1) clm, 
       (select id from Student order by rand() limit 50) s;
       
select level, count(*) from ClubMember group by level;

select club, count(*) from ClubMember group by club;
truncate ClubMember;

select * from ClubMember where level = 0;

update ClubMember
set level = (case when rand() < 0.5 then 0 else 1 end) where level = 0;

select * from ClubMember;

commit;

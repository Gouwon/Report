/* 4번문제) 학과(Dept)테이블을 만들고 5개 학과 이상 샘플 데이터를 등록하고, 학생 테이블에 학과 컬럼(dept)을 추가한 후 모든 학생에 대해 랜덤하게 과 배정을 시키시오.
pk(id) 학과명(name) 지도교수(prof) 과대표(student)*/


start transaction;


create table Dept(
	id smallint(5) unsigned not null auto_increment,
    name varchar(31) comment '학과명',
    prof smallint(5) unsigned comment '교수명',
    student int(11) unsigned comment '과대표',
    primary key(id),
    constraint foreign key fk_prof(prof) references Prof(id),
    constraint foreign key fk_student(student) references Student(id)
    ) charset=utf8;
    
desc Dept;
show index from Dept;
select * from Dept;

insert into Dept(name) value('물리학과');
insert into Dept(name) value('경제학과');
insert into Dept(name) value('체육학과');
insert into Dept(name) value('국문학과');
insert into Dept(name) value('통계학과');
select * from Dept;

update Dept
set prof = (select id from Prof order by rand() limit 1) where id > 0;
select * from Dept;

desc Student;
select * from Student;

-- 학생 테이블에 학과열 추가
ALTER TABLE `dooodb`.`Student` 
ADD COLUMN `dept` SMALLINT(5) unsigned NULL AFTER `regdt`;
-- 학생 테이블 외래키 추가
ALTER TABLE Student 
add FOREIGN KEY fk_dept(dept) references Dept(id);
-- 학과 배정
update Student
set dept = (select id from Dept order by rand() limit 1) where id > 0;
select * from Student;
-- 과대표 선정

update Dept
set student = (
select id from Student where dept = 1 order by rand() limit 1
);
update Dept
set student = (
select id from Student where dept = 2 order by rand() limit 1
);
update Dept
set student = (
select id from Student where dept = 3 order by rand() limit 1
);
update Dept
set student = (
select id from Student where dept = 4 order by rand() limit 1
);
update Dept
set student = (
select id from Student where dept = 5 order by rand() limit 1
);
select * from Dept;

commit;

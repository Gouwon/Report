/* 5번문제) 강의실 테이블(Classroom)을 만들고, 샘플강의실 10개를 등록하고, 과목별 강의실 배치를 위해 과목(Subject) 테이블에 강의실 칼럼(classroom) 추가한 후 배정하시오.*/


create table Classroom(
	id smallint unsigned not null auto_increment,
    name varchar(10) comment '강의실호수',
    primary key(id)
	) charset=utf8;
    
desc Classroom;
select * from Classroom;


insert into Classroom(name) value('101호');
insert into Classroom(name) value('102호');
insert into Classroom(name) value('103호');
insert into Classroom(name) value('104호');
insert into Classroom(name) value('201호');
insert into Classroom(name) value('202호');
insert into Classroom(name) value('203호');
insert into Classroom(name) value('204호');
insert into Classroom(name) value('301호');
insert into Classroom(name) value('302호');
select * from Classroom;

desc Subject;
alter table Subject
  add column classroom smallint unsigned;
desc Subject;

show index from Subject;
alter table Subject
  add constraint foreign key fk_classroom(classroom) references Classroom(id);
show index from Subject;

select * from Classroom;
select * from Subject;

start transaction;

update Subject
set classroom = (select id from Classroom order by rand() limit 1);

select * from Subject;
select classroom, count(*) from Subject group by classroom;
 
select id from Classroom
where id not in (select distinct classroom from Subject)
;
 
update Subject
set classroom = 2
where id = 4;


update Subject
set classroom = 10
where id = 5;


update Subject
set classroom = 5
where id = 7;

select classroom, count(*) from Subject group by classroom;


commit;

-- 성적테이블(Grade) 만들고 (중간고사성적, 기말고사성적 columns) 각 수강에 대해 중간고사 기말고사 점수를 sample로 채우고, 
-- 다음과 같은 REPORT를 작성하시오. (과목수 최소 10개, 수강내역=  500명 * 수강과목수, 점수 0~100점)

-- REPORT 1 = 과목, 학생명, 중간고사점수, 기말고사점수, 총점, 평균, 과목별학점(ABCDF) 
-- order by 과목 가나다순 정렬, 성적

-- REPORT 2 = 과목, 과목의 평균점수, 총 학생수, 최고 득점자,
-- order by 과목 가나다순 정렬

-- REPORT 3 = 학생명, 과목수, 총점, 평균(평균 100점), 평점(ABCDF)


start transaction;

-- 성적테이블(Grade) 만들기

create table Grade(
	id smallint unsigned auto_increment primary key,
    enroll int unsigned not null,
    midterm smallint unsigned not null default 0,
    finalterm smallint unsigned not null default 0,
    constraint foreign key fk_enroll(enroll) references Enrol(id)

);

select * from Grade;


-- 중간고사 기말고사 점수를 sample로 채우기

insert into Grade(enroll) select id from Enrol;

update Grade set midterm = ceil((0.5 + rand() / 2) * 100) where id > 0;

update Grade set finalterm = ceil((0.5 + rand() / 2) * 100) where id > 0;
select * from Grade;


-- 과목명, 학생명, 중간고사, 기말고사 생성

select sub.sbj_name, sub.stu_name, g.midterm, g.finalterm
 from Grade g inner join (
select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name) sub
on g.enroll = sub.id;

-- 과목명, 학생명, 중간고사, 기말고사, 총점, 평균 생성

select g.id, sub.id, sub.sbj_name, sub.stu_name, g.midterm, g.finalterm, (g.midterm + g.finalterm) total_score, ((g.midterm + g.finalterm) /2) avg_score
 from Grade g inner join (
select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name) sub
on g.enroll = sub.id;

select sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by 과목명;

select sub.과목명, sub.학생명, g.midterm as '중간', g.finalterm as '기말'
 from Grade g inner join (
select e.id, sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by 과목명) sub
on g.enroll = sub.id;

select sub.과목명, sub.학생명, g.midterm as '중간', g.finalterm as '기말', (g.midterm + g.finalterm) as '총점', ((g.midterm + g.finalterm) /2) as '평균'
 from Grade g inner join (
select e.id, sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by 과목명) sub
on g.enroll = sub.id;


-- View report1 생성

USE `doodb`;
CREATE  OR REPLACE VIEW `report1` AS select sub.id, sub.과목명, sub.학생명, g.midterm as '중간', g.finalterm as '기말', (g.midterm + g.finalterm) as '총점', ((g.midterm + g.finalterm) /2) as '평균'
 from Grade g inner join (
select sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by 과목명) sub
on g.enroll = sub.id;


-- 학점분류

select *, (case when report11.평균 = 100 then 'A+'
								 when report11.평균 >= 90 then 'A'
                                 when report11.평균 >= 80 then 'B'
                                 when report11.평균 >= 70 then 'C'
                                 when report11.평균 >= 60 then 'D'
                                 else 'F' end)  as '학점'
 from report11
 order by 1;

select * from report11;
desc report11;

-- 제출용 과목 성적순 정렬된 테이블 Report1
 
 create table Report1(
	id smallint unsigned auto_increment primary key, 
	sbj_name varchar(31) DEFAULT NULL,
    stu_name varchar(31) not null,
    midterm smallint unsigned not null default 0,
    finalterm smallint unsigned not null default 0,
    total_score int(7) not null default 0,
    avg_score decimal(10, 4),
    grade varchar(10) not null
 );

select * from Report1;


insert into Report1(id, sbj_name, stu_name, midterm, finalterm, total_score, avg_score, grade)
select * from 
(
select *, (case when report1.avg_score = 100 then 'A+'
				when report1.avg_score >= 90 then 'A'
				when report1.avg_score >= 80 then 'B'
                when report1.avg_score >= 70 then 'C'
                when report1.avg_score >= 60 then 'D'
                else 'F' end) grade
 from report1
) sub_rp1
order by sub_rp1.sbj_name, sub_rp1.avg_score desc, sub_rp1.stu_name;


select * from Report1;

select * from Report1 order by sbj_name, grade;



-- REPORT 2 = 과목, 과목의 평균점수, 총 학생수, 최고 득점자,
-- order by 과목 가나다순 정렬


start transaction;

select * from report11;
select * from Report11;

select 과목명, round(sum(평균) , 1) as '과목평균총점', count(*) as '수강생 수'
  from report11 group by 과목명;
  

select sub1.과목명, (sub1.과목평균총점 / sub1.수강생수) as '과목평균', sub1.수강생수
  from(
select 과목명, round(sum(평균) , 1) as '과목평균총점', count(*) as '수강생수'
  from report11
group by 과목명
) sub1
;



select *, (sub_sbj.sbj_total_score / sub_sbj.total_stu) sbj_avg
  from(
select sbj_name, count(*) total_stu, sum(avg_score) sbj_total_score
from Report1
group by sbj_name
) sub_sbj
;



-- REPORT 3 = 학생명, 과목수, 총점, 평균(평균 100점), 평점(ABCDF)


select sub.id, sub.sbj_name, sub.stu_name, g.midterm, g.finalterm, (g.midterm + g.finalterm) total_score, ((g.midterm + g.finalterm) /2) avg_score
 from Grade g inner join (
select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name) sub
on g.enroll = sub.id;



select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name;



-- 학생명과 학생수

select stu_name from report1;
select count(*) from (select stu_name from report1 group by stu_name) sub1;

select sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name;


-- 
select sub.id, sub.sbj_name, sub.stu_name, g.midterm, g.finalterm, (g.midterm + g.finalterm) total_score, ((g.midterm + g.finalterm) /2) avg_score
 from Grade g inner join (
select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name) sub
on g.enroll = sub.id;



 select report1.*, (case when report1.avg_point = 100 then 'A+'
                                 when report1.avg_point >= 90 then 'A'
                                when report1.avg_point >= 80 then 'B'
                                when report1.avg_point >= 70 then 'C'
                                when report1.avg_point >= 60 then 'D'
                                else 'F' end) rating
   from
(           
select  report.stu_name, count(*), sum(report.total_score) total_point, avg(report.avg_score) avg_point
from 
(
select sub.id, sub.sbj_name, sub.stu_name, g.midterm, g.finalterm, (g.midterm + g.finalterm) total_score, ((g.midterm + g.finalterm) /2) avg_score
 from Grade g inner join (
select e.id, sbj.name as sbj_name, stu.name as stu_name from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
order by sbj.name) sub
on g.enroll = sub.id;

) report
group by report.student
order by report.stu_name asc
)report1
;

desc Grade;


 select r2.*, (case when r2.평균 = 100 then 'A+'
					when r2.평균 >= 90 then 'A'
					when r2.평균 >= 80 then 'B'
					when r2.평균 >= 70 then 'C'
					when r2.평균 >= 60 then 'D'
                    else 'F' end)  as '평점'
from         
(
select r1.학생명, count(*) as '과목수', sum(r1.총점) total_point, avg(r1.평균)
from 
(
select g. *, 과목명, 학생명, g.midterm as '중간', g.finalterm as '기말', (g.midterm + g.finalterm) as '총점', ((g.midterm + g.finalterm) /2) as '평균'
 from Grade g inner join (
select e.id, sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id
) sub
on g.enroll = sub.id
) r1
group by r1.학생명
) r2
;


select e.id, sbj.name as '과목명', stu.name as '학생명' from Enrol e
inner join Student stu on e.student = stu.id
inner join Subject sbj on e.subject = sbj.id;






select *, (case when report1.평균 = 100 then 'A+'
				when report1.평균 >= 90 then 'A'
				when report1.평균 >= 80 then 'B'
                when report1.평균 >= 70 then 'C'
                when report1.평균 >= 60 then 'D'
                else 'F' end) grade
from
(
select 학생명, count(*) '과목수', sum(총점), round(avg(평균), 1) '평균' from report11 group by 학생명
) report1;


















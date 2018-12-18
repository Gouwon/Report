-- 1번문제) 학번, 학생명, 수강과목수, 전과목 평균점수 칼럼을 갖는 View를 작성하시오.

select stu.id as '학번', max(stu.name) as '학생명', count(*) as '수강과목수', round((avg(g.midterm + g.finalterm) / 2), 1) as '전과목 평균점수'
	from Enroll as e inner join Grade as g on e.id = g.enroll
		         inner join Student as stu on stu.id = e.student
	group by stu.id
;

create view v_stu_grade
	as select stu.id as '학번', max(stu.name) as '학생명', count(*) as '수강과목수', round((avg(g.midterm + g.finalterm) / 2), 1) as '전과목 평균점수'
		from Enroll as e inner join Grade as g on e.id = g.enroll
				 inner join Student as stu on stu.id = e.student
		group by stu.id;
		
select * from v_stu_grade;

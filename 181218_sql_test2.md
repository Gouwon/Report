-- 2번문제) 학번을 주면 해당 학생의 전과목 평균을 반환하는 Stored Function을 작성하시오.

select round(avg(g.midterm + g.finalterm), 1) as '전과목 평균점수'
	from Enroll as e inner join Grade as g on e.id = g.enroll
	where e.student = 1;
    
desc Student;
desc v_stu_grade;

delimiter //
create function f_stu_grade(agv_stuid int unsigned) returns mediumint
    begin
		return (select round(avg(g.midterm + g.finalterm), 1) as '전과목 평균점수'
					from Enroll as e inner join Grade as g on e.id = g.enroll
					where e.student = agv_stuid);
    end //
delimiter ;

select f_stu_grade(2);

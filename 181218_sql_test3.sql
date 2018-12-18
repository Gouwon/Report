-- 3번문제) 클럽(Club)을 하나 추가하면 클럽회원(ClubMember)으로 임의의 한 학생(Student)을 회장으로 자동 등록하는 Trigger를 작성하시오.
/* 
	클럽(on Club)이 인서트 된 후(after insert), 클럽회원 칼럼에 한 명의 학생을 insert하는 데, level을 2로 주자.
    한 명의 학생은 전체 학생들 중에서 이미 기존 클럽의 level이 1, 2가 아닌 사람 중에서 뽑아야 한다.
    따라서 먼저 이 학생들을 찾아보자.
*/

desc Student;
select count(*) from Student;
desc Club;
select * from Club;
desc ClubMember;
select * from ClubMember;

-- 한 명의 학생은 전체 학생들 중에서 이미 기존 클럽의 level이 1, 2가 아닌 사람 중에서 뽑아야 한다.
select stu.*
	from Student as stu
    where stu.id not in (select cm.student from ClubMember as cm where cm.level = 1 or cm.level = 2);
    
select cm.student, cm.level from ClubMember as cm where cm.level = 1 or cm.level = 2;

select cm.level, count(*) from ClubMember as cm group by cm.level;


-- 클럽 한 개 만들기
insert into Club(name) value('신문부');



insert into ClubMember(club, studnet, level)
	values (
			(select id from Club where name = new.name), 
			(select stu.id
				from Student as stu
				where stu.id not in (select cm.student from ClubMember as cm where cm.level = 1 or cm.level = 2)
				order by rand() limit 1), 
			2);

select subject, count(*) from Enroll group by subject;
select * from Subject;

-- 트리거 만들기
drop trigger tr_club_leader;


delimiter //
create trigger tr_club_leader
	after insert
    on Club for each row
    begin
		insert into ClubMember(club, student, level)
			values ((select id from Club where name = new.name), 
					(select stu.id from Student as stu
						where stu.id not in (select cm.student from ClubMember as cm where level = 1 or level = 2)
						order by rand() limit 1), 
					2)    
;
    end //
delimiter ;


-- 트리거 확인하기

select * from ClubMember
	where club = (select max(id) from Club);

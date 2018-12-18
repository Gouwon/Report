-- 4번문제) 지난 학기 데이터(수강학생수, 성적 등)를 기준으로 인기 교수(강좌) Top 3을 추천하는 Stored Procedure을 작성하시오. 단, 데이터의 가중치는 자유롭게 부여하시오.
-- 학생수, 성적, likecnt 을 이용하여 가장 인기있는 교수(=과목)를 구하라. --프로시저

select sbj.id as sbj_id, max(sbj.name) as sbj_name, max(pr.name) as prof_name, 
       count(*) as stu_cnt, avg((g.midterm + g.finalterm) / 2) as avg_score, 
       avg(pr.likecnt) prof_likecnt
    from Enroll e inner join Subject sbj on sbj.id = e.subject
       	          inner join Prof pr on pr.id = sbj.prof
                  inner join Grade g on e.id = g.enroll
    group by sbj.id
    order by count(*) desc, avg((g.midterm + g.finalterm) / 2) desc, avg(pr.likecnt) desc
;


select count(distinct ee.student) from Enroll ee ;

select sbj.id as sbj_id, max(sbj.name) as sbj_name, max(pr.name) as prof_name, 
       (count(*)) as stu_cnt, avg((g.midterm + g.finalterm) / 2) as avg_score, 
       (avg(pr.likecnt))  prof_likecnt,
       ( (count(*)/(select count(distinct ee.student) from Enroll ee) * 0.15) + 
         (avg((g.midterm + g.finalterm) / 2) * 0.4) +
		(avg(pr.likecnt) * 0.45)) estimation
    from Enroll e inner join Subject sbj on sbj.id = e.subject
                  inner join Prof pr on pr.id = sbj.prof
                  inner join Grade g on e.id = g.enroll
    group by sbj.id
    order by estimation desc
;


delimiter //
create procedure sp_popular_prof()
        begin
	select sbj.id as sbj_id, max(sbj.name) as sbj_name, max(pr.name) as prof_name, 
	       (count(*)) as stu_cnt, (avg((g.midterm + g.finalterm) / 2)) as avg_score, 
	       (avg(pr.likecnt))  prof_likecnt,
	       ( (count(*)/(select count(distinct ee.student) from Enroll ee) * 1.5) + 
		 (avg((g.midterm + g.finalterm) / 200) * 0.4) +
	         (avg(pr.likecnt) * 0.45)) estimation		
            from Enroll e inner join Subject sbj on sbj.id = e.subject
			  inner join Prof pr on pr.id = sbj.prof
			  inner join Grade g on e.id = g.enroll
		group by sbj.id
		order by estimation desc limit 3;
        end //
delimiter ;

select * from Prof;
call sp_popular_prof();

-- 6번문제) 과목별 Top3 학생의 이름과 성적을 한줄로 표현하는 리포트를 아래와 같이 작성하시오.(성적은 중간, 기말 평균이며, 과목명 오름차순으로 정렬하시오.)

drop procedure if exists sp_subject_ranking;

delimiter //

create procedure sp_subject_ranking()
	begin
		declare _isdone boolean default false;
		declare _subject varchar(31); 
		declare _student varchar(45); 
		declare _avr varchar(45);
		declare local_i smallint default 1;
		
        	declare cursor_1 cursor
		   for select * from T_table0;
		
        	declare continue handler 
	           for not found set _isdone = True;

		drop table if exists T_table0;
        	create temporary table T_table0(
			subject varchar(31),
			student varchar(45),
			avr varchar(45)
			);

		drop table if exists T_table1;
        	create temporary table T_table1(
			subject varchar(31),
            		student1 varchar(31), score1 varchar(31),
            		student2 varchar(31), score2 varchar(31),
            		student3 varchar(31), score3 varchar(31),
            		isdone boolean default false
            	);
            

		while (local_i <= 10) do
			insert into T_table0(subject, student, avr)
            		select max(sub.subject), group_concat(sub.student) as student, group_concat(sub.avr) as avr
				from (select sbj.name as subject, stu.name as student, vge.avr as avr
					from v_grade_enroll as vge inner join Subject as sbj on sbj.id = vge.subject
				              		           inner join Student as stu on stu.id = vge.student
                                	where vge.subject = local_i order by avr desc limit 3) sub;
				
			set local_i = local_i + 1;
		end while;            
            
		select * from T_table0;
        
        open cursor_1;
            
		loop1 : loop
                	fetch cursor_1 into _subject, _student, _avr;
                
                if _isdone then
			leave loop1;
		end if;
                
		insert into T_table1 value(_subject, substring_index(_student, ',', 1), substring_index(_avr, ',', 1),
					    substring_index(substring_index(_student, ',', 2),',',-1),
                                            substring_index(substring_index(_avr, ',', 2),',',-1),
			                    substring_index(substring_index(_student, ',', 3),',',-1),
                                            substring_index(substring_index(_avr, ',', 3),',',-1), _isdone);                
            
				
                
         end loop loop1;
            
       close cursor_1;
        
       select * from T_table1 order by subject;
        
    end //

delimiter ;

call sp_subject_ranking();

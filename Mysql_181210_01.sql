-- 1번문제) 학생, 과목, 교수, 수강내역 테이블을 관계를 고려하여 생성하는 DDL을 작성하시오.

CREATE TABLE `Student` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `addr` varchar(30) NOT NULL,
  `birth` varchar(6) NOT NULL,
  `gender` tinyint(4) DEFAULT NULL,
  `tel` varchar(15) NOT NULL,
  `email` varchar(31) NOT NULL,
  `regdt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8;
desc Student;


CREATE TABLE `Enroll` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subject` smallint(5) unsigned NOT NULL,
  `student` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_enroll` (`subject`,`student`),
  KEY `Enroll_ibfk_2` (`student`),
  CONSTRAINT `Enroll_ibfk_1` FOREIGN KEY (`subject`) REFERENCES `Subject` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Enroll_ibfk_2` FOREIGN KEY (`student`) REFERENCES `Student` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2929 DEFAULT CHARSET=utf8;
desc Enroll;
show index from Enroll;

CREATE TABLE `Subject` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(31) DEFAULT NULL,
  `prof` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subject_name` (`prof`),
  CONSTRAINT `Subject_ibfk_1` FOREIGN KEY (`prof`) REFERENCES `Prof` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
desc Subject;
show index from Subject;

CREATE TABLE `Prof` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(31) DEFAULT NULL,
  `likecnt` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
desc Prof;
select * from Prof;

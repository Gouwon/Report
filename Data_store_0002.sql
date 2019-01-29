create table Blogger (
	id int not null auto_increment,
    bloggerId varchar(128),
    name varchar(128),
    link varchar(256),
    primary key(id),
    unique key(bloggerId)
) default charset = utf8
;

create table BlogPost (
	id int not null auto_increment,
	bloggerId varchar(128),
    title varchar(128),
    postDate varchar(128),
    link varchar(256),
    primary key(id),
    constraint foreign key fk_blogpost_blog (bloggerId) references Blogger(bloggerId)
)default charset = utf8
;

select * from Blogger;
select * from BlogPost;

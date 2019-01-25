create table MelList (
		id int not null auto_increment,
        songId  int,
        albumId int,
        crawl tinyint(1) default 0,
        primary key(id)
)
;

create table Album (
	id int not null auto_increment,
    albumId int,
    title varchar(128),
    releaseDate varchar(8),
    score decimal(4, 1),
    publisher varchar(128),
    label varchar(128),
    primary key(id),
    unique key(albumId)
) default charset = utf8
;

create table Song (
	id int not null auto_increment,
    songId int,
    title varchar(128),
    genre varchar(128),
    albumId int,
    primary key(id),
    unique key(songId),
    constraint foreign key fk_song_albumid (albumId) references Album(albumId)
) default charset = utf8
;

create table Artist(
	id int not null auto_increment,
    artistId int,
    name varchar(128),
    primary key(id),
    unique key(artistId)
) default charset = utf8
;

create table ArtistSong (
	id int not null auto_increment,
    artistId int,
    songId int,
    primary key(id),
    constraint foreign key fk_artistsong_artistid (artistId) references Artist(artistId),
    constraint foreign key fk_artistsong_songid (songId) references Song(songId),
    unique key uk_artistsong (artistId, songId)
)
;

create table SongRank (
	id int not null auto_increment,
    songId int,
    rank int,
    rankDate varchar(8),
    likecnt int,
    primary key(id),
    constraint foreign key fk_songrank_songid (songId) references Song(songId),
    unique key uk_songrank (songId, rankDate)
)
;

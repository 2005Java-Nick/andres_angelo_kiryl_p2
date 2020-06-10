drop table if exists readifined.person cascade;
create table readifined.person(
	id serial, 
	first_name varchar(100),
	last_name varchar(100),
	user_name varchar(50) not null unique,
	user_password varchar(50) not null,
	email varchar(100) not null unique,
	date_of_birth date,
	constraint person_id_pk primary key (id)
);

drop table if exists readifined.book cascade;
create table readifined.book(
	id serial,
	title varchar(100) not null,
	price numeric(7,2),
	author integer not null, 
	cover_img bytea,
	book bytea,
	constraint book_id_pk primary key (id),
	constraint book_author_fk foreign key (author) references readifined.person(id) on delete cascade on update cascade
);

drop table if exists readifined.tag cascade;
create table readifined.tag(
	id serial,
	tag_name varchar(100) unique not null,
	constraint tag_id_pk primary key (id)
);

drop table if exists readifined.book_tags cascade;
create table readifined.book_tags(
	id serial,
	book_id integer,
	tag_id integer,
	constraint book_tags_id_pk primary key (id),
	constraint book_tags_book_id_fk foreign key (book_id) references readifined.book(id) on delete cascade on update cascade,
	constraint book_tags_tag_id_fk foreign key (tag_id) references readifined.tag(id) on delete cascade on update cascade
);


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
	constraint book_author_fk foreign key (author) references readifined.person(id)
);


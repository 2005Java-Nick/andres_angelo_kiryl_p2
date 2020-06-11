drop schema if exists readifined cascade;
create schema readifined;

drop table if exists readifined.person cascade;
create table readifined.person(
	id serial, 
	first_name varchar(100),
	last_name varchar(100),
	user_name varchar(50) not null unique,
	user_password varchar(50) not null,
	email varchar(100) not null unique,
	date_of_birth date,
	phone_number varchar(20),
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
	book_id integer not null,
	tag_id integer not null,
	constraint book_tags_id_pk primary key (id),
	constraint book_tags_book_id_fk foreign key (book_id) references readifined.book(id) on delete cascade on update cascade,
	constraint book_tags_tag_id_fk foreign key (tag_id) references readifined.tag(id) on delete cascade on update cascade
);

drop table if exists readifined.review cascade;
create table readifined.review (
	id serial,
	review_body varchar(1000) not null,
	rating integer not null,
	constraint review_id_pk primary key (id)
);

drop table if exists readifined.book_reviews cascade;
create table readifined.book_reviews (
	id serial,
	review_id integer not null,
	book_id integer not null,
	constraint book_reviews_id_pk primary key (id),
	constraint book_reviews_review_id_fk foreign key (review_id) references readifined.review(id) on delete cascade on update cascade, 
	constraint book_reviews_book_id_fk foreign key (book_id) references readifined.book(id) on delete cascade on update cascade
);

drop table if exists readifined.genre cascade;
create table readifined.genre (
	id serial,
	genre varchar(100),
	constraint genre_id_pk primary key (id)
);

drop table if exists readifined.book_genre cascade;
create table readifined.book_genre (
	id serial,
	book_id integer,
	genre_id integer,
	constraint book_genre_id_fk primary key (id),
	constraint book_genre_genre_id_fk foreign key (id) references readifined.genre(id) on delete cascade on update cascade,
	constraint book_genre_book_id_fk foreign key (book_id) references readifined.book(id) on delete cascade on update cascade
);




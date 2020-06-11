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


drop table if exists readifined.address_type cascade;
create table readifined.address_type(
	id serial,
	description varchar(50) not null,
	constraint address_type_id primary key (id)
);

--drop table if exists zip_code cascade;
--create table zip_code (
--	id serial,
--	zip integer(9) not null,
--	constraint zip_code_id primary key (id)
--);



drop table if exists readifined.address cascade;
create table readifined.address (
	id serial,
	st_number integer not null,
	st_name varchar(50) not null,
	city varchar(50) not null,
	state varchar(50) not null,
	zip_code integer not null,	
	constraint address_id_pk primary key (id)	
);

drop table if exists readifined.registered_address cascade;
create table readifined.registered_address (
	id serial,
	person_id integer not null,
	address_id integer not null,
	address_type_id integer not null,
	constraint registered_address_id_pk primary key (id),
	constraint registered_address_person_id_fk foreign key (person_id) references readifined.person(id) on delete cascade on update cascade, 
	constraint registered_address_address_id_fk foreign key (address_id) references readifined.address(id) on delete cascade on update cascade,
	constraint registered_address_address_type_id_fk foreign key (address_type_id) references readifined.address_type(id) on delete cascade on update cascade
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

drop table if exists permissions cascade;
create table readifined.permissions (
	id serial,
	permission_type varchar(100) not null,
	constraint permissions_id_pk primary key (id)
);

drop table if exists user_roles cascade;
create table readifined.user_roles(
	id serial,
	role_type varchar(50) not null,
	constraint user_roles_id_pk primary key (id)
);

drop table if exists registered_role cascade;
create table readifined.registered_role (
	id serial,
	person_id integer not null,
	user_roles_id integer not null,
	constraint registered_role_id_pk primary key(id),
	constraint registered_role_person_id_fk foreign key (person_id) references readifined.person(id),
	constraint registered_role_user_roles_id_fk foreign key (user_roles_id) references readifined.user_roles(id)
);



drop table if exists assigned_permissions cascade;
create table readifined.assigned_permissions (
	id serial,
	permissions_id integer not null,
	user_roles_id integer not null,
	constraint assigned_permissions_id_pk primary key(id),
	constraint assigned_permissions_permissions_id_fk foreign key (permissions_id) references readifined.permissions(id),
	constraint assigned_permissions_user_roles_id_fk foreign key (user_roles_id) references readifined.user_roles(id)
);


INSERT INTO readifined.user_roles
(role_type)
VALUES('Admin'), ('Employee'), ('Customer'), ('Subscribed-Customer'), ('Author'), ('Guest');

select * from user_roles;

insert into readifined.permissions (permission_type) values ('Buy'), ('Sell'), ('View'), ('Edit'), ('Review');

select * from permissions;
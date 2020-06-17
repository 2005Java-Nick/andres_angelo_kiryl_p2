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
	session_token varchar(50),
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
	reviewer_id integer not null,
	constraint book_reviews_id_pk primary key (id),
	constraint book_reviews_review_id_fk foreign key (review_id) references readifined.review(id) on delete cascade on update cascade, 
	constraint book_reviews_book_id_fk foreign key (book_id) references readifined.book(id) on delete cascade on update cascade,
	constraint book_reviews_reviewer_id_fk foreign key (reviewer_id) references readifined.person(id) on delete cascade on update cascade
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
	constraint book_genre_genre_id_fk foreign key (genre_id) references readifined.genre(id) on delete cascade on update cascade,
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

select * from readifined.user_roles;

insert into readifined.permissions (permission_type) values ('Buy'), ('Sell'), ('View'), ('Edit'), ('Review');

select * from readifined.permissions;

--Assign Permissions Admin

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
VALUES(1, 1),(1, 2),(1, 3),(1, 4),(1, 5);

--Assign Permissions Employee

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
VALUES(2, 4);

--Assign Permissions Customer

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
VALUES(3, 1), (3, 3);

--Assign Permissions Subscribed-Customer

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
VALUES(4, 1), (4, 3), (4, 5);

--Assign Permissions Author

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
values (5, 1), (5, 2),(5, 3);

--Assign Permissions Guest

INSERT INTO readifined.assigned_permissions
(user_roles_id, permissions_id)
VALUES(6, 3);

select p.id, p.permission_type 
	from readifined.user_roles ur, readifined.permissions p, readifined.assigned_permissions ap 
		where ur.id = ap.user_roles_id 
			and p.id = ap.permissions_id 
			and ur.id = 2;
			


insert into readifined.genre
(genre)
values('Fiction Books Literature');

insert into readifined.genre
(genre)
values('Graphic Novels');

insert into readifined.genre
(genre)
values('Horror');

insert into readifined.genre
(genre)
values('Mystery Crime');

insert into readifined.genre
(genre)
values('Poetry');

insert into readifined.genre
(genre)
values('Romance Books');

insert into readifined.genre
(genre)
values('Science Fiction Fantasy');

insert into readifined.genre
(genre)
values('Thrillers');

insert into readifined.genre
(genre)
values('Westerns');

insert into readifined.genre
(genre)
values('Ages 0-2');

insert into readifined.genre
(genre)
values('Ages 3-5');

insert into readifined.genre
(genre)
values('Ages 6-8');

insert into readifined.genre
(genre)
values('Ages 9-12');

insert into readifined.genre
(genre)
values('Teens');

insert into readifined.genre
(genre)
values('Childrens Books');

insert into readifined.genre
(genre)
values('African Americans');

insert into readifined.genre
(genre)
values('Antiques Collectibles');

insert into readifined.genre
(genre)
values('Art, Architecture Photography');

insert into readifined.genre
(genre)
values('Bibles Bible Studies');

insert into readifined.genre
(genre)
values('Biography');

insert into readifined.genre
(genre)
values('Business Books');

insert into readifined.genre
(genre)
values('Christianity');

insert into readifined.genre
(genre)
values('Computer Books Technology Books');

insert into readifined.genre
(genre)
values('Cookbooks, Food Wine');

insert into readifined.genre
(genre)
values('Crafts Hobbies Books');

insert into readifined.genre
(genre)
values('Education Teaching');

insert into readifined.genre
(genre)
values('Engineering');

insert into readifined.genre
(genre)
values('Entertainment');

insert into readifined.genre
(genre)
values('Foreign Languages');

insert into readifined.genre
(genre)
values('Game Books');

insert into readifined.genre
(genre)
values('Health Books, Diet Fitness Books');

insert into readifined.genre
(genre)
values('History');

insert into readifined.genre
(genre)
values('Home Garden');

insert into readifined.genre
(genre)
values('Humor Books');

insert into readifined.genre
(genre)
values('Judaism Judaica');

insert into readifined.genre
(genre)
values('Law');

insert into readifined.genre
(genre)
values('Medical Books');

insert into readifined.genre
(genre)
values('New Age Spirituality');

insert into readifined.genre
(genre)
values('Nonfiction');

insert into readifined.genre
(genre)
values('Parenting Family');

insert into readifined.genre
(genre)
values('Pets');

insert into readifined.genre
(genre)
values('Philosophy');

insert into readifined.genre
(genre)
values('Political Books Current Events Books');

insert into readifined.genre
(genre)
values('Psychology Psychotherapy');

insert into readifined.genre
(genre)
values('Reference');

insert into readifined.genre
(genre)
values('Religion Books');

insert into readifined.genre
(genre)
values('Science Nature');

insert into readifined.genre
(genre)
values('Self Improvement');

insert into readifined.genre
(genre)
values('Sex Relationships');

insert into readifined.genre
(genre)
values('Social Sciences');

insert into readifined.genre
(genre)
values('Sports Adventure');

insert into readifined.genre
(genre)
values('Study Guides Test Prep');

insert into readifined.genre
(genre)
values('Travel');

insert into readifined.genre
(genre)
values('True Crime');

insert into readifined.genre
(genre)
values('Weddings');

insert into readifined.genre
(genre)
values('Womens Studies');

select * from readifined.genre;
			
INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number)
VALUES('test', 'test', 'test', 'test', 'test@gmail.com', '2002-02-02', '7165244256');

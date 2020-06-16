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

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('OK', 'ROSE', 'R4675', 'OROS1935', '3589@hotmail.com', '1967-01-07', '4535275757', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('EMANUEL', 'DUNN', 'D9064', 'EMDU3015', 'EMDU6595@yahoo.com', '1954-02-03', '7791279886', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GENNIE', 'EDWARDS', 'GENNI3918', 'EDWAR6980', 'GENNIEDWAR9592@msn.com', '1934-10-22', '4854631449', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('OMER', 'MURPHY', 'OMM3268', 'OMM4080', 'MURPH524@hotmail.com', '1980-02-27', '4275392348', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOHN', 'GRAHAM', 'JOGRAHA1576', 'JOHGR8429', 'JOHGR6237@yahoo.com', '1963-10-21', '4718532641', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GHISLAINE', 'MORRIS', 'GHISLAM4686', 'GHISMO3475', 'GHISLMORR452@msn.com', '1988-06-09', '5136252959', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KARYN', 'CRAWFORD', 'KCRA6042', 'KARCRAWF4833', 'KACR7058@hotmail.com', '1995-05-03', '4973965288', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JEAN', 'REED', 'JEAR4276', 'REE2208', 'J8074@hotmail.com', '1946-09-03', '6368874237', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ANGEL', 'ROBERTS', 'ANGRO8034', '5516', 'ANGR1003@aol.com', '2010-09-27', '4311169968', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TIMMY', 'ROBERTSON', 'TIMMROBERTS9402', 'TIMROBER6561', 'TIROB7607@aol.com', '2009-12-26', '6174587877', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ALIX', 'DANIELS', 'ADANI1836', 'ADAN2309', 'ALDANI3874@hotmail.com', '1975-11-06', '6354827941', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('VERNON', 'MCDONALD', 'VM6206', 'VERNMCD6127', 'VMC8020@aol.com', '1966-07-18', '4311558331', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AYESHA', 'TAYLOR', 'ATAYLO1709', 'AYET8580', 'AYESHTAY3303@hotmail.com', '2006-10-16', '6962754485', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('EMERSON', 'CARTER', 'EMERCARTE6953', 'ECA9170', 'CART679@yahoo.com', '1958-12-16', '4224514895', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TIESHA', 'PARKER', 'TI454', 'TPARK4600', 'PA1346@yahoo.com', '2008-03-15', '6392967511', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BRITTANEY', 'REED', 'B5119', 'BR6441', 'BREE7922@yahoo.com', '1979-02-05', '4844764644', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('SHAKIA', 'STEVENS', 'SSTE4', 'STE9090', 'SHAKISTEVEN517@msn.com', '1984-03-21', '6644425498', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LACRESHA', 'WEBB', 'LAC7353', 'LACRE411', 'LAC4109@aol.com', '1923-05-03', '5232622939', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LOREEN', 'HENDERSON', 'HENDER3398', 'LOREEHEND8980', 'LOHENDE1521@yahoo.com', '1947-05-21', '5294249182', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LETITIA', 'WOODS', 'LETW3976', 'LWOOD8521', 'WOOD4713@hotmail.com', '1925-06-18', '7513456355', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LUIGI', 'OWENS', 'LOWEN3734', 'LUIOWE8287', 'LOW6131@msn.com', '1958-07-09', '5259975242', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARCELINA', 'ELLIS', 'MARCEEL3337', 'MAREL799', 'MARCE791@yahoo.com', '2002-06-01', '6652475829', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOIE', 'HOLMES', 'J5581', 'JH7520', 'JOHOLM7650@msn.com', '1926-04-06', '6697333817', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CRYSTAL', 'MARTIN', 'CRYSTAMART6881', 'CRYSTAM3866', 'CRYSM6157@gmail.com', '1944-02-01', '7769563512', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MIRIAM', 'MCDONALD', 'MIRIAMCDON4509', 'MIRIMCDO9018', 'MIRIAMCDONAL6573@gmail.com', '1945-10-27', '6672645123', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TAM', 'GONZALEZ', 'TAGO9157', 'GONZ3354', 'TAGONZA367@gmail.com', '1928-01-07', '5219595826', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ROMA', 'FERGUSON', 'R2672', 'R3007', 'FERGUS3497@hotmail.com', '1938-04-23', '5196417917', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('STEPHANIA', 'LEE', '7173', 'STL5658', 'STEPHALE179@gmail.com', '1926-08-12', '4738126396', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('IRVING', 'HARRISON', 'IRV2288', 'IRVINHAR8542', 'IRVINHAR6997@hotmail.com', '2009-08-28', '7339682615', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LILLY', 'HERNANDEZ', 'LILL3941', 'LIHERN331', 'HERNAN6490@yahoo.com', '1931-03-27', '6189327197', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MITSUKO', 'HAMILTON', 'MITSHAMI3295', 'MHAM2187', 'MIHAMILT3545@msn.com', '1955-09-01', '4843424518', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TIMMY', 'HUGHES', 'THUGHE4203', 'HUGHE8915', 'HUG3473@yahoo.com', '1979-08-26', '4573691251', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('HEDY', 'WRIGHT', 'HEDWRIGH6286', 'HW4868', 'WRIGH1058@aol.com', '2005-12-16', '5548176688', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOAN', 'STEVENS', 'JOST7288', 'JS1898', 'JS1977@msn.com', '1979-08-16', '7527129742', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KAMILAH', 'SCOTT', 'KAMI7751', 'KAMILAS5812', 'KAMIS6804@hotmail.com', '1972-02-17', '5118354313', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARIETTE', 'LEWIS', 'MARLEWI5522', 'M846', 'MARIL3871@aol.com', '1952-12-13', '6699792278', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('OLEVIA', 'MARTINEZ', 'OLEVMAR1214', 'OLEVMARTIN3288', 'MAR7062@hotmail.com', '2015-10-05', '6959963593', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JERMAINE', 'GRIFFIN', 'JERGR9744', 'JERMAINGR731', 'JERMAIGRIFFI1520@aol.com', '1933-09-13', '5631336862', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DANA', 'BURNS', 'DABU5494', 'DBU1397', '1278@msn.com', '1976-02-27', '4682238361', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MECHELLE', 'COLLINS', 'MECHELLCOLLI6525', 'MECHELLCOLL7134', 'CO6329@msn.com', '1961-01-11', '6264536553', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('SUSANNE', 'WARREN', '9297', 'SUSWARRE7664', 'SUSANW6548@msn.com', '1936-12-01', '6558354453', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LULU', 'EVANS', 'L798', 'EVA1029', 'LUEVA6523@msn.com', '1945-06-25', '7938228685', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAYNARD', 'MILLS', 'MAY3131', 'MAYNMI7516', 'MA5516@msn.com', '1993-10-14', '4374361994', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BRITNEY', 'RIVERA', 'RIVE120', 'RIVE5368', 'BRITNRIV3011@gmail.com', '1971-05-05', '6935895155', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('EUGENIA', 'ROBERTSON', 'EUGENROBER6796', 'EU2376', 'ROBER4752@gmail.com', '2006-06-04', '4988259843', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TIMIKA', 'PERRY', 'TIMPERR9000', 'T9687', 'TIMIKPER9984@yahoo.com', '1984-09-26', '6352472291', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DORATHY', 'COX', 'DOR7394', 'DCO76', 'DOC5916@msn.com', '1991-12-12', '4896776175', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LEMUEL', 'COLE', 'C6040', 'LEMUC8136', 'LEMCOL694@msn.com', '1983-05-13', '7286973171', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TESSA', 'KING', 'TES3870', 'TESSKIN8081', 'TKI2310@msn.com', '1923-11-26', '5363332933', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ISMAEL', 'JORDAN', 'ISMAEJ6923', 'ISMAE358', 'JORD992@hotmail.com', '2010-04-13', '6248968947', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JANEY', 'JONES', '4303', 'JANE1455', 'JAJON8060@hotmail.com', '1933-02-09', '6134838421', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('SPRING', 'BUTLER', 'SPRIB3018', 'SPRINB2164', 'SBUT6977@yahoo.com', '1965-02-13', '5511965167', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KECIA', 'GRANT', 'KECGR4795', 'KG6814', 'KECIGR833@yahoo.com', '1946-05-16', '4264964174', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DEVORA', 'HERNANDEZ', 'DEVHERNAND4151', 'DEVOHERNAN8189', 'DEVHERNA3847@hotmail.com', '1999-03-22', '4188635358', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NEAL', 'MORALES', 'NMORAL6862', 'NM8073', 'NEMOR318@gmail.com', '1940-08-19', '6411481613', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ROBIN', 'GOMEZ', 'ROBIGO3208', 'ROGOM4222', 'ROGOME5739@hotmail.com', '1952-08-28', '7451834831', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOSLYN', 'EDWARDS', 'JED4669', 'JOSEDWARD960', 'JOED5029@hotmail.com', '1935-11-27', '7469113137', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DEON', 'TURNER', 'DE5833', 'TURNE974', '8377@gmail.com', '1970-02-01', '6462322878', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARQUITA', 'KNIGHT', 'KN7187', 'KNIGH4977', 'MAKN321@msn.com', '1931-08-27', '7782752618', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DYLAN', 'THOMAS', 'DYLTHO8951', 'D7677', 'DYLATHOM9804@hotmail.com', '1991-03-20', '6373593394', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DAYNA', 'GRIFFIN', 'DGR260', 'DG2451', 'DAY2617@msn.com', '2007-02-07', '4817943138', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KAROL', 'ALEXANDER', 'KAA7217', 'KAROALEX536', 'KALEX5896@msn.com', '2016-08-27', '7862132265', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LAUREEN', 'ROBERTS', 'LAUREERO4784', 'ROB7126', 'LROBER5015@gmail.com', '1981-12-09', '5297118566', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BOK', 'WEST', 'B1135', 'B8723', 'W1157@msn.com', '1981-03-23', '7477385455', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GWENN', 'FLORES', 'GFLO6063', 'GFLO9256', 'FL6191@hotmail.com', '1980-06-18', '4593326449', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NED', 'WILSON', 'NEW1223', 'WIL3641', 'NWILS5007@gmail.com', '1989-03-04', '7163982956', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('XENIA', 'SMITH', 'SM9605', 'XSMI6329', 'XENS6491@hotmail.com', '1995-02-22', '4548922815', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ESTELL', 'WARREN', 'EWA3254', 'EST9557', '5977@hotmail.com', '2010-07-11', '6993437162', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAGAN', 'TUCKER', 'MATUCK9855', 'MATU4903', 'MTUCKE6127@aol.com', '1954-06-04', '4884737321', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ANJELICA', 'LEWIS', 'AL2118', 'ANJELICL4602', 'ANJELICLEW2146@aol.com', '1978-09-18', '4336499834', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARKETTA', 'KING', 'MARKIN6258', 'MARKETK3846', 'MARKKI8704@hotmail.com', '1997-05-08', '5186454812', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WILLENE', 'JAMES', 'WILL380', 'WIJAME6492', 'WJAM8834@msn.com', '1993-11-12', '7331336124', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CARTER', 'PRICE', 'CPRI9333', '7158', 'CARPRIC1567@yahoo.com', '1936-05-09', '4778345935', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ESTEFANA', 'GRAY', 'ESTEFANGR7737', 'ESTEFAGRA6021', 'EST4101@msn.com', '1951-09-05', '6682899126', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MYRTIE', 'FREEMAN', 'MYFREEM5736', 'MYRTI50', 'MYRTFR883@aol.com', '1970-01-28', '7652921886', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('HANA', 'BARNES', 'HANBA8124', 'HABAR2028', '1715@msn.com', '2015-03-06', '5678781638', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DANITA', 'MARSHALL', 'DAMARSHAL7222', 'DANIM936', 'DANMA7158@gmail.com', '1926-07-23', '7546295822', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARIELLE', 'WALKER', 'MAWAL5056', 'MARIELLWALKE1105', 'MAWALKE7032@aol.com', '1990-11-25', '6588886987', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('VERONA', 'MURPHY', 'VEROMURP327', 'VERM7288', 'VMURP6937@hotmail.com', '1928-03-19', '4588885835', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAJORIE', 'REYNOLDS', 'MR3482', 'MAJORIREYN3127', 'MAREYNOL4856@msn.com', '2005-09-06', '7457568664', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JENEVA', 'PATTERSON', 'JENEVPATTERS2603', '4172', 'JEN7061@aol.com', '1949-06-13', '6786273864', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ROBT', 'PERRY', 'ROPE1189', 'ROP689', 'ROPE6478@aol.com', '1980-06-18', '5984518134', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('VALENTINE', 'NICHOLS', 'VANICHOL7583', 'NI6176', 'VALENIC6804@msn.com', '1943-04-16', '5772497222', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DOUGLAS', 'SHAW', 'DOUGS6287', 'DOUGL6858', 'DOUGLASH6654@msn.com', '2014-02-20', '6837171629', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('STEFANI', 'SMITH', 'STSM8330', 'STSMIT179', 'STS3627@aol.com', '2017-09-08', '7389271251', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KAITLYN', 'MASON', 'KAITL3412', 'MA2304', 'KMAS5282@aol.com', '2011-06-13', '7354745311', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('HYO', 'ROSE', 'HRO2830', 'HR8132', '5757@yahoo.com', '1920-07-09', '5425692413', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ELVIE', 'KELLY', 'EKEL1612', 'E6160', 'KE5845@hotmail.com', '1995-11-11', '7489193917', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KELLEE', 'HERNANDEZ', 'KELHERN626', 'KELLEHERNA4324', 'HERNANDE1491@aol.com', '1934-03-25', '7137232888', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DANIELLA', 'JONES', 'DANIJON5854', 'JO9511', 'DANIJ7662@msn.com', '1926-07-02', '5781673473', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('FELICIA', 'PATTERSON', 'FELIP4082', '888', 'FEPATTERS4439@gmail.com', '1985-10-12', '4512149811', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CECILA', 'CRUZ', 'CECC5754', 'CCR5827', 'CCR4026@yahoo.com', '1973-06-16', '4319215482', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAURICE', 'MARTIN', 'MAUMA4039', '7547', '3284@hotmail.com', '1929-04-07', '6565687387', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DALENE', 'LEE', '7764', 'L6075', 'D4170@hotmail.com', '1941-08-13', '6183745497', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GASTON', 'EDWARDS', 'GASTEDW9756', 'GEDWA7085', 'GASTOEDWAR3917@hotmail.com', '2014-07-06', '4327996533', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NELLIE', 'THOMAS', 'NELLTH7148', 'NETHOMA3780', 'NELLTH5618@hotmail.com', '2008-12-07', '7386136459', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARIANO', 'BARNES', 'MARIBARN3181', 'MARIABA8558', 'MARBARNE4381@msn.com', '2003-05-14', '5843867844', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NONA', 'HOWARD', 'HOW9065', 'HOWAR9845', 'NOHOWAR7656@yahoo.com', '1953-05-01', '5175443527', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOHNNA', 'HAYES', 'JOHNNHAY5622', 'JOH1853', 'JOHH7955@aol.com', '1942-07-01', '4132331368', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KARRY', 'THOMAS', 'K5344', 'THOMA7607', 'KATHOMA8260@gmail.com', '1989-11-14', '6394483591', '');

select * from readifined.person;
drop schema if exists readifined cascade;
create schema readifined;

drop table if exists readifined.person cascade;
create table readifined.person(
	id serial, 
	first_name varchar(100),
	last_name varchar(100),
	user_name varchar(50) not null unique,
	user_password varchar(1000) not null,
	email varchar(100) not null unique,
	date_of_birth date,
	phone_number varchar(20),
	session_token varchar(1000),
	constraint person_id_pk primary key (id)
);

drop table if exists readifined.book cascade;
create table readifined.book(
	id serial,
	title varchar(100) not null,
	price numeric(7,2),
	author integer not null, 
	cover_img varchar(200),
	book varchar(200),
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
			
----------------------------------------- User Data -------------------------------------------------------------

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CIARA', 'MOORE', 'CIM9664', 'CIAM9873', 'CIMOO2652@yahoo.com', '1946-09-11', '7774672329', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LOURA', 'BURNS', 'LOURBU929', 'LOURBUR2183', 'LOUBUR8476@msn.com', '1946-07-05', '4762479188', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RONALD', 'EVANS', 'E9920', 'EVA8547', 'RONALEV6107@aol.com', '1958-04-05', '4822579165', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('SHANTI', 'BAKER', 'SHANT1456', 'SH6179', 'SHBAKE8424@yahoo.com', '1972-03-18', '7663489867', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('SHELLY', 'KELLY', '8745', 'SHELL4160', 'SHELKEL426@aol.com', '1961-04-03', '4457394746', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('THALIA', 'WALLACE', 'THALIWALLA3229', 'WA4448', 'TWAL9572@msn.com', '1986-11-22', '6513768472', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('EVERETT', 'FOSTER', 'EVEF4529', 'EVERFOS7134', 'EV8773@gmail.com', '1960-08-01', '6933963148', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TERESA', 'RICHARDSON', 'TRICH4179', 'RI7909', 'TRICH9718@gmail.com', '1959-08-26', '5497945331', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KORY', 'COOK', '5951', 'KOR4299', 'KORCOO5184@hotmail.com', '1949-12-12', '7457211187', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TERISA', 'PRICE', 'TEP8958', 'TEPRI7973', 'TERIPR337@yahoo.com', '2009-05-24', '7163551167', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ANNAMAE', 'SCOTT', 'ASC148', 'ANS1738', 'ANNAMAS3369@yahoo.com', '2000-10-20', '5225385691', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BREANN', 'KNIGHT', 'BRKN8866', 'BREANK586', 'BREA104@aol.com', '1933-03-20', '5436498714', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NELLA', 'FREEMAN', 'NELFREEMA2896', 'NFR5301', 'NFR619@hotmail.com', '2007-06-26', '6296289321', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DENNISE', 'PETERSON', 'DENPE6040', 'DENN6149', 'D5056@aol.com', '1991-02-06', '7792144941', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JONIE', 'CAMPBELL', 'JCAMP5444', 'JONCAM9521', 'JOC9219@yahoo.com', '1937-05-11', '6792368424', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RICH', 'POWELL', 'PO1531', 'RIC7398', 'RIC6905@hotmail.com', '1938-05-06', '5564126248', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARYROSE', 'CAMPBELL', 'C9950', 'MARCA311', 'CAMPBE1644@yahoo.com', '1975-03-09', '5421713691', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('FIONA', 'COOK', '4188', 'FCOO2654', 'FIOC8782@aol.com', '1960-05-08', '5693962468', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MARSHA', 'SHAW', 'M4263', 'MARSHSH4334', 'MARSS1264@aol.com', '2011-01-03', '6827172941', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JENETTE', 'MYERS', 'JENETTMYE7415', '9569', 'JEM6967@msn.com', '2016-11-05', '4166759551', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WENDOLYN', 'BAILEY', 'WBAILE3603', 'WENDOLBAI4977', '5763@hotmail.com', '2008-07-14', '6914842919', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GENIE', 'WELLS', 'GENW7909', 'G4608', 'GEN1346@msn.com', '1965-07-26', '7965399324', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AI', 'MARTIN', 'AMA3264', 'AMART4266', 'AMAR1132@aol.com', '1952-07-01', '4965818855', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JADA', 'TURNER', 'JATURN4604', 'JATU8509', '2574@yahoo.com', '1981-12-06', '6484187649', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AVIS', 'SMITH', 'AVI688', 'ASM2160', 'SMI4146@msn.com', '1959-05-18', '6618926233', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ERVIN', 'COLLINS', 'ERVC1367', 'ERVCO5706', 'ECOLLIN2562@gmail.com', '1954-11-09', '5769296875', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CHRISTIANE', 'CRAWFORD', 'CHRCRAW1220', 'CHRIST8108', 'CHRIST7704@msn.com', '2012-05-05', '4233252778', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DARRYL', 'PARKER', 'PAR1261', 'D1984', 'DAPARKE5522@gmail.com', '2011-08-22', '7288613289', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WILLETTE', 'GRAY', 'WIGR3023', 'WILG1267', 'WIL7785@gmail.com', '1979-09-20', '6712673653', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WENDOLYN', 'WASHINGTON', 'WENDWAS4844', 'WENDOLWASHINGT4717', 'WENDOL8183@aol.com', '1990-08-26', '7449167398', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ANASTACIA', 'COOK', 'ANASTCO3397', '9537', 'ANASCO6164@gmail.com', '1924-05-11', '7272677979', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('KLARA', 'SCOTT', 'KLAR7337', 'KL6961', 'KLSCO8440@yahoo.com', '1994-06-03', '5687863738', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAXIMINA', 'BLACK', 'MAXI2268', 'MABL1037', 'MAXIMINBL6786@aol.com', '1966-09-09', '5991822616', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DOUGLAS', 'BELL', 'DOBEL5561', 'DOUBEL7231', 'DOUGLABEL6759@hotmail.com', '1996-01-24', '7692477937', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ROOSEVELT', 'WASHINGTON', 'RWASHIN6680', 'ROOSEVWASHI34', 'ROOSEVELWASH7684@msn.com', '1990-09-05', '5722484542', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JACK', 'NELSON', 'JANEL8525', 'JACNE4345', 'NELSO8984@gmail.com', '1928-05-02', '5614394359', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WARD', 'DIXON', 'WADIXO1360', 'WA4548', '2441@hotmail.com', '2017-03-09', '7991376132', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ALLEN', 'DIXON', 'A7281', 'ALLED6768', 'ALLDIXO8269@msn.com', '1984-10-19', '5115449288', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TONDA', 'CLARK', 'TONDCL4963', 'T2531', 'C2993@hotmail.com', '1985-11-10', '7287245439', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ASHLYN', 'WASHINGTON', 'AWASH5319', 'ASHLYWASHIN9659', 'AW3807@yahoo.com', '2005-11-02', '6932236267', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('IONE', 'LOPEZ', 'LOPE5986', 'IONLOP818', 'IOL9628@yahoo.com', '1933-11-02', '5713764151', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DANA', 'HAMILTON', 'HAMILTO3022', 'D6378', 'DAN2914@hotmail.com', '1927-08-02', '5729638912', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ILENE', 'MYERS', 'MY8915', 'IMYER9209', 'ILE2863@aol.com', '1964-05-28', '7183693381', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LORELEI', 'GRANT', 'LGRAN4432', 'LOGRAN2119', 'LORG5189@aol.com', '1973-10-26', '4322623914', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('REFUGIO', 'WOODS', 'REFWOO9503', 'REFUWOOD6397', 'REFUGIWOOD870@gmail.com', '1947-06-14', '5683277275', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('PATSY', 'RICE', 'PRI9685', 'PRI8409', 'PA9413@msn.com', '1973-12-27', '6123256619', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ELEANORA', 'WHITE', 'ELEANORWHI9051', 'ELWH6412', 'ELEAWH7473@yahoo.com', '1969-12-06', '6942549627', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAILE', 'MITCHELL', 'MAILM7307', 'MMITCHE5739', 'MAILMITCHEL7126@hotmail.com', '1986-06-02', '4816497449', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LYNDA', 'LOPEZ', 'L8183', '4896', 'LYNDLOP2468@hotmail.com', '1992-01-22', '7421969188', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RUDOLF', 'BURNS', '7807', 'RUDBU5528', 'RUDBURN8879@msn.com', '2004-01-21', '7854123952', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LUCIE', 'STEVENS', 'LUSTEVEN279', 'LSTEV2534', 'LUSTEVEN8028@aol.com', '2000-12-07', '6488621697', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ARDELL', 'MORALES', 'AMORAL5710', 'ARDELMOR6225', 'ARD6460@hotmail.com', '1999-09-20', '7295367565', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TAD', 'WALLACE', 'TA2572', 'TW4540', 'TAW6605@msn.com', '1933-07-05', '5346969663', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AMIEE', 'EVANS', 'AMIE6889', 'AM3406', 'AMIEEV6270@msn.com', '1956-08-22', '6296987615', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('STACY', 'MITCHELL', 'STMITCHE4862', 'MITCHEL3075', 'STACMITCH8497@gmail.com', '2010-01-14', '7284347942', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JUANITA', 'CARTER', 'JUCART4422', 'JCAR7486', 'CA1842@aol.com', '1941-11-28', '7486152169', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AMIEE', 'JONES', 'AMJONE3407', 'AMIEJONE2421', 'AMJ9212@hotmail.com', '1992-02-25', '4374835156', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ZELMA', 'TAYLOR', 'ZETAYLO3905', 'ZELMTAYL7591', 'TA2382@aol.com', '1962-12-24', '6149842726', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('YULANDA', 'RICE', 'YUL1802', 'R4013', 'YRIC9224@gmail.com', '2017-01-06', '7718738514', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JACKIE', 'THOMAS', 'JACKI2827', 'JATHOMA8465', 'JACKITH1865@msn.com', '1940-05-19', '5268211657', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DUSTY', 'GORDON', 'DUSTGOR7276', 'DUSTG7961', 'DGORD3349@gmail.com', '1986-09-24', '7543478179', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MAHALIA', 'ORTIZ', 'MAHO9510', 'MAHO9690', 'MAHORT8171@msn.com', '1982-09-02', '5523192678', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RANEE', 'CARTER', 'RCA4100', 'RCARTE6655', 'RAN7785@hotmail.com', '1960-10-25', '7475189794', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BRUNO', 'PEREZ', 'BRUN6634', 'BRUNPE4245', 'BPE8049@aol.com', '1992-09-16', '5779381681', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GENIE', 'BAILEY', '9874', 'BAIL2975', 'GENBA8241@aol.com', '1970-12-21', '4767138856', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('VANESSA', 'KING', 'VK9419', 'VANES6494', 'VAKI4794@aol.com', '1997-11-03', '5692766191', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOAQUINA', 'GONZALEZ', 'JOAQGONZ2465', 'JOAGONZA9606', 'JOAQUIGON3902@gmail.com', '1926-03-14', '4143773356', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('WILBERT', 'MORRIS', 'W9077', 'M5998', 'WIMORRI862@gmail.com', '1930-10-20', '4335946141', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BUNNY', 'PERRY', 'BU1405', 'BUPER3508', 'BUNNP1149@msn.com', '1976-01-13', '4561633864', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BROOKS', 'STONE', 'BRS1171', 'BROST1855', 'BROOKS7225@hotmail.com', '1988-12-19', '5498732645', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOSEFINA', 'DIAZ', 'JOSEF3378', 'DIA1129', '9577@msn.com', '1922-02-03', '6353139764', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MIESHA', 'WRIGHT', 'MIW1462', 'MIESWR6971', 'MIES5987@yahoo.com', '1930-08-27', '7212713287', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CORINNE', 'TURNER', 'CORINNTURN5051', 'COTURNE9550', 'TURN7479@gmail.com', '1961-09-21', '7582655884', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('TANNA', 'DIAZ', 'TAN4956', 'D4825', 'TANNDIA4916@hotmail.com', '1948-11-25', '6874778634', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MONICA', 'DAVIS', 'MODA2203', 'MOND3527', 'DAVI5823@gmail.com', '1945-12-07', '4355244182', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NEVA', 'JOHNSON', 'J2132', '2030', 'NEJOHNSO791@msn.com', '1984-03-03', '5231796386', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ANGELYN', 'JOHNSON', 'ANGELYJOHN6610', 'ANGEJOHN9926', 'ANGELYJO5551@yahoo.com', '2018-02-04', '5559396191', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('HYO', 'HALL', 'HAL3589', 'H4787', 'HAL242@yahoo.com', '2007-07-22', '7526172919', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JUDIE', 'BRYANT', 'BRY4986', 'JBR3431', 'JBRY7933@msn.com', '1937-10-17', '4259637222', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('JOSEFINE', 'COLE', 'JOCO4248', 'J9498', 'JOSEFICOL295@gmail.com', '1928-10-27', '7215552877', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('FARRAH', 'DIXON', 'FD9495', 'FARDIXO8331', 'FAR1803@msn.com', '2005-04-24', '7582932123', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('LADONNA', 'HICKS', 'LHIC5493', 'HIC6478', 'LADONN479@aol.com', '1974-10-03', '7125919198', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('STEVIE', 'RIVERA', 'SRIVER6692', 'STEVIRIVE7556', 'STERIVER2621@gmail.com', '1950-10-28', '6682214644', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CAROL', 'HAYES', 'CARHA5705', 'CAHAYE5380', 'CAROHA1501@aol.com', '1921-05-24', '5268741523', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('VENETTA', 'BURNS', 'VEBURN3284', 'VE491', 'VENE351@yahoo.com', '1922-06-06', '5928194339', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('BETSY', 'HARRISON', 'BHARRIS1861', 'BETHARRI5718', 'BH3052@yahoo.com', '2015-08-07', '7358225963', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('DIONNE', 'BENNETT', 'DIBENNET4068', 'DIOB9322', 'DIBENN9598@msn.com', '1991-06-01', '7675614969', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CHERLY', 'CRUZ', 'CH2882', 'CH6465', 'CHERLCRU8943@msn.com', '1930-12-24', '6249659686', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('NIKOLE', 'ROGERS', 'NIR4972', 'NI6809', 'NROGE2257@hotmail.com', '1962-10-28', '5867914315', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('CORY', 'HOLMES', 'COHOLM9718', 'COR9932', 'CORH7232@hotmail.com', '1951-04-18', '5755469955', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('GENE', 'COOPER', 'GENC1022', 'CO9340', 'GECOOP7709@msn.com', '1931-01-13', '7672119568', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RICARDO', 'YOUNG', 'RICARY425', 'R5337', 'RIYO8374@msn.com', '1940-03-04', '6344169333', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('HOLLI', 'MASON', 'HM5736', 'MA4058', 'MA7683@yahoo.com', '1974-04-04', '7535212691', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MADALYN', 'ADAMS', 'MADAL1028', 'MADALAD2502', 'MADALADAM8209@msn.com', '1936-06-10', '7736829398', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('AVRIL', 'HENRY', 'AVH6174', 'AVRHENR4814', 'HENR7708@msn.com', '1982-10-06', '7677418662', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ESTER', 'WEBB', 'ES3218', 'ESTWEB6594', '5042@gmail.com', '1999-04-21', '4479962598', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('ROYAL', 'POWELL', 'ROP5656', 'ROPO5410', 'POWE9730@hotmail.com', '1981-12-18', '7795521149', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MYRLE', 'STEVENS', 'MYRS6043', 'MYRL7665', 'MYRL5481@msn.com', '1996-11-20', '6743431529', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('MIRIAM', 'JACKSON', 'MIRJ7006', 'M8683', 'MIJACKSO4215@yahoo.com', '1954-08-17', '6762412985', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('RANDI', 'WEST', 'RWES4537', 'RAWES8042', 'RANDW1853@yahoo.com', '1959-11-12', '7177252383', '');

INSERT INTO readifined.person
(first_name, last_name, user_name, user_password, email, date_of_birth, phone_number, session_token)
VALUES('test', 'test', 'test', 'test', 'test@yahoo.com', '1959-11-12', '7177252344', 'sessiongoeshere');


select * from readifined.person;

------------------------------------------- Register authors----------------------------------------------------

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(1,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(2,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(3,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(4,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(5,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(6,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(7,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(8,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(9,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(10,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(11,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(12,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(13,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(14,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(15,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(16,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(17,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(18,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(19,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(20,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(21,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(22,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(23,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(24,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(25,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(26,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(27,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(28,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(29,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(30,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(31,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(32,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(33,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(34,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(35,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(36,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(37,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(38,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(39,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(40,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(41,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(42,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(43,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(44,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(45,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(46,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(47,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(48,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(49,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(50,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(51,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(52,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(53,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(54,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(55,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(56,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(57,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(58,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(59,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(60,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(61,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(62,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(63,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(64,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(65,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(66,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(67,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(68,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(69,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(70,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(71,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(72,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(73,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(74,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(75,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(76,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(77,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(78,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(79,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(80,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(81,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(82,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(83,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(84,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(85,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(86,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(87,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(88,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(89,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(90,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(91,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(92,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(93,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(94,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(95,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(96,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(97,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(98,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(99,5);

INSERT INTO readifined.registered_role
(person_id, user_roles_id)
VALUES(100,5);



-------------------------------------------- Book Data ---------------------------------------------------------

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Combating Surgical Infection',54.20552453853696, 12, 'https://covers.openlibrary.org/b/id/3140444-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chirurgie implantaire',53.00130123169647, 38, 'https://covers.openlibrary.org/b/id/3140972-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La 7e porte',44.17644218073876, 66, 'https://covers.openlibrary.org/b/id/3142273-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les gens de la vallee',0.45926645132893323, 71, 'https://covers.openlibrary.org/b/id/3142519-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le Cerveau bleu',81.05618843266534, 5, 'https://covers.openlibrary.org/b/id/3142847-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A la recherche de lâme de mon père',3.127503838269975, 100, 'https://covers.openlibrary.org/b/id/3143247-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hématologie et soins infirmiers',0.4838325440244335, 61, 'https://covers.openlibrary.org/b/id/3144815-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('LAgartha mythe ou réalité',71.18868108423753, 10, 'https://covers.openlibrary.org/b/id/5203862-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Football',87.30444198263613, 24, 'https://covers.openlibrary.org/b/id/3145658-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die Moxa - Therapie. Wärmepunktur - Eine klassische chinesische Heilmethode',87.25720174607675, 66, 'https://covers.openlibrary.org/b/id/3193955-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dominique delise',96.04085600278444, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The man from Thrush',32.39080342345025, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Offrandes De La Mer',45.25190341140449, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La grande encyclopédie du dérisoire, tome 1',75.79057695879328, 28, 'https://covers.openlibrary.org/b/id/3147542-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('W swiecie polszczyzny',38.18142175191469, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guide des sources dinformation',44.170387462735945, 45, 'https://covers.openlibrary.org/b/id/3148100-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Invention du hottentot histoire du regard occidental sur les khoisan XV-XIX',5.073464355288477, 54, 'https://covers.openlibrary.org/b/id/3148634-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De philippe auguste a la mort de charles V',42.12524130065167, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Choisir et poser portes et fenêtres',76.12120631054697, 4, 'https://covers.openlibrary.org/b/id/3148853-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manufactura Justo a Tiempo - Enfoque Practico',59.1119689776135, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De natura',85.12049764626825, 71, 'https://covers.openlibrary.org/b/id/3150034-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Korb',80.21491605448703, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le travail du sucre, tome 2',18.556296290120866, 37, 'https://covers.openlibrary.org/b/id/3150290-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les défis de la travailleuse familiale',38.00123996863987, 66, 'https://covers.openlibrary.org/b/id/3150401-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jean Vigo',95.1233667384774, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Thaïlande',36.52267246038894, 8, 'https://covers.openlibrary.org/b/id/3150958-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Locations meublées et locations saisonnières',29.564260384235613, 8, 'https://covers.openlibrary.org/b/id/3151251-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Analyse statistique des donnees experimentales',65.56103296060473, 78, 'https://covers.openlibrary.org/b/id/3152210-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le nouveau menoza',11.06017774817201, 49, 'https://covers.openlibrary.org/b/id/3152641-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Feliz Dia!',0.017198237903394527, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Write Your Business Plan!',15.028071209319478, 23, 'https://covers.openlibrary.org/b/id/3165063-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pygmées dAfrique Centrale',49.71016697318707, 42, 'https://covers.openlibrary.org/b/id/5204177-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les meilleures soupes',82.0598329989528, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La vérité sur les cosmétiques',65.07037954968722, 8, 'https://covers.openlibrary.org/b/id/3156336-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cuisine basque',50.51368728963247, 57, 'https://covers.openlibrary.org/b/id/3156601-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La cuisine des mousquetaires, tome 2',60.191931347956505, 15, 'https://covers.openlibrary.org/b/id/3156722-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Méthodes multicritères ELECTRE',97.57464979866262, 98, 'https://covers.openlibrary.org/b/id/3157014-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jai pas sommeil !',0.004388327138190181, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Victoires sur soi',68.23655509402693, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Middle East:A Closer Look/Cav',54.3153445846793, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les risques du voyage',94.11618561257279, 20, 'https://covers.openlibrary.org/b/id/5204451-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Poésie et réalité',32.0074687954604, 10, 'https://covers.openlibrary.org/b/id/3159149-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pratique homéopathique en psychopathologie, tome 2',75.10186778639489, 53, 'https://covers.openlibrary.org/b/id/3159357-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le Ménagier de Paris. Traité de morale et déconomie domestique composé',55.25666959301347, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aimants et pâte à sel',84.17767426994881, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Putain d usine',24.135884732089384, 96, 'https://covers.openlibrary.org/b/id/3160442-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guide pratique du Musulman',30.023502148495368, 2, 'https://covers.openlibrary.org/b/id/3160599-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La visualisation',11.32351776133429, 38, 'https://covers.openlibrary.org/b/id/3160750-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Devenir manager',9.183754701958673, 40, 'https://covers.openlibrary.org/b/id/3161086-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Quelque part dans les balkans',69.0613525615829, 40, 'https://covers.openlibrary.org/b/id/3161216-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le Crime de Kergroise',9.011188261921903, 8, 'https://covers.openlibrary.org/b/id/3161420-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Marcel Proust Du Cote de Cabourg',45.54978123250242, 3, 'https://covers.openlibrary.org/b/id/3162150-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Oeuvres',13.037806916748844, 55, 'https://covers.openlibrary.org/b/id/3162966-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Douleur et cancer',67.48139009784606, 100, 'https://covers.openlibrary.org/b/id/3163170-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Etre femme en Périgord au XIXème siecle',58.11596467950626, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('LA ROUTE MORTE',78.10608988516536, 90, 'https://covers.openlibrary.org/b/id/3163575-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le cuisinier landais precede de lettres a mon gendre et nouvelles lett',46.06355081740129, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sur la Route de la Nouvelle-France',11.670411559191042, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('World Competitiveness Yearbook 1999',75.34369406164068, 13, 'https://covers.openlibrary.org/b/id/3165027-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ganzheitliches Beckenbodentraining für Frauen aller Altersstufen',56.4746184024104, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Catch your Dream. Amerika, seine Menschen und ich',79.13922266561843, 20, 'https://covers.openlibrary.org/b/id/3165268-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Missa Solemnis. Mord auf dem Dorf. Roman',65.14662046522525, 3, 'https://covers.openlibrary.org/b/id/3165429-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Unsere Welt, Mensch und Raum, Große Ausgabe, Atlas für Sachsen-Anhalt',35.0690662140184, 26, 'https://covers.openlibrary.org/b/id/3166129-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lehrbuch der Chorleitung, 3 Bde., Bd.3',79.00267136264435, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Simone de Beauvoir',53.08237813842793, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Iwein',45.249056290859826, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Handelsgesetzbuch, Grosskommentar, 5',86.73599732992231, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Anonyme Kirchengeschichte',15.227487372768863, 58, 'https://covers.openlibrary.org/b/id/3167857-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Romische Erinnerungsraume Heiligenmemoria Und Kollektive Identitaten I',63.02243829538656, 2, 'https://covers.openlibrary.org/b/id/3168155-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Training, Lineare Algebra und Analytische Geometrie, Sekundarstufe II',93.18278228538739, 97, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Leporello, Allgemeine Ausgabe, neue Rechtschreibung, Übungsteil zur Fibel',54.31216522861088, 90, 'https://covers.openlibrary.org/b/id/3171998-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Geschichte der Philosophie IV in Text und Darstellung. Empirismus',44.15907488559239, 13, 'https://covers.openlibrary.org/b/id/3172883-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ökonomische Konsequenzen der Zuwanderung',41.360986848966334, 15, 'https://covers.openlibrary.org/b/id/5206523-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schönheit von Innen',82.19608707553571, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Autor, Werk Und Kritik',87.05559944368957, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Texte Von Heute',72.56434001926698, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Sprachführer, Brasilianisch',86.09005078734506, 36, 'https://covers.openlibrary.org/b/id/3174263-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tangram, neue Rechtschreibung, 4 Bde., Glossar Deutsch-Portugiesisch',73.12722144445547, 46, 'https://covers.openlibrary.org/b/id/5206877-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De la razón antropofágica y otros ensayos',84.28568847931498, 29, 'https://covers.openlibrary.org/b/id/5409693-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Erwin Gabriel Art - Photographer',54.02820841866199, 9, 'https://covers.openlibrary.org/b/id/3174807-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kinder fördern leicht gemacht. Richtig Reihen bilden, Bd. 2 Serialität',75.44935384800222, 33, 'https://covers.openlibrary.org/b/id/3175169-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Göttliche Klänge. Sinnen- und Seelenfreuden aus dem Klosterleben',90.01773060797896, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Engel. Faszination und Geheimnis',50.080862438872956, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Konstantin Leontiev (1831-1891)',5.098161210262836, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hat der Staat das Recht die Standesherrer zur Einkommensteuer herauzuziehen',8.41851646300788, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fische fangen. Mit dem Bodenblei. Sensible Spitzen und Futterkörbchen',86.28570210646969, 83, 'https://covers.openlibrary.org/b/id/3177629-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Deutsche Schäferhund. Hunderassen',64.1842029671296, 25, 'https://covers.openlibrary.org/b/id/3177774-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Blütenzauber aus Perlen und Draht',46.31889175344339, 90, 'https://covers.openlibrary.org/b/id/3179049-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das Geschäft mit dem Tod. Plädoyer für ein Sterben in Würde',9.46789448813458, 72, 'https://covers.openlibrary.org/b/id/3214637-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ehemanner Und Andere Irrtumer (Ullstein Taschenbucher)',76.1021492337245, 61, 'https://covers.openlibrary.org/b/id/3239439-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mord mit zarter Hand',3.0457305663057, 96, 'https://covers.openlibrary.org/b/id/3179866-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('BINGO logo, Rechtschreibspiele, neue Rechtschreibung, Neuausgabe, Bd.5',55.62314725890167, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Auf neuen Wegen lernen',59.07778583403167, 34, 'https://covers.openlibrary.org/b/id/3181630-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Por quê  Poesia',91.57140601197294, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schwarze Weisheit. Erfahrungen einer Europäerin in ihrem afrikanischen Dorf',82.64941758536216, 65, 'https://covers.openlibrary.org/b/id/3243231-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die moderne Reitschule. Harmonie im Sattel',31.21187780893014, 89, 'https://covers.openlibrary.org/b/id/3183554-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Management-Rechnungswesen',30.548827838344614, 74, 'https://covers.openlibrary.org/b/id/3275728-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Internet, Intranet, Extranet für Manager. Kosten, Nutzen, Anwendungsbereiche',52.29104974720711, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Weil wir gute Freunde sind',22.09123556080029, 74, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Besser lesen mit System',75.36304912651178, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gewinnen mit Aktien. Chancen für Einsteiger',72.31483817665632, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das etwas andere Rhetorik- Training oder  Frösche können nicht fliegen',1.5049188705547911, 26, 'https://covers.openlibrary.org/b/id/3187029-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Meyers Grosser Weltatlas',21.019944508179908, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('O freudenreicher Tag. Hundert Advents- und Weihnachtslieder aus alter Zeit',6.062532369477016, 70, 'https://covers.openlibrary.org/b/id/3188327-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fashion- Pen Motive im Trend',16.001715828912058, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Metall an historischen Gebäuden. Geschichte, Gestaltung, Restaurierung',47.062769883450464, 93, 'https://covers.openlibrary.org/b/id/3188811-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Anspruch auf Wohngeld. Ratgeber für Mieter und Eigentümer',24.15257348227665, 91, 'https://covers.openlibrary.org/b/id/3189236-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Im Wechsel der Gezeiten',98.2250977720334, 33, 'https://covers.openlibrary.org/b/id/3192780-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das Praxisbuch der Mentaltechniken. Übungen für ein positives Körper- ',56.36369615709272, 67, 'https://covers.openlibrary.org/b/id/3193327-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Materialbuch Fastenzeit, Ostern und Pfingsten. Für Gemeindearbeit, Lit',80.01853251543086, 69, 'https://covers.openlibrary.org/b/id/3257051-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ausgesorgt. Schneller unabhängig durch systematische Finanzplanung',73.15919400120124, 76, 'https://covers.openlibrary.org/b/id/3193926-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die neue Rente von A- Z',91.05710440537544, 74, 'https://covers.openlibrary.org/b/id/3196895-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Vom leichten Glück der einfachen Dinge. Kleine Freuden - große Wirkung',95.05249599016759, 68, 'https://covers.openlibrary.org/b/id/3200489-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schwerelos wie die Feder oder die Leichtigkeit des Seins',56.37547430132378, 65, 'https://covers.openlibrary.org/b/id/3200633-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hyperaktive und unruhige Kinder im Kindergarten. Hilfen für Erzieherinnen',27.22320789859225, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schillernde Wasserwelt mit Windowcolor',26.19167680081197, 60, 'https://covers.openlibrary.org/b/id/3251117-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Rosenturm',84.1772730878581, 61, 'https://covers.openlibrary.org/b/id/3202843-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Realitätsflucht in Entscheidungsprozessen. Vom Groupthink zum Entschei',19.271461018521332, 68, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Orgias',63.44952454861218, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die Thomasmesse',73.03125688862407, 18, 'https://covers.openlibrary.org/b/id/3226830-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Deutsch Konkret - Level 1',85.15803882658923, 11, 'https://covers.openlibrary.org/b/id/3209223-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Power Ja - Stress Nein. Fit, ausgeglichen und stark durchs Leben',44.291856198380486, 4, 'https://covers.openlibrary.org/b/id/3211888-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die optimale Rechtsform für Selbständige, Unternehmer und Existenzgründer',8.040856722081106, 70, 'https://covers.openlibrary.org/b/id/3212383-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tempus und Temporalität in geschriebenen und gesprochenen Texten',98.0059868667822, 10, 'https://covers.openlibrary.org/b/id/5207629-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hieroglyphen. Schreiben und Lesen wie die Pharaonen',3.0940458877551604, 83, 'https://covers.openlibrary.org/b/id/3212910-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aktuelle Themen der Abwassertechnik',88.21891973100237, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das Luxus - Fuhrwerk. Ein Handbuch für Equipagenbesitzer',65.06557231878877, 30, 'https://covers.openlibrary.org/b/id/5207850-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Harmonia',49.14035660816955, 1, 'https://covers.openlibrary.org/b/id/3214306-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ötzi - Der Gletschermann und seine Welt',62.394711981765646, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hüft- und Oberschenkelmuskulatur',21.082074055664307, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die Albertis',74.2018713028281, 20, 'https://covers.openlibrary.org/b/id/3217091-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('DTP druckreif. Professionell vom Bildschirm zum Print',9.145258924703446, 24, 'https://covers.openlibrary.org/b/id/3217467-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kreativ mit den ganz Kleinen. Kneten, malen, drucken, basteln ab zwei',19.00000446469615, 13, 'https://covers.openlibrary.org/b/id/3217584-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der internationale Trust als Instrument der Vermögensnachfolge',51.306160405141476, 38, 'https://covers.openlibrary.org/b/id/3218556-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Benjamin Blümchen findet einen Schatz',92.16170494801386, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Estranhos e assustados',16.314046548704773, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Boitempo & A falta que ama',21.605399712995297, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Computervalidierungin Labor Und Betrieb',30.175516874063288, 94, 'https://covers.openlibrary.org/b/id/3224369-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Finite Element Modelling Flow Porous Med',48.248941238678945, 36, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Vom Akademiker Zum Verkaufsprofi',68.34872291858174, 42, 'https://covers.openlibrary.org/b/id/3225222-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Inverse Problems (Advanced Lectures in Mathematics Series)',87.64112236195268, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schleswig- Holstein Quiz op Platt',76.11594116151035, 4, 'https://covers.openlibrary.org/b/id/3226191-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Caap86',82.0054168906927, 14, 'https://covers.openlibrary.org/b/id/3227654-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pieces from the Makculloch and the Gray Mss. together with the Chepman',41.28005480128542, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanguk chiyok sahoe pokchiron',47.252593207251174, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yoksa ka uri rul purugo itta',73.86306910903797, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Master of Manipulation',37.318213808928796, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanguk kajok chiryo kaeballon',61.18805332394834, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Omoni',4.094975978875949, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Saengmyong',28.25494744552054, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanguk Togyo munhaksa',11.361767364188088, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tagukchok kiop kyongyongnon (Kukche kyongyong chongso)',19.057273162351635, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Koryo milgyo sasangsa yongu (Pulgwang purhak chongso)',4.638358914968532, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Munhak kwa sarang',22.107610934530634, 73, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chosonosa yongu nonmunjip (Haeoe uri omunhak yongu chongso)',25.109513130475296, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanguk modonijum siin yongu',80.54059756019271, 2, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanguk hyondae chongchisa ui ihae',50.10327002243667, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Taekwondo',32.00314077555037, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kundae sosol ui teksutu konggan haesok',12.026994731125985, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tongnip undong yujokchi mungyollok',60.05349254759108, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Liquen',92.13480869083631, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Minju pyolgok',78.28178705571375, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chontong munhwa ui ihae',46.32972484591907, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Simin sahoe chegye punsok (Chongchihak chongso)',68.52717733697833, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Evangelio para el fin de los tiempos',70.26047554088018, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hoesang kwa supilson',22.466082389217483, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Chronicle of Manchwidang',88.61416478520987, 28, 'https://covers.openlibrary.org/b/id/3337719-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yun Tong-ju wa Hanguk munhak',80.00837828024238, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kkot kkokko san noko',56.78455421312131, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ilbanin ul wihan ihon sosong kwa chaesan punhal saenghwal pomnyul ui k',64.16371798928695, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Letters in the British Museum',49.109204211595774, 95, 'https://covers.openlibrary.org/b/id/5504701-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Narrative of the Anabaptist Madness',80.04687837223774, 20, 'https://covers.openlibrary.org/b/id/3338200-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Tragicall Historye of Romeus and Juliet',24.59775575393972, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Grote Godsdiensten Originally "Great Religions of the World" into Germ',79.2394283951806, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Product Quality',58.08131024391668, 99, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Soil Mechanics 15th Intl 4v',17.14622746622921, 10, 'https://covers.openlibrary.org/b/id/3338561-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Godfrey of Fontaines Abridgement of Boethius the Danes "Modi Significa',75.01168672319874, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Acid Rain and International Law',75.10666449128364, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ondergesneeuwde sporen',58.76912049614176, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Behaviour of Reinforced Concrete Continuous Deep Beams',35.17245775323745, 29, 'https://covers.openlibrary.org/b/id/3338781-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mandating Identity',95.05031737075235, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Reecriture des mythes',86.27909741448114, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Grazer Philosophische Studien 64',3.560009578898261, 56, 'https://covers.openlibrary.org/b/id/5212201-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Historia regis Sarsa Dengel (Malak Sagad). Accedit historia gentis Gal',7.247941959996176, 13, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La notion biblique de Dieu. Le Dieu de la Bible et le Dieu des philosophes',88.07246722092151, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('In spirit and truth',2.009261344257231, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Het Coolsingelziekenhuis Te Rotterdam (1839-1900). De ontwikkeling van',48.08212928521086, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Staging A Cultural Paradigm',74.25443150751578, 19, 'https://covers.openlibrary.org/b/id/5213764-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Highway Capacity & Level Service',28.125752648477373, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Steel Structures Eurosteel 95',93.14942822322288, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Financial Cryptography',54.1273395072867, 85, 'https://covers.openlibrary.org/b/id/3231685-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sc, Y, La-Lu',93.47569469050046, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jonas Vertrauen',20.070151789204175, 54, 'https://covers.openlibrary.org/b/id/3232887-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die andere Seite der Nacht. Laster, Lust und liederliche Schriften',76.07301404436387, 98, 'https://covers.openlibrary.org/b/id/3233038-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Altersvorsorge leicht gemacht',22.590802474208495, 73, 'https://covers.openlibrary.org/b/id/3233931-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('My Memories of You',10.546508199741979, 47, 'https://covers.openlibrary.org/b/id/3259798-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sex Dreams. Erotische Träume und ihre Deutung',88.37849172626457, 100, 'https://covers.openlibrary.org/b/id/3268361-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Katzentagebuch. Das aufregende Leben mit meinem kleinen Tiger',55.793852418899164, 2, 'https://covers.openlibrary.org/b/id/3236832-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fachstufen Bau, Tiefbau, Technisches Zeichnen',10.803063161147007, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schrader Motor-Chronik, Bd.59, MZ, IFA, Simson, AWO, EMW u. a',9.020957454714848, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Innovative Unternehmens-kommunikation Im Zeitalter Von Internet Und Ebusiness',58.774992026591256, 28, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Erwerb Eigener Aktien',98.03106880058431, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Agypten - Israels Herkunft Und Geschick',65.03528768287586, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das Scheidungsverhalten Turkischer Migrantinnen Der Zweiten Generation',31.860000707417136, 58, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Europaische Haftbefehl',2.2478518787336825, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Moderation Und Steuerung Der Netzbasierten Wissenskommunikation',91.06384605988252, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mudras. Gesund und ausgeglichen durch Finger- Yoga',14.135405117944797, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Auf den Bergen des Kaukasus. Gespräch zweier Einsiedler über das Jesus- Gebet',41.25759038792586, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dominación y desigualdad',0.23012596228662058, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('O presumi�?vel coração da Ame�?rica',40.00755133776224, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Problems in Prawn Culture',60.85199191879334, 72, 'https://covers.openlibrary.org/b/id/3340848-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Functional Recovery After Stroke',40.75144324155579, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('J.W. Wenham - Inleiding tot het Grieks van het Nieuwe Testament',61.15688634244455, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De sportzaak, van functioneel tot modisch',66.2931775820513, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Door allen voor allen, een heerlijk streven!',34.27835973599394, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Arbeidsorganisatie en arbeidsverhoudingen in beweging',52.00114680888431, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Large Forest Fires',16.286708058119245, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ann Huybens, Patrick THooft',73.57639702709699, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Search',60.292314186299215, 92, 'https://covers.openlibrary.org/b/id/3341612-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Profitability Financing and Growth of the Firm',36.00060471431539, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Swedish History in Outline',58.24879576169544, 49, 'https://covers.openlibrary.org/b/id/5357866-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rape & Religion in English Renaissance Literature',99.74483718730286, 43, 'https://covers.openlibrary.org/b/id/3341955-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Learning-In-Context',1.087099793968722, 5, 'https://covers.openlibrary.org/b/id/3342120-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Medieval Manner of Dress',13.11185440741555, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Economic Development of Burma',63.176318552402975, 1, 'https://covers.openlibrary.org/b/id/3342239-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The "New Negro" in the Old World',86.45586092772452, 40, 'https://covers.openlibrary.org/b/id/3342382-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Poetics (Salzburg Studies: Poetic Drama and Poetic Theory)',11.434693389343211, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die neuen Heiligen der katholischen Kirche, Bd.4, Von Papst Johannes P',9.185271274617296, 46, 'https://covers.openlibrary.org/b/id/3242943-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Estorvo',47.17732216172638, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Info- Guide USA. Das Handbuch zur Urlaubsplanung',87.09366221326333, 56, 'https://covers.openlibrary.org/b/id/3243562-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Second Solar Spectrum',57.004643342369555, 4, 'https://covers.openlibrary.org/b/id/3243938-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Paris',77.3778984061598, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Letter to Jesse W.M.DuMond on momentum and energy balance in the wave ',88.01962493438765, 20, 'https://covers.openlibrary.org/b/id/5983442-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xanam, e outras histo�?rias',68.06448232763901, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Praxisbuch Frauenarbeit, Bd.3, Engel, Frauenverwöhnabend, Agape - Lieb',89.17752774681992, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Landespersonalvertretungsgesetz Nordrhein- Westfalen',13.265152343541251, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Plant Geography upon a Physiological Basis',76.06964024173953, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Skippertraining. Planen, Führen und Entscheiden',13.162321967148614, 72, 'https://covers.openlibrary.org/b/id/3248916-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Durch den Wind. Lebenstraum mit Handicap - Ein Segelsommer',7.022040029300638, 7, 'https://covers.openlibrary.org/b/id/3248935-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Objektivität',12.334919437113777, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dreamweaver MX. Das Praxisbuch',33.42933053712307, 78, 'https://covers.openlibrary.org/b/id/3250709-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schnell und effektvoll. Seidenmalen leichtgemacht. Mit neuen Gestaltun',56.43839039835826, 76, 'https://covers.openlibrary.org/b/id/3250926-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Frühling, Sommer, Herbst und Winter. Spiele und Bastelideen für Kinder',97.00421915080572, 6, 'https://covers.openlibrary.org/b/id/3257167-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Geldgeschenke',24.02704897381607, 57, 'https://covers.openlibrary.org/b/id/3251216-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Der Bildungsgutschein. Finanzierungsverfahren für ein freies Bildungswesen',45.51245605922271, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Calendula. Eine Heilpflanze spiegelt das Licht',5.023026631466581, 86, 'https://covers.openlibrary.org/b/id/3251656-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zur Umwelt des Alten Testaments',56.0829833535075, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Von Schlesien westwärts. Erinnerungen',80.01046474717009, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mit Enkeln ist Familie doppelt schön. Ein Buch für Großeltern',19.115141728506515, 73, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mathematikunterricht in der Grundschule',29.615817163478916, 50, 'https://covers.openlibrary.org/b/id/3254642-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Taschenbücher für Geld, Bank und Börse, Bd.43, Die Kreditversicherung',19.227520025220358, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Neue Liebe, neues Leben. CD. Frühling in Musik und Poesie',29.095686826779026, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sozialpädagogik - Ein Lehrbuch',92.17744856302271, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Bocage, o perfil perdido',93.06880016665545, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Encyclopaedia of fungi',34.1525395480408, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Elimination of Rubella and Congenital Rubella Syndrome',46.55448623939863, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Spatial data sets for environmental assessment',76.20460495136314, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Anderungen in Lebens und Arbeitsformen als Folge der technischen Entwicklung',36.53060036751722, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Testing of High-level Waste Forms Under Repository Conditions',98.38184830304162, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Menschenführung für Manager Das erfolgreiche Führungskonzept',51.38080542687404, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ökumene und Kirchenrecht - Bausteine oder Stolpersteine',78.67800858082211, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mein Urgroßvater und ich',86.7394805058807, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ich habe Skoliose. Ein Ratgeber für Betroffene, Angehörige und Therapeuten',55.19513943876583, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Effective and Efficient Organisations',59.053225505945846, 1, 'https://covers.openlibrary.org/b/id/3258822-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Schlüsselqualifikationen. Persönliche Voraussetzungen für beruflichen Erfolg',11.017886880111348, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nutcracker Suite, Op. 71a',31.12485438503009, 46, 'https://covers.openlibrary.org/b/id/5225874-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Symphony in F-Sharp, Op. 40',73.02194798741462, 82, 'https://covers.openlibrary.org/b/id/5226078-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Alternative Nutzpflanzen',14.681825472903625, 73, 'https://covers.openlibrary.org/b/id/3262074-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sudetenland in 144 Bildern',50.22122233437745, 65, 'https://covers.openlibrary.org/b/id/3263000-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Regelung Elektrischer Antriebe. Innovation durch Intelligenz',5.126079560915448, 97, 'https://covers.openlibrary.org/b/id/3263471-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Electronic Control Engineering Made Easy',96.56887168454745, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Krisenintervention',39.09969102786361, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los muertos y sus sombras',62.74278378822638, 48, 'https://covers.openlibrary.org/b/id/5241285-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ernst May',31.043173761557064, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diavoli',36.004730728921054, 8, 'https://covers.openlibrary.org/b/id/5531017-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Thai- Wok. Combination = Variation = Culmination',50.49255682281488, 35, 'https://covers.openlibrary.org/b/id/3265735-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Milk Intolerances and Rejection',23.13404670665873, 61, 'https://covers.openlibrary.org/b/id/5226799-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Neurophysiological Correlates of Mental Disorders (Advances in Biologi',44.54757652817081, 37, 'https://covers.openlibrary.org/b/id/5226499-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Alcohol Metabolism and Alcoholism',54.32487818020096, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Effectiveness and performance',60.57200073237337, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Apheresis',20.222421623208067, 21, 'https://covers.openlibrary.org/b/id/3266896-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('PENN Neurodegenerative Disease Research',81.48953766664103, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('On the edge of survival',51.10116928190446, 56, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Everything Was Beautiful and Nothing Hurt',17.112785514083722, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo ren kou shi',48.085916402014895, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Agricultural Output and Input Pricing',48.21146946466875, 11, 'https://covers.openlibrary.org/b/id/5227101-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die Aufgabe des Staates und der Kirche bezüglich des Religionsunterric',73.4805250516512, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Homenaje Al Maestro',76.18954437298812, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Oveja de Mi Sueter',83.09373379033254, 16, 'https://covers.openlibrary.org/b/id/5230655-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tamara (Bailarinas / Ballerinas)',32.146108393038084, 6, 'https://covers.openlibrary.org/b/id/5230247-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pandita Juega/little Panda Plays (Chiquitos)',94.12284003734916, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Democracia y El Mercado',37.87995938243492, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Organizacion Nacional',33.5213527391251, 29, 'https://covers.openlibrary.org/b/id/3346295-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manual del Martillero Publico y del Corredor',67.28865351247617, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Siete Claves Para Vivir En Calma',42.043699043792685, 62, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tecnologias de La Informacion y Las Comunicaciones',10.236620566616201, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sociedades a Traves del Tiempo 8b0 y 9b0 - 3b',19.41736204100589, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sintesis Grafologica',76.27289739880177, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ciencia hindu yogi de la respiracion',71.04694271990188, 35, 'https://covers.openlibrary.org/b/id/3346493-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Arbitraje',4.003919579998379, 88, 'https://covers.openlibrary.org/b/id/3349451-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Geografia General y de Asia y de Africa',84.97224103706164, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Limit distributions for sums of independent random variables',24.289586010609817, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Psicoanalisis, Proyecto y Elucidacion',21.190881538689784, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manejo de Rodeo de Cria',69.19290919394078, 74, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Modelado - Chicos Creativos',18.092521628738815, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Novedosas Artesanias',94.11960457915944, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tesoros de La Pintura Decorativa',81.10423316035366, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Reciclando Materiales',9.051458327558837, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Erdbeeren. Die besten Rezepte',53.01435401605056, 48, 'https://covers.openlibrary.org/b/id/3268926-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('WEGWEISER DURCH DEN WIRTSCHAFTSTEIL DER TAGESZEITUNG',4.02395882818577, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das Tagebuch der Weißen Hexe Theresia',67.11624305936758, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Markenlizenzverträge',56.1901639815048, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Stadtplan Sachsenheim',68.68221805540449, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ozonanwendung in der Wasseraufbereitung',20.070613525494455, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Selbst Solaranlagen installieren',58.24519762292974, 58, 'https://covers.openlibrary.org/b/id/3272568-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Compact Schülerhilfen, Mathematik, Textaufgaben, 3. Klasse',36.27072521569033, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('LImpossible Social Selon Moliere (Biblio 17,)',83.07369392664246, 83, 'https://covers.openlibrary.org/b/id/5231844-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Redistributionslogistik',77.08281322897805, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Die Bewertung von DM- Zinsswaps. Zinsdifferenzen zwischen DM- Swaps un',48.63974102531982, 96, 'https://covers.openlibrary.org/b/id/3275341-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qualität von Entscheidungsprozessen der Geschäftsleitung. Eine empiris',41.0516510469611, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Für besinnliche Festtage',5.405063957871542, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kognitive, emotionale und soziale Aspekte menschlicher Problembewältig',89.83949791146571, 38, 'https://covers.openlibrary.org/b/id/3276638-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qing ju ni xin',71.34199091034642, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nemecko a staty Beneluxu, automapa 1:1 500 000',32.103504942519265, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Real Men (2003)',42.21567910315231, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wirtschaftspartner Litauen',67.11986763310264, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Johanna Fahmels Monolog',42.80225416052391, 97, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sprechen, Horen, Sprechen - Level 10: Pack',81.13581489866222, 26, 'https://covers.openlibrary.org/b/id/3280514-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('3 Days X Frankfurt City Guide',24.04822897118081, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Petra Kroll Keramik-Skulpturen',86.13396295059603, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Medicina Legal - 2 Tomos',98.84381640726734, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Historia de La Filosofia VI - La Filosofia',13.176943859900277, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Juegos Para Campamentos / Camping Games (Juegos Y Dynamicas / Games an',83.14258838054658, 67, 'https://covers.openlibrary.org/b/id/5233125-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Etica Para Los Que No Son Heroes',74.20391080033535, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Timoteo Escondio Los Colores',55.02943062273841, 14, 'https://covers.openlibrary.org/b/id/3347187-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Las Organizaciones Neuroticas',88.20817748012755, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Con Palabras 1',96.02971799606448, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Introduccion a Una Clinica Diferencial',9.046605458279092, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Calidad y Productividad Total',36.01665136310801, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Trabajo Social Familiar',75.20702957123359, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nutricion y DePorte',49.253572072485525, 24, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Privatizaciones - Mitos y Realidades',11.104154345453184, 65, 'https://covers.openlibrary.org/b/id/5234301-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Naturaleza Dia a Dia',48.19150090902868, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manual del Hincha',76.72873711039833, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('WordStar 5.0 Avanzado',10.594148373171478, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mateo De Paseo Por El Museo Thyssen',15.135363109475126, 79, 'https://covers.openlibrary.org/b/id/3332654-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cava y excava (Vehiculos)',98.44279543684618, 14, 'https://covers.openlibrary.org/b/id/5253586-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sepa como cortar el cabello a ninos / Know how to cut childrens hair :',98.34612077624428, 22, 'https://covers.openlibrary.org/b/id/3349007-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sandro, El Idolo Que Volvio de La Muerte',19.193250676337726, 39, 'https://covers.openlibrary.org/b/id/3349592-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mistica Sufi Del Siglo Vill Dichos Y Poemas',90.52263391447322, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Simyen',42.73434631013875, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Ultimo Faraon',49.06106089819822, 97, 'https://covers.openlibrary.org/b/id/3327377-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aprendiendo a Aprender',30.022977533736746, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Psicocardiologia Abordaje Psicologico Al Paciente',53.458698629308365, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diccionario Ilustrado de Computacion',59.81912352705098, 56, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sui shi yi wen (Zhongguo xiao shuo shi liao cong shu)',39.044771393641554, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ai he heng liu (Wan xiang cong shu)',36.75188151246836, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xi qu (Zhongguo gu dai wen ti cong shu)',46.25571103142787, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Beijing lu you tu ji',30.007482169800753, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hua tuo gou zao yan jiu',54.05427422754236, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Huang Jiqing shi you di zhi zhu zuo xuan ji',50.1250308202182, 62, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Buried Treasure',81.77619707156583, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Han dai xue shu shi lue (Min guo xue shu jing dian wen ku)',74.39634784523687, 13, 'https://covers.openlibrary.org/b/id/5238008-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cai Yuanpei shi xue lun ji',18.089230559753098, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Huaxia yin shi wen hua (Wen shi zhi shi wen ku)',47.12276206735992, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Deguo di Han xue yan jiu (Wen shi zhi shi wen ku)',85.08034139334566, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qi Baishi hua ji',85.00019704000293, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sui Yifu hua ji',71.41561744052514, 13, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dang dai xi qu zuo jia lun',81.11915560233228, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo xue sheng di guang rong li cheng',96.37799081529235, 50, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ji xia xue yan jiu',60.33036198751312, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo nong ye di gai ge yu fa zhan',23.395252786396426, 50, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo mu gou jian zhu ying zao ji shu (Zhongguo gu jian zhu zhi shi cong shu)',92.03530304719939, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Si ming xin fa (Zhong yi gu ji zheng li cong shu)',22.007064910190465, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('One Hundred Recipes of Chinese Food',88.06852125221432, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chen Geng da jiang jun =',54.0172698782418, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Herders, Warriors, and Traders',35.05320235885014, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jing ji fa zhan zhong de zhong yang yu di fang guan xi',99.49796019344146, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qian dao ni di shou (Da xue sheng xian shi wen ti cong shu)',50.610353135522885, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mao Zedong he ta di peng you men (Mao Zedong di shi jie cong shu)',32.06083924147295, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yao zu chuan tong wen hua bian qian lun',24.379090982616468, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xiang hun nü',78.47966027893246, 66, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jing shen wen ming yu she hui zhu yi',54.73106412856118, 25, 'https://covers.openlibrary.org/b/id/5235939-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dong lei',87.4310470300086, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Si wei fang shi yu si xiang zheng zhi gong zuo ("Si xiang zheng zhi go',23.196622944153656, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Han yu da ci dian shi bu',25.139218005855618, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Long Yun chu shan (Yunnan li shi xiao shuo)',79.53509219479008, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Luo Yuming Lao Zhuang sui tan',55.22893920344209, 23, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xian dai min zu zhu yi yun dong shi',48.314371932338695, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wo men zai zhan huo zhong cheng zhang',53.17625289523218, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dunhuang Xi Han Jinshanguo shi',2.0375267926814535, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tufan shi (Xi bei li shi cong shu)',81.03014264924224, 96, 'https://covers.openlibrary.org/b/id/5236206-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xinjiang min zu yu yan wen zi gong zuo si shi nian =',74.20652696985671, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qiu suo',18.05968996513145, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pi pan Yu Dan',37.18385273585943, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The crows and other plays',4.096448244846194, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo gu yu pei shi jian jian ding',27.167448048109648, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('She hui tong ji xue',59.06157155133115, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jin se de sheng shan',2.056618719389549, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kangxi ping zhuan (Zhongguo si xiang jia ping zhuan cong shu)',26.199880242192624, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Human dignity in the learning environment',84.44793525771097, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aquaculture in fresh waters',98.75036510125781, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Norjan oljytoimiala suomalaisen pk-teollisuuden kohdeasiakkaana (Kaupp',42.25509799427538, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ding Ling zai gu xiang',26.123587805849397, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Bao Zheng yan jiu',34.04362280373818, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Da xue sheng cheng cai xin li xue',31.005771774851365, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhong Nan Hai ren wu chun qiu',79.62625494969183, 19, 'https://covers.openlibrary.org/b/id/5237220-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yu de zhe xue',88.15727372765161, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fan si yu chao yue',26.35090884890638, 93, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dong dang di xiao fei jie gou ("Jing ji xue zhe dui she hui di jing ga',30.54675126553094, 41, 'https://covers.openlibrary.org/b/id/5243206-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ri yue zhi lian (Min su sui bi cong shu)',93.31265767950644, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Han dai yue wu bai xi yi shu yan jiu',11.020435356214202, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jiujiang chu tu tong jing',73.24064814882185, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhan zheng xin lun',78.44190777350545, 31, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qian gu nan nü',14.202227955525977, 96, 'https://covers.openlibrary.org/b/id/5474756-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gulang shi jie',4.028351282183262, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Broadcasting and society',89.01931920975203, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gan ge, yu bo',92.09063362067396, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Socie�?te�?s islamiques de placement de fonds et "ouverture e�?conomique"',19.08990691317313, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guo ji si fa lun',72.00870783200911, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sha Kefu shi wen xuan (Xin wen hua shi liao cong shu)',85.19426484199654, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('San bai liu shi hang dui lian xuan zhu',14.495940213702104, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tang chu jian yi da chen: Wei Zheng',42.2582660265622, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xin shi qi wen xue mian mian guan (Dang dai zhong xue sheng cong shu)',10.49360406716136, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ming Qing shi tai ren qing xiao shuo shi gao',58.13336535522476, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hongling (Du te wen cong)',2.1008478541386855, 69, 'https://covers.openlibrary.org/b/id/5238208-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Osmanlilik/Bizans (Kemal Tahir Vakfi yayinlari)',51.050597192849814, 30, 'https://covers.openlibrary.org/b/id/4929770-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Niu zai nu',71.33474907069115, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dang dai Zhongguo nong cun wei guan jing ji zu zhi xing shi yan jiu',79.75907402069777, 74, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wen ming di li cheng',68.23775610685553, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kao gu bian',69.53295137405875, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sui shi guang ji (Shan chuan feng qing cong shu)',22.125344074404282, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nalan ci jian zhu (Zhongguo gu dian wen xue cong shu)',35.35847603055499, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('"Jin Ping Mei ci hua" he Ming dai kou yu ci hui yu fa yan jiu',17.064717019806828, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ye de qu xian',59.055571063191785, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Shou chan shi tian shu',27.169787954926985, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hunan zhi wu ming lu',32.065451782038814, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chuang wai hong mei gui',92.40659481042613, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jin Ping Mei shi ci wen hua jian xi',86.01551757207638, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhuang yu fang yan gai lun =',44.54587657537875, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Du gu zhi nan',8.459464416367654, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xiao xiang di yin fu',71.26908790055188, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chuang zao xue yuan li',34.11911629330066, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Menggu zu wen hua shi =',87.00770039825296, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Te bie ti kuan quan',13.030943488886754, 70, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhuangzi si wei mo shi xin lun (Huaxia si wei yan jiu xi lie)',53.38414721379812, 29, 'https://covers.openlibrary.org/b/id/5244076-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhang Boling jiao yu si xiang yan jiu (Zhongguo jin xian dai jiao yu j',72.78234412424237, 97, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Short History of Chile',2.0823109183168182, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chile',11.081643658155265, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('SELKNAM',2.373258238522661, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jiao an',79.07184853603734, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Feng su tan you (Zhongguo min jian wen hua tan you cong shu)',88.30492274971846, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xin ling feng ge (Jiu ge wen ku)',38.17740929959727, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Liao zhai di huan huan zhen zhen (Gu dian xiao shuo xuan)',31.089377582040814, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dan shen gui zu (Huang guan cong shu)',78.17132041306598, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Literature, Politics and the Intellecturals (Wen xue, zheng zhi, zhi s',13.020099090681967, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xiao xiong de qing fu',96.47249829556618, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Taiwan wen hua yu li shi di chong gou',53.24769004645969, 93, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo gu dai yi guan ci dian (Shu xiang jing dian)',52.24189655410166, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diet and Nutrition in Oral Health',83.16226743622221, 20, 'https://covers.openlibrary.org/b/id/1102657-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Min fa wu quan pian',45.69094613837001, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ji ling shu zhai jing si yu lu (Li yi pin)',15.769341162987196, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tui che di yi xiang ren ("You qing xi lie")',67.39827781675396, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gao bie hong huang',94.01365215161826, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Como Escoger El Personal Adecuado - Bolsillo',65.10256390173097, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Antonio Narino',44.01748860315114, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Catalina II La gran leyenda de Rusia (100 Personajes) (100 Personajes)',29.012994857805555, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Matematicas Financieras',25.2171773103413, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Agitado Corazon Adolescente/the Excited Heart of an Aolescent',60.14220078998646, 24, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Parlamentarische Grössen',35.40519604894955, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Conservacion Preventiva En Museos',69.00696477403756, 26, 'https://covers.openlibrary.org/b/id/3351528-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Evocacion de Azorin (Literatura / Grupo Editorial Norma)',11.00929726716359, 2, 'https://covers.openlibrary.org/b/id/5240897-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tiempo Hermoso',58.61856046271105, 70, 'https://covers.openlibrary.org/b/id/5241560-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Han Ying xu ci ju shi',95.09908993851354, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Shui lai jing li Xianggang',69.00768256745833, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xianggang Zhong wen bao zhi zuo zhi yun zuo nei rong =',11.343561955132134, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jin jin you wei',38.025556294964375, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Deng Xiaoping wai jiao sheng ya',17.471492325446683, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Balaton-felvidek foldtani terkepe: 1:50 000',3.418499707146625, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wu yan shang di yi shu',99.05230272217152, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nie Ou =',27.230041262390735, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yin yun xue gai yao',22.56400998271747, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lian zheng fa zhi lun',7.197202666898708, 58, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xiang zhen qi ye jing ji fa gui zhi nan',70.22985588600484, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Li shi shi qi Su bei ping yuan di li xi tong yan jiu',36.89506554208034, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Telephone Chinese',56.10904685739955, 44, 'https://covers.openlibrary.org/b/id/3321602-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lu shi shi wu yu fa lu wen shu juan (Fa lu fu wu bi bei cong shu)',28.34977429225619, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yin shua qi ye jing ji huo dong fen xi',81.024953583579, 66, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhonghua dui lian jian shang',94.44068103302438, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhongguo nong ye sheng tai gong cheng de li lun yu shi jian',14.113661354808153, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chao Kao',54.022939386291704, 31, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhejiang sheng tu di li yong xian zhuang tu',47.2360846529521, 28, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Di yi feng liu',70.21899270388656, 31, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pai hui yu jue qi',79.16453576642829, 52, 'https://covers.openlibrary.org/b/id/5243946-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Song dai nong ye di li',24.703207573579874, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jiu yun ji',76.07741937425051, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qian zi wen tong shi',79.19130341895324, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zibo shi jiao tong lu you tu',35.12215309408436, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Bi xue jiang nan',72.04999344447178, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tang shi san bai shou bu zhu',9.00076434159648, 81, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Laozi xin jie',69.63159528443677, 21, 'https://covers.openlibrary.org/b/id/5244292-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jin dai qi meng si xiang yu jin dai hua',78.26841059904213, 74, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dar ghurbat',82.19227845098726, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zamzamah-i zindagi',40.41875655224705, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Farhang-i khas-i ulum-i siyasi',95.18171943440343, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Encyclopedia of Persian Poets, Vol 1',55.022207889373504, 71, 'https://covers.openlibrary.org/b/id/3353091-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aql dar Masnavi (Bahr-i manavi)',53.00836197904405, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('ha-Gamadim ha-aharonim be-Givatayim (Reshit keriah le-korim mathilim)',67.02234368775767, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yaldah ahuvah (Sifriyah la-am)',55.60890183976406, 24, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kol ha-anashim she-Hu',51.35061254644082, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Segurah le-regel shiputsim',61.10687202736156, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lanu ha-magal hu herev',8.620222875001211, 36, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ḥevron',81.38764034891621, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mafteaḥ maʼamarim, 745',64.07236781632231, 24, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Eshkol shel humor',86.11955243502378, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mishpat, alilah, parashah',80.22110488813526, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Liviyah ahuvati',25.51725773192628, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mavo le-sefer Halakhot pesukot',98.08946205339072, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Science, Pseudo-Science, And Moral Values',32.132145943911674, 98, 'https://covers.openlibrary.org/b/id/3353308-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Superechnosti Reform',47.124749197707075, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hua ren wen hua zong heng tan',18.420866749274232, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lenguaje de La Inmortalidad, El. Pompas Funebres',88.45377535751186, 36, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Soy Importante',29.107769804043087, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aditivos Para Material Plastico',64.0535291710068, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Como Acercarse A La Quimica',17.43072967704847, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Historia de La Filosofia - La Filosofia Griega Volumen 2',11.284809528721333, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Color De La Tierra/ The Color of the Earth',77.22051189995877, 25, 'https://covers.openlibrary.org/b/id/5247279-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mas Alla Del Alambre y la Migra',4.462998136678883, 40, 'https://covers.openlibrary.org/b/id/5247763-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los Poetas (Clasicos Auriga)',17.12201944433251, 44, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Griegos y Romanos',57.123619534697944, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Papel Mache (Paso a Paso)',37.50866643329612, 76, 'https://covers.openlibrary.org/b/id/3354113-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Türk millı̂ kültüründe Nevruz',31.556928789516558, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dras Tonaltin',96.09862949921616, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lo Mejor de la Superación Personal ( The Best of Personal Advancement',60.088391415359595, 33, 'https://covers.openlibrary.org/b/id/3354392-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mexico, Genio Que Perdura',74.46411215735804, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Juego y Aprendizaje Escolar',45.4856777912244, 10, 'https://covers.openlibrary.org/b/id/5248850-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Excel Para Windows 95 Paso (Hi',47.44946530969915, 70, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Geological map of the Czech Republic (superficial deposits omitted): G',84.25420744295113, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Avimarakam',52.62084205172357, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Best Bet',4.395373905370742, 78, 'https://covers.openlibrary.org/b/id/3322101-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Metsamōr',18.72991333330146, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Investment Management Security ; Analysis and Portfolio Management',98.23859772956352, 56, 'https://covers.openlibrary.org/b/id/5249730-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Strength to Materials',87.00249701361419, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Concise Textbook, Quick Medical Text Review - Vol. 4',35.50781003986188, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Botlakhō̜n dưkdamban rư̄ang Rāmmakīan chut "Kon Sukhāčhān"',19.401796549256385, 28, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Textbook of Radiology and Imaging',5.195784469648649, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sports Education',39.18380105536582, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Administrative Organisations',56.41339383261366, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Encyclopaedia of Non Formal Education',35.8846571755062, 57, 'https://covers.openlibrary.org/b/id/3322567-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Poverty Alleviation Through Self Employment',65.0336047833894, 49, 'https://covers.openlibrary.org/b/id/5250288-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Introduction to Educational Psychology, AP',97.66444809904223, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Dying Banyan',6.720606862336391, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pancastikaya-sara',34.05856166475132, 70, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Crusade and End of Indira Raj',76.14319916698265, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Essentials of Postgraduate Medicine',64.06857450598942, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('WMD Terrorism',97.22227705859517, 51, 'https://covers.openlibrary.org/b/id/3323091-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Comprehensive Eco-botanical Survey of the Monocotyledons, Part V',13.038265669763122, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sweet and Sour Soup for the Executives',51.07570364299526, 28, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Babbar Akail Movement',91.22734406467073, 36, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Modern Dictionary ; Cyto-and Histochemistry',1.5359849220986692, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Purchasing and Materials Management',78.12039673544034, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Environmental Ecology',99.17590717072554, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Paul Scott',23.54270663710335, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rural Growth centres for Micro Level Planning',5.035389322680828, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('How to Use a Dictionary',30.15058868399038, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dutt on Contract',86.1360137674808, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('An Insight into World Religions',32.105582134523495, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Alcohol Abuse',3.0014539179452897, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Christian God',50.01293501851181, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Paul Examined',8.225289572258575, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Superconductivity',87.10919560612366, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Digital Technology in Education',69.47348122289159, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Numbers (My Pretty Board Book)',39.000584085541995, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Phraratchabanyat Charachon Thang Bok =',32.02597583025992, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Science',99.1307780255207, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Punjab History Conference, Thirty-fourth Session, March 15-17, 2002 ; ',60.56760210246086, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Education and Techniques of Teaching',99.54320205716076, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Teaching of Physical Sciences',9.504740714817897, 51, 'https://covers.openlibrary.org/b/id/5251927-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Indian Music and Swati Tirunal',40.75337556077534, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Infectious Funghi',52.047741380644474, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guide to Electricity Laws in India',22.124799439430983, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Principles and Practice of Cost Accounting',81.1506573534512, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Total Quality Management',43.39083924286781, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Bapsi Sidhwa',27.287967347815105, 17, 'https://covers.openlibrary.org/b/id/5255636-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Contabilidad Superior',8.154538039057789, 7, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('ONDAS MÉDIAS -Ver.-Obras Completas de Vitorino Nemésio, Vol.XIV - Ondas Médias',57.71364873133546, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The grid',49.568783741597976, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Thaqafat hadha al-asr',30.17351017731925, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Muallafat Abd Allah al-Tukhi',93.50502189304467, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Siyasat Misr fi al-Bahr al-Ahmar fi al-nisf al-awwal min al-qarn al-ta',65.22500874144679, 13, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Buhuth wa-bahithun',60.92840900755424, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Muwajahah wa-al-salam fi al-Sharq al-Awsat',31.316412196123093, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Misr wa-Filastin (Dirasat fi al-ilam)',51.16627662309114, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Dalalah wa-al-kalam',74.11219442908808, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Irhab',26.13535316464038, 7, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ibadat al-Ahram',38.10551862142757, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Khul wa-ahkamuhu fi al-shariah al-Islamiyah',87.12574143573838, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ammunah tukhawi al-jan',36.478218054320806, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Riyah al-inshitar',47.0321783860344, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Last Station',54.081920392907875, 99, 'https://covers.openlibrary.org/b/id/3356888-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Sirr al-mustaban (Uyun al-turath)',9.301682475471416, 2, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Naqd wa-mustaqbal al-thaqafah al-Arabiyah',9.465578368681687, 99, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Majmu rasail al-Hafiz ibn Rajab al-Hanbali',10.027472418527811, 7, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mukhtasar tafsir Yahya ibn Sallam li-Abi Abd Allah Muhammad ibn Abi Za',20.491140140152382, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Munazarat bayna fuqaha al-Sunnah wa-fuqaha al-Shiah',95.4695288360645, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La potestad revocatoria de la administracion, alcance y limites (Colec',19.016442595960662, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El debate constituyente en Venezuela',80.01374989226039, 39, 'https://covers.openlibrary.org/b/id/5254681-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Asamblea constituyente y ordenamiento constitucional (Serie estudios)',3.00040820444863, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Brujitas (Little Witches)',11.147859618085782, 43, 'https://covers.openlibrary.org/b/id/5254741-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ai de xin jian',33.0269518195665, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Image Processing for Future High Energy Physics Detectors',13.002388360321056, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Maha Satipatthana Sutta ; The Only Path to Nibbana',54.00015276878586, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Samutphāp bōrān tamnān Rattanakōsin',6.2900113411878475, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Etiket mezhdunarodnogo obscheniia. Uchebnoe posobie',40.12223604512566, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Twelve Plays for Children',16.811921971357446, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Temple Bells',77.46175339453372, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A Scriptural Odyssey ; An Exploration of the Scriptures of the Nine Li',96.07427399253912, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Intuition',50.38507888595218, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Administration of Elementary Schools',68.29802665979166, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Computer and Languages - 2 Vols',23.263626175889254, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Environmental education about the rain forest',7.808799878979595, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Information & Communication Technology Teaching Skills',58.19686065348227, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Basic Ophthalmology',8.584997215508348, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Texbook of Sociology for Nursing Student',34.04266773339618, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fundamentals of Information Technology',67.21805197216156, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Modern Indian Political System',30.910918481664694, 51, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Obesity',75.14806082392919, 3, 'https://covers.openlibrary.org/b/id/5255931-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Basics of Satelite Communication',27.266143829169128, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('History of India Down to the End of the Reign of Queen Victoria',4.433536751577536, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Industrial Management and Pollution Control',68.49984624232712, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Glimpses of Indian National Congress',97.79055084633472, 39, 'https://covers.openlibrary.org/b/id/5255971-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('GIS ; Fundamentals, Applications and Implementations',50.20850160071922, 13, 'https://covers.openlibrary.org/b/id/5256343-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Grecja Starozytna przed wybuchem wojny peloponeskiej (r. 433 przed Chr.)',86.05228056232801, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('German Air Projects (German Secret Air Projects)',92.198510331047, 10, 'https://covers.openlibrary.org/b/id/3324394-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cabinet of wonders and other Laguna stories',44.683746030568685, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Narkotyki I Narkomania W Wojsku Polskim',93.2599319971751, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chopins Work',66.22909165192617, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Asma y Alergias',28.070918215694345, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Combating poverty through the Comprehensive and Integrated Delivery of',52.56467110224403, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La cocina de las monjas / Nuns Cooking (Libro Practico Y Aficiones / P',93.41052930154515, 41, 'https://covers.openlibrary.org/b/id/5258234-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Consejos de un aristócrata bizantino',2.135294553029455, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pioneros De Lo Imposible',93.18166887019399, 39, 'https://covers.openlibrary.org/b/id/5258543-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fiske Guide to Colleges 2005',98.62996610867742, 66, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Matematica 3 - Bup',51.43368955168757, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tvoj znak zodiaka. Deva (Zvezdy i sudby)',87.63845825166028, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Amistades profundas',43.00849518073818, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Responsabilidad de Los Administradores de Sociedades Comerciales 2004-2005',96.23574207533227, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Glosario Sobre Ecologia y Medio Ambiente',98.04763466906353, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Alzheimer Mi Senora y Yo',60.02908994516769, 68, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Clinica del Desmorir',35.15074369063953, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Blancanieves y los Siete Enanitos',71.32733209618355, 3, 'https://covers.openlibrary.org/b/id/3360914-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Educacion Vial',15.155467462727952, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Janusz Korczak, Maestro de la Humanidad',46.37264773337453, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cuentos Nacidos de Mujer',55.700073370876396, 73, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Animales de La Selva (Mundo de Animalitos)',59.18974148720492, 91, 'https://covers.openlibrary.org/b/id/5260723-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cuatro destinos',18.773257851429648, 93, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Denuncia Anonima',30.843830471306497, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sociologia de Las Organizaciones',32.07545143119121, 77, 'https://covers.openlibrary.org/b/id/3362504-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tierra Del Fuego, Materiales Para El Estudio De La Historia Regional',64.1568763254797, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Covering the Intifada',74.29420077293618, 25, 'https://covers.openlibrary.org/b/id/720522-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Binyat al-mushabahah fi al-lughah al-Arabiyah',53.27344900694778, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pri Maths 1 PB Cameroon New EDN',62.43227798912103, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Adab al-murdiyah li-salik tariq al-Sufiyah',12.17122489523091, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ayy rajul min al-rijal ant',0.5429553240100201, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jawlah Tarikhiyah fi imarat al-bayt al-Arabi wa-al-bayt a-Turki',43.7062549822537, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wa-ma atakum al-Rasul fa-khudhuh wa-ma nahakum anhu fa-intahu (Mawsuat',48.618101788643926, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kayfa tuzawwiju anisan',33.25011111160791, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Adab al-akl wa-al-shurb fi al-fiqh al-Islami',79.181479723886, 51, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diwan Lahazat la-ha baqiyah',82.3585659279866, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Rihlat al-Arabiyah wa-al-Islamiyah wa-alamuha fi al-adab al-Arabi a',48.52467003289205, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Riyadat fi ilm al-faraid wa-masail fi ilm al-mawarith',22.439355167378547, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dhayl Lisan al-mizan',37.159178727568374, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nazarat shariyah fi Diwan al-Mutanabbi',91.02851218371269, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hal nahnu ummah!',95.29940345452923, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('How Namudiguli Saved Her Sister (Our Heritage Series)',48.05494298191509, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Relativistic Astrophysics',79.7431119907999, 93, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zhui xing',79.07480755872864, 25, 'https://covers.openlibrary.org/b/id/5261938-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Libro De La Alegria',56.47611914768743, 66, 'https://covers.openlibrary.org/b/id/5261987-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Qammudah, tarikhuha wa-alamuha',59.05235248443203, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los Pueblos Indios En Sus Mitos',60.004675005944634, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Maqalat fi al-adab al-Andalusi wa-al-Maghribi (Silsilat Dafatir al-wahadat)',88.19103352696465, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('al-Maghrib wa-muhituh',61.64882013043919, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ishkaliyat wa-tajalliyat thaqafiyah fi al-rif',70.32396027464642, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Eesti rahareform 1992',35.03094548464168, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Meditaciones Sobre La Iglesia',53.01963811222793, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Alfanhui (Clasicos Contemporaneos Comentados)',42.21945497383242, 100, 'https://covers.openlibrary.org/b/id/5531891-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La alimentacion racional',50.60482831086217, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Comedias',50.00041149471939, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Esteban Pio, Pio',99.11826979129826, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chu Văn An, khuôn mặt người thà̂y',1.9407170918255028, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Dibujo de La Figura Humana',68.1734807881878, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los Mundiales Que He Vivido Y El Mundial',43.54338264364125, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sistemas de Aeronaves',52.156380024418276, 51, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Empresa Agresiva, La',60.444206956005, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Palabra Cada Dia',93.25105399389817, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mi Primer Sopena Ingles',67.2020201986981, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Cocina Tex-Mex',57.14970855706025, 66, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Libro De Los Records',5.019836226508317, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('First years in mathematics; based on the work of the Adelaide Mathemat',23.221424482333138, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Gran Libro del Billar',98.36244921443449, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Como Conseguir See Contratado',97.55831743668399, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Arte de Las Flores Prensadas',56.0845693754897, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Patchwork Sin Aguja',68.65595743925357, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Plantas Tapizantes y Coniferas Enanas',33.12734865851335, 81, 'https://covers.openlibrary.org/b/id/5264612-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Palmeras',30.65124422200611, 82, 'https://covers.openlibrary.org/b/id/5264647-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Platon y Aristoteles',1.2559931451764093, 7, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('En La Calle - MIS Primeras Adivinanzas',71.03764135295586, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Temas Transversales. Hacia Una Nueva Escuela - 106',62.0076171459554, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Todo Sobre La Tecnica del Color',94.0201600957558, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Economia Politica del Crecimiento Fluctuaciones y',72.51533258353007, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Conectores de La Lengua Escrita',50.007941254245964, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Templarios, Los - En El Corazon de Las Cruzadas',60.11162772625915, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Vida en Los Polos',31.55086192460985, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Peter Gabriel',44.26856720675324, 6, 'https://covers.openlibrary.org/b/id/5265934-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hawamish',57.10506124302677, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Late Cenozoic Benthic Foraminifera',24.26268309067229, 38, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('State Energy Price and Expenditure Report, 1987',65.37031317961832, 66, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Uniform Commercial Code',90.06920730028823, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Of Dreams and Danger',17.257258077060413, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cognitive Flexibility Theory',79.20179599781912, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Measurement of Toxic and Related Air Pollutants',38.02020926097933, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('California Geographer, 1991',54.02928025627141, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pietro Pomponazzi',13.444209883064483, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Virus and Viruslike Diseases of Pome Fruits and Simulating Noninfectio',16.214559266727193, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Away for the Weekend',62.027391880153004, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nghệ thuật chơi chữ trong ca dao người Việt',22.018916394089363, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pri Geog 5 Textbook Brunei Rev',66.28819141458642, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Greeks and the Barbarians/Yunanian Va Barbarha',17.0029319023455, 2, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('1990-1991 Patent Law Handbook',7.443457004847091, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Supported Work Model of Competitive Employment for Citizens With Sever',48.6580744461889, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('County Executive Directory',28.309212518498846, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rhode Island Bandits, Bushwackers, Outlaws, Crooks, Devils, Ghosts, De',44.01376453649363, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Fernando I (1503-1564)',96.12089381510896, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Postres 1',46.326643233329555, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Castilla-la Mancha',98.09834846552125, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Libro De Los Cinco Anillos Para Ejecutivo',35.16526927714376, 31, 'https://covers.openlibrary.org/b/id/3327565-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Todos Los Estrenos De 1998',82.11040466481185, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Traumatologia del Pie',27.54371755263026, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La museologia/ The Museology (Arte Y Estetica/ Art and Esthetics)',35.50351736678268, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La vie quotidienne des professeurs en France de 1870 a 1940',59.64095289120315, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Poder Energetico de Los Alimentos',48.74334375898996, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manual de Psicopatologia - Volumen 2',66.02483289290929, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guia Multimedia Microsoft Word 2000 Curso de Apren',52.00552506110695, 62, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Harta Suarang dan penguasaannya dalam masyarakat Limo Koto, Kampar',96.06947623886903, 97, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La practica del diseno grafico/ The Practice of Graphic Design',7.573632103565013, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Grecia (Manual De Conversacion)',52.54845805514226, 94, 'https://covers.openlibrary.org/b/id/5268057-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Globalisation and the new realities',71.20987910931498, 78, 'https://covers.openlibrary.org/b/id/1053858-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los arboles de mi Jardin / The Trees in My Garden (Enciclopeque / Encyclopedia)',46.04972535054317, 70, 'https://covers.openlibrary.org/b/id/5268773-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Etica y Hermeneutica - Ensayo Sobre La Construccion Moral del Mundo de',29.639024860750283, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dermatoscopia - Pautas de Diagnostico',73.49139748003628, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Creaciones Navideas Con Pasta de Sal',71.30652748977738, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Quiero Ese Vestido/ Charlie in the Pink',15.041483475194301, 87, 'https://covers.openlibrary.org/b/id/5270228-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('As 400 Manual Para Programadores y Analistas',81.78673973553369, 4, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gangs in Prison',81.02130716154547, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Preparing Personal Injury Cases for Trial',36.003444828524096, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Contact Tracing and Partner Notification (Apha/Sia Report 2)',38.85104958287136, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Achieving Campus Diversity',66.04159116291407, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Square Dance Fun for Everyone (2 cds with a booklet)',2.043955625773445, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Survey data on tax compliance',78.34836867170345, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les origines de la restauration des Bourbons en Espagne',62.078699132910394, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Brunei Darussalam',47.16355424407533, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ensayos sobre literatura puertorriqueña y dominicana',87.26234413038253, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Handmaiden in Distress',42.11112243766185, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Interpretation in Psychoanalytic Anthropology (Ethos Series : Volume 15, No 1)',85.15771095322046, 27, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Korean Bible (Hankul Version)',39.04068160305357, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Safe in sea and sky',18.811904101821053, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sabiduria Africana',55.49252084724159, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Antonio Ortega',26.000522830712438, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Como Hacer Feliz en el Amor al Hombre',11.033128356965388, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Manual de Marketing General y de Servicios Turisti',50.1469895278264, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Que Ninfa Pongo',35.37946444038455, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La ciudadania de la Union',93.09944690709987, 69, 'https://covers.openlibrary.org/b/id/5272336-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jatidiri budaya dalam proses nation-building di Inggris dan Indonesia',6.036477641983395, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Moscu',53.21092780849913, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Dormicion De La Virgen',23.339883724747477, 79, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Codex de Ciencias de Laboratorio Clinico',29.48020674600472, 97, 'https://covers.openlibrary.org/b/id/5273191-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cuentos De Perrault',61.07192800108957, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('17. Yuzyïlin ikinci yarisinda Istanbul',49.34126042646312, 88, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Bajas esferas, altos fondos',90.18099397868225, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Te Doy Una Cancion',85.47402522038318, 75, 'https://covers.openlibrary.org/b/id/3332593-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guia Practica de La Energia - Consumo Eficiente y Responsable',26.472498233154692, 56, 'https://covers.openlibrary.org/b/id/3332638-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Touristic Sevilla, map of the city, toponymic index, tourist informati',85.2950468813296, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Las preposiciones inglesas y sus ejercicios/English prepositions with exercises',87.61143465410174, 16, 'https://covers.openlibrary.org/b/id/5275115-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Direccion Para Innovacion',97.61847115780608, 62, 'https://covers.openlibrary.org/b/id/5275161-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los Anos Olvidados/ the Forgotten Years',81.0467014013094, 3, 'https://covers.openlibrary.org/b/id/5274893-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diario Creativo, El',89.20545667978465, 54, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Album',59.078218968106334, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Theological Virtues on Faith (#0851)',38.05081071336931, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Listen to His Love',79.46803783585374, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Directory of Postsecondary Institutions, 1986',91.12782969822366, 56, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Analisis efisiensi pemasaran anggur Kabupaten Buleleng, Propinsi Bali',30.806001646377155, 35, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Enfermeria Practica (53023)',55.25827081064725, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Representative American Speeches, 1946-47',27.096276482843358, 70, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Progress in Quantum Electronics, No 3 and No 4, 1987',53.24245665687338, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Photoshop 6 Para Windows y Mac OS - Curso Iniciaci',23.01124829565875, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nios Necesitan Normas, Los',18.229416457103518, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Exploracion Consciente del Transito',12.389851046855448, 13, 'https://covers.openlibrary.org/b/id/3333329-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Los Elementos Arquitectonicos Ornamentales En El Tolmo de Minateda (He',67.22556697273397, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Secretos de Salud - Consejos Medicos Para Mejorar Su Calidad de Vida',32.0957585387489, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Chopin (Ma Non Troppograndes Compositores)',22.046613482720595, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Motif dan ornament Melayu',60.00956647145702, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rehabilitacion de Enfermos Mentales Cronicos',18.023362739289595, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Librito del Amante del Chocolate',34.073121841329204, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El Sindrome de Eva',54.18570537186746, 77, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La cultura de vino',43.531797319411865, 78, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Relajacion',84.04413949479556, 14, 'https://covers.openlibrary.org/b/id/5277118-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Las Claves Del Codigo Da Vinci/ The Keys to the Da Vinci Code',16.551794128413242, 22, 'https://covers.openlibrary.org/b/id/3335116-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Xoaquin Lorenzo (1907-1989): Unha Fotobiografia (Grandes Obras)',80.07536056584998, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Laurea Barrau',35.288296013457774, 51, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Economia contemporània de lÀsia oriental',12.591346864569687, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Aktualisasi identitas dan integritas nasional dalam era globalisasi',71.21953363453956, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Codigo de Processo Civil (Rt Codigos)',56.14357427733103, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Starting and Running a Successful Business in Michigan',11.680148762741887, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The harness room',54.3256054278557, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Romance of the Castle',82.38083664086487, 67, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Law, Order and the Authoritarian State',65.0678258388582, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('200 Hundred Years of Chairs and Chairmaking',93.57305037463126, 42, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('So Far from God',58.10505727457935, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Increased Hunger and Declining Health',7.136899529487321, 91, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Muslim Nursery Rhymes',60.39299961990188, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Computerized Investor',63.057913464510385, 2, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ustilaginales of Mexico',95.34607939930655, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('To Build a Whaleboat',10.206583915422511, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('In Search of Wow Wow Wibble Woggle Wazzle Woodle Woo (540-272c)',39.439139367685215, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Practical Effects in Photography',45.185964584958946, 51, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Topics in Photographic Preservation',38.012219576050676, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gulf Security and the Iran-Iraq War',4.51950343642192, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Food Allergy in Childhood and Comments on Trial Diets',89.04648388622996, 50, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Internet Legal: O Direito Na Tecnologia Da Informac~ao',92.35798868320143, 61, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('COMO VIVER (QUASE) FELIZ COM SEU FILHO ADOLESCENTE',83.01232923972347, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('9 Passos Para Reverter Ou Prevenir O Câncer E Outras Doenças',21.030800592895268, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Revitalisasi Balai Kota Lama, Jalan Balai Kota, Medan',38.70526387447952, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mad for Een',67.25459306199282, 36, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pierre, Paul, Fatma et les autres Les Francais devant lEurope',26.00873914835294, 86, 'https://covers.openlibrary.org/b/id/3336233-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kraks kort over København og omegn 99',88.53263969917278, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('I problemi della direzione strategica delle imprese di pubblici serviz',70.4866725686607, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Viaggi e viaggiatori nellEuropa moderna',50.08650945000933, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nili',94.73781705697151, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Choesin haengjongpop kangui (Pomnyurhak chongso)',53.149668127313454, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hangugin ui chonggyo kyonghom',2.082606561846261, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yol sonkarak e tal ul talgo',13.058971979942202, 71, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Powerful Conversations - Korean Translation',63.3658469101196, 24, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kodae Hanguk ui kukka wa chesa (Hanguk sahoe yongu chongso)',5.4738019528686435, 100, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Maldul ui punggyong',93.37136475104298, 39, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Himpunan produk-produk Dewan Perwakilan Rakyat Daerah, Propinsi Daerah',18.06915023384003, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sentimental memoirs',34.277521525622824, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Psychiatrische Studien aus der Klinik',44.4446293903277, 78, 'https://covers.openlibrary.org/b/id/6167166-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('National Park Seminary, a junior college (incorporated) for young wome',21.087979204981206, 14, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Das orakelwesen im Alterthume',62.45203478715233, 46, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Poems',65.09207220214722, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A sermon preachd on Wednesday, January XIX, 1703/4',48.04820843984665, 87, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The childs guide to the French tongue',33.47021770683721, 96, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Particulars of freehold estates, at Clarborough and East-Retford, in t',31.33679289850199, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A journal of the votes & proceedings of the General Assembly of His Ma',28.1831768148953, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The heinous sins of adultery and fornication, considered and represented',57.0219695369208, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A letter to the church-warden of the parish of Winterbourn-Gunner, in Wiltshire',4.001202994897738, 95, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The tragical history of the Stuarts from the first rise of that family',89.06269624894311, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Keterangan Pemerintah mengenai lima rancangan undang-undang tentang Pe',1.4132328326111734, 31, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A serious address to unbaptized Christians. Wherein are shewn, I. The ',21.345034994368216, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The elements of speech',30.7132225042669, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Universal gardeners kalendar, and System of practical gardening; .',17.152285180101853, 94, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A calculation of foreign exchanges',86.08543719112468, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Some considerations touching the payment of tythes',2.020716590922873, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Respon kelembagaan sosial desa terhadap modernisasi',55.762444095401534, 89, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Exchange no robbery: or, a fair eqivalent for the test. In a letter to a friend',77.19975478264799, 60, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Particulars and conditions of sale of a valuable estate, consisting of',25.521511927508193, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Orian',58.056469358608375, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Celenia and Adrastes',22.144158022051904, 58, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The quack-doctor. A poem. As originally spoke at the Free Grammar Scho',42.33389219366808, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Declaration dans le Procès du Roi',24.748325544825754, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('General rules, orders and regulations, agreed upon to be observed by t',56.21001836974279, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('To Sir Walter Blackett, Bart. Mayor, the Aldermen, and Common Council ',7.015750229640162, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Joannis Battely S.T.P. Archidiaconi Cantuariensis opera posthuma. Viz.',9.221729376741175, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The Hon. Thomas Erskine. On Monday, Jan. 12, 1795, was published ... N',45.60649623218395, 2, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Decisions of the Court of Session, for the years 1772, 1773, and 1774',36.581223903421154, 45, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Il vero carattere di Giuseppe Baretti, pubblicato per amor della virtu',28.29231920657358, 62, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('An introduction to English grammar: intended also to assist young pers',12.209361352996904, 57, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Of the use of publick instruction: a sermon preached at the visitation',9.565276222931173, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The trial of the Rev. Mr. James Altham, ... for adultery, defamation, ',29.48930066626906, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Address of the department commander',96.0045170949397, 39, 'https://covers.openlibrary.org/b/id/5930422-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La situation ©Øeconomique de la colonie',41.66044458804391, 3, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Voyage litt©Øeraire de la Gr©�?ece',81.12527732286193, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Proceedings of the ... annual convention',60.1291907455902, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Menggugat kekuasaan negara',24.199670880830336, 23, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gaya retoris tidak langsung dalam bahasa Madura',98.07555548083903, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The records of freemasonry in the state of Connecticut',94.1401796802384, 38, 'https://covers.openlibrary.org/b/id/5930250-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Roll of the department officers, representatives and past commanders o',66.08147113118157, 19, 'https://covers.openlibrary.org/b/id/5930430-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Histoire de France sous Louis XIII et sous le ministère du cardinal Ma',67.00590607511336, 43, 'https://covers.openlibrary.org/b/id/5932284-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les œuvres de Tacite',84.14745219297231, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De scoliorum poesi',23.35157869398232, 65, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A discourse on the proposed repeal of the Missouri compromise',43.644872286741034, 47, 'https://covers.openlibrary.org/b/id/7187788-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La Hongrie apr©�?es le trait©Øe de  Tri',68.61025765246195, 21, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Navins veterinary practice, or, Explanatory horse doctor',11.586288736919155, 21, 'https://covers.openlibrary.org/b/id/7207200-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nomenclator botanicus',45.16357764018245, 22, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Speeches',79.54068175754755, 83, 'https://covers.openlibrary.org/b/id/5935974-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The eternal whisper',38.00321906627739, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('National politics',32.45458040762252, 22, 'https://covers.openlibrary.org/b/id/5937720-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Études sur la vie de Bossuet jusquà son entrée en fonctions en qualité',88.56953679986387, 50, 'https://covers.openlibrary.org/b/id/6236808-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gerakan politik kaum tarekat',14.37668882605312, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A summary of papers read at different times before the Royal Society o',7.040984159061019, 76, 'https://covers.openlibrary.org/b/id/6105400-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Beneath the Surface',30.328692705903286, 99, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kaum profesional menentang rezim otoriter',39.507865294972085, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gus Dur',99.23219538929372, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('First-[sixth] Year Music',56.308905663864934, 99, 'https://covers.openlibrary.org/b/id/6154919-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Three lyrics',59.30157843907417, 97, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tuladha prasaja',33.039409513451325, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kozma Lajos',4.161509695844403, 30, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lyautey lafricain ou Le rêve immolé',51.00001729040767, 72, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Catherine-Paris',99.04942399100386, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('L Alliance israélite universelle et la renaissance juive contemporaine',0.7060713842345977, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nihon k�?kogaku y�?go jiten',2.0169847916186874, 99, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Lo que no vemos morir',28.055833881835266, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La traduction du latin',16.552345407759017, 98, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Les expériences amoureuses',5.102595500862405, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Josei ni kansuru jūnish�?',36.037747802960226, 12, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rengaron no kenkyū',71.37485776417626, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Maxwell Anderson, the man and his plays',63.05024936484779, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Autoxidation studies of some pyrylium-3-oxide/cyclopentenone epoxide tautomers',10.013737019953378, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Sobowtóry',26.070189703814346, 55, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Saint Magloire',7.153636691647686, 70, 'https://covers.openlibrary.org/b/id/6055350-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Le roman naturaliste',33.187687530643764, 51, 'https://covers.openlibrary.org/b/id/5752542-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Émeutes en Espagne',91.09967204541593, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El reverso de la belleza',49.00557832514792, 17, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Correspondance, 1925-1967',92.29245346998353, 29, 'https://covers.openlibrary.org/b/id/5414525-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('La letra del espíritu',70.27325249653124, 56, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tipos trashumantes cróquis á pluma',97.40531689910539, 8, 'https://covers.openlibrary.org/b/id/6173928-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('O sovremennoĭ literature',66.02099085568305, 18, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rime Nuove',28.233041809819753, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('El señor Monitot',81.0185476385544, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('If I were seventeen again',11.285532645150868, 11, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The logical atomism of Bertrand Russell',85.00240970607425, 73, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Analisis faktor-faktor yang mempengaruhi kapasitas pajak dan upaya paj',32.13704593904858, 74, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Guangxu chao Dong hua xu lu',81.31272304843392, 34, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Pengetahuan dan perilaku sadar gizi ibu rumahtangga di desa miskin Kec',47.56760436031639, 86, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Herders Kritische Wälder',1.4024928838084696, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Du noir sur du blanc',31.006498675571248, 1, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Géographie de lempire de Chine',50.62068810509214, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Oeuvres poétiques',32.100125714818645, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Theokritosz Ujpesten',77.03359649683807, 20, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zan zanshil, sot︠s︡ialist azh tȯrȯkh ës',67.35462347307569, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Jaminan air bagi petani',99.40612429147934, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Liangshan luo Yi kao cha bao gao (2v.)',32.01402922949523, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Karam muns�?n',96.53574984154304, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Minu nutuġ-un sara',41.68508495618559, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tenshi',46.79237238638243, 93, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Dasar-dasar pangaweruh wayang golek purwa Jawa Barat',18.321093954222302, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Juraki',56.2824455065605, 80, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Min guo yi lai zhong yang dui Meng Zang de shi zheng',18.207169327186797, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Tang Song zhi ji gui yi jun jing ji shi yan jiu',97.22186638421678, 59, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kohyang sajingwan',95.27033035013098, 43, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Shuppatsu shink�?!',23.388334315759437, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Leonardo da Vinci, the artist and the man',17.157360403764503, 10, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Mune no asobi',73.54066602073152, 37, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Seikatsusen ABC',97.00199287986514, 68, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('G�?tama budda',88.00686971970433, 92, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ningen no kabe',17.289590826590853, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Kokky�? no minami',83.07098188116635, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Niji ni mukatte hashire',9.319768638336345, 40, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('San mao mao tui li',70.28829372208709, 23, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Wakoku no sekai',79.77190934120692, 48, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Cuona, Longzi, Jiacha, Qusong Xian wen wu zhi',48.177587116806855, 26, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Gaikan Meiji bungaku',60.21715484014266, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Shinbun no rekishi',8.295129960963084, 76, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('De literarvm lvdis recte aperiendis liber Ioannis Sturmij',56.40095032666572, 28, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yan Shigu nian pu',27.037204983152556, 32, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Hanashi no tech�?',79.31589881884214, 15, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Khamthām khamtō̜p panhā tham',6.097432887345628, 9, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Contralateral transfer of training',64.01457139967172, 70, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Undergraduate physical education majors development and teaching behav',23.029689403156443, 25, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('An analysis of kinetic and kinematic factors of the standup and the pr',46.2829267757502, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Development of work sampling methodology for analysis of park maintenance',10.23279332207176, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A description of the situation, climate, soil, and productions of cert',9.177921330864077, 82, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('A monograph of the east American scaphopod mollusks',28.444323843073047, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Voyage à la Louisiane, et sur le continent de LAmérique septentrionale',12.219131544812484, 69, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Curupayty, homenaje a la memoria del teniente general Bartolomé Mitre ',72.40800932975176, 77, 'https://covers.openlibrary.org/b/id/6019128-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('The chast and lost lovers living shadowed in the person of Arcadius and Sepha',44.09839476705407, 33, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Rural public transportation vehicles',93.35069004846936, 31, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Performance of add-on type heat pump water heaters using two different',57.3414651893566, 47, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Diet books sell well but ..',47.516490628228645, 6, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Resolution of the reactor vessel materials toughness safety issue',80.56221957272963, 7, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Über den Bau und die Entwicklung der Florideengattung Martensia',75.53978864808505, 41, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Directory of victim-offender mediation programs in the United States',29.092277598033526, 85, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nakamura Shinichir�?',86.41117307227701, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Osekkai na kamigami',30.46258866670725, 16, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ae K̲h̲udā',15.376187818452301, 52, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Shi ni tsuite',70.165092748471, 53, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('T�?i kioku',46.099495507262276, 50, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Zorig',98.30179423178285, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Yu shen mu hui ying de Alishan min zu',56.06871557464047, 49, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Ouyang Min yu di guang ji',19.012370796356112, 29, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('K̲h̲vājah Farīd aur unkā k̲h̲āndān',10.045814903000931, 75, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('R. Choĭnomyn T︠S︡agaan suvraga',95.66586101941182, 63, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Thomas L Copeland',2.445929177832318, 8, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Citrāl dāstān',44.28224338517535, 83, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Vita y obra de Galdós, 1843-1920',55.62906956812217, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('An intermediate logic',4.172773284461121, 64, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Beyond eagle and swastika',60.5408088860647, 5, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Slavery among the Indians of North America',88.03535071705102, 90, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Nikolaĭ Fedorovich Katanov',49.03452152616088, 84, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');

INSERT INTO readifined.book
(title, price, author, cover_img, book)
VALUES('Da srạh gharah gulūnah',37.32256410059761, 19, 'https://covers.openlibrary.org/b/id/null-L.jpg', '');


select * from readifined.book;


-------------------------------------------Book Genres ------------------------------------------------------------

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(2, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(2, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(2, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(3, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(3, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(3, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(3, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(4, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(4, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(4, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(5, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(5, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(5, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(6, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(6, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(6, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(6, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(7, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(7, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(7, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(7, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(8, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(8, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(8, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(9, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(9, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(9, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(10, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(10, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(11, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(11, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(11, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(12, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(12, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(12, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(12, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(13, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(13, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(13, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(14, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(14, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(15, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(15, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(16, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(16, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(16, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(17, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(17, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(18, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(18, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(18, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(18, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(19, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(19, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(19, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(19, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(20, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(20, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(20, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(20, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(21, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(21, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(21, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(22, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(22, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(23, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(23, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(23, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(23, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(24, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(24, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(24, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(24, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(25, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(25, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(25, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(25, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(26, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(26, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(26, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(27, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(27, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(27, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(27, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(28, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(28, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(28, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(29, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(29, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(30, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(30, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(30, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(30, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(31, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(31, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(31, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(32, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(32, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(32, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(33, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(33, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(34, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(34, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(35, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(35, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(36, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(36, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(36, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(37, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(37, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(37, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(38, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(38, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(38, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(39, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(39, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(39, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(40, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(40, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(41, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(41, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(41, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(42, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(42, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(42, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(43, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(43, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(43, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(44, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(44, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(44, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(44, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(45, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(45, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(45, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(45, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(46, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(46, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(47, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(47, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(47, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(48, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(48, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(48, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(49, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(49, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(50, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(50, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(50, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(51, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(51, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(51, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(52, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(52, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(52, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(52, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(53, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(53, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(53, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(53, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(54, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(54, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(54, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(55, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(55, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(56, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(56, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(56, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(56, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(57, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(57, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(57, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(57, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(58, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(58, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(58, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(59, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(59, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(59, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(60, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(60, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(60, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(61, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(61, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(61, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(62, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(62, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(62, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(62, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(63, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(63, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(63, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(63, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(64, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(64, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(64, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(64, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(65, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(65, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(65, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(66, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(66, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(67, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(67, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(67, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(68, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(68, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(68, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(69, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(69, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(69, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(69, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(70, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(70, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(71, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(71, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(71, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(71, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(72, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(72, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(73, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(73, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(73, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(73, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(74, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(74, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(74, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(74, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(75, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(75, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(75, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(76, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(76, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(76, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(77, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(77, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(77, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(78, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(78, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(78, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(78, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(79, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(79, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(80, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(80, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(81, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(81, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(82, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(82, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(82, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(82, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(83, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(83, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(84, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(84, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(85, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(85, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(85, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(85, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(86, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(86, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(87, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(87, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(88, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(88, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(88, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(89, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(89, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(89, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(89, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(90, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(90, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(90, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(90, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(91, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(91, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(92, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(92, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(92, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(92, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(93, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(93, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(94, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(94, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(94, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(94, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(95, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(95, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(95, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(95, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(96, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(96, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(96, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(97, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(97, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(98, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(98, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(99, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(99, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(100, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(100, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(100, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(100, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(101, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(101, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(101, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(102, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(102, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(102, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(102, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(103, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(103, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(103, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(104, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(104, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(105, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(105, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(105, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(105, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(106, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(106, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(106, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(106, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(107, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(107, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(108, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(108, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(108, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(108, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(109, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(109, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(109, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(109, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(110, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(110, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(110, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(110, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(111, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(111, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(112, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(112, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(112, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(112, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(113, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(113, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(113, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(113, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(114, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(114, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(114, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(114, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(115, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(115, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(115, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(115, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(116, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(116, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(116, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(116, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(117, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(117, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(117, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(118, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(118, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(118, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(118, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(119, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(119, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(120, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(120, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(120, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(121, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(121, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(122, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(122, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(122, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(122, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(123, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(123, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(123, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(124, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(124, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(125, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(125, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(126, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(126, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(127, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(127, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(127, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(127, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(128, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(128, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(129, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(129, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(130, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(130, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(130, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(130, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(131, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(131, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(131, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(132, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(132, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(133, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(133, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(133, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(134, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(134, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(134, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(134, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(135, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(135, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(136, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(136, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(137, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(137, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(137, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(138, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(138, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(138, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(138, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(139, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(139, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(139, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(140, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(140, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(140, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(141, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(141, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(142, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(142, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(142, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(142, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(143, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(143, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(143, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(143, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(144, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(144, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(144, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(145, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(145, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(145, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(145, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(146, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(146, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(146, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(146, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(147, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(147, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(147, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(147, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(148, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(148, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(148, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(148, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(149, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(149, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(149, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(149, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(150, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(150, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(150, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(150, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(151, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(151, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(151, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(151, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(152, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(152, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(152, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(152, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(153, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(153, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(154, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(154, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(154, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(155, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(155, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(156, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(156, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(157, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(157, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(157, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(158, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(158, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(158, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(158, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(159, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(159, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(159, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(159, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(160, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(160, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(160, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(160, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(161, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(161, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(162, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(162, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(162, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(162, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(163, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(163, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(164, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(164, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(164, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(165, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(165, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(165, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(166, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(166, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(167, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(167, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(167, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(168, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(168, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(169, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(169, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(169, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(170, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(170, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(170, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(170, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(171, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(171, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(171, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(171, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(172, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(172, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(172, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(173, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(173, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(174, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(174, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(175, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(175, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(175, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(175, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(176, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(176, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(176, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(176, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(177, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(177, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(177, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(177, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(178, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(178, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(178, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(178, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(179, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(179, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(179, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(179, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(180, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(180, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(180, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(181, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(181, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(182, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(182, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(183, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(183, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(183, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(183, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(184, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(184, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(185, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(185, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(185, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(185, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(186, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(186, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(186, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(186, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(187, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(187, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(187, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(188, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(188, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(188, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(188, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(189, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(189, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(189, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(190, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(190, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(190, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(191, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(191, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(191, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(192, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(192, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(193, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(193, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(193, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(193, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(194, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(194, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(194, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(195, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(195, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(195, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(196, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(196, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(196, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(197, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(197, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(198, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(198, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(199, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(199, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(199, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(199, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(200, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(200, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(200, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(201, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(201, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(201, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(202, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(202, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(202, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(202, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(203, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(203, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(204, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(204, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(204, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(204, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(205, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(205, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(205, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(205, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(206, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(206, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(206, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(207, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(207, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(207, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(208, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(208, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(208, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(208, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(209, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(209, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(209, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(210, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(210, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(210, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(210, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(211, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(211, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(211, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(212, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(212, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(212, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(212, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(213, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(213, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(214, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(214, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(215, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(215, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(215, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(215, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(216, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(216, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(216, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(216, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(217, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(217, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(217, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(218, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(218, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(219, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(219, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(220, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(220, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(221, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(221, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(222, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(222, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(223, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(223, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(224, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(224, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(225, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(225, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(226, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(226, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(226, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(227, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(227, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(227, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(227, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(228, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(228, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(229, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(229, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(229, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(230, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(230, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(231, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(231, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(232, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(232, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(232, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(233, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(233, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(233, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(233, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(234, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(234, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(234, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(235, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(235, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(235, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(235, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(236, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(236, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(236, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(236, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(237, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(237, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(237, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(237, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(238, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(238, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(239, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(239, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(240, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(240, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(240, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(240, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(241, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(241, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(241, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(241, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(242, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(242, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(242, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(242, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(243, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(243, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(244, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(244, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(244, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(244, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(245, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(245, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(245, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(245, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(246, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(246, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(246, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(246, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(247, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(247, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(247, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(247, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(248, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(248, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(248, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(249, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(249, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(249, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(250, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(250, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(250, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(251, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(251, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(251, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(251, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(252, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(252, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(252, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(253, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(253, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(254, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(254, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(254, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(255, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(255, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(255, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(255, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(256, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(256, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(257, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(257, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(258, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(258, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(259, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(259, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(259, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(260, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(260, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(260, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(260, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(261, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(261, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(262, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(262, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(262, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(263, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(263, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(264, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(264, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(264, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(265, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(265, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(265, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(266, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(266, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(266, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(266, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(267, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(267, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(267, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(267, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(268, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(268, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(268, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(268, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(269, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(269, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(269, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(270, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(270, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(271, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(271, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(271, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(271, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(272, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(272, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(272, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(272, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(273, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(273, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(273, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(274, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(274, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(275, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(275, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(275, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(275, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(276, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(276, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(277, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(277, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(278, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(278, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(278, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(279, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(279, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(279, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(280, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(280, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(280, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(281, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(281, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(281, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(281, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(282, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(282, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(282, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(283, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(283, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(283, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(283, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(284, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(284, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(284, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(284, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(285, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(285, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(286, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(286, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(287, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(287, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(287, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(287, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(288, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(288, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(288, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(289, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(289, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(289, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(289, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(290, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(290, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(290, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(290, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(291, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(291, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(291, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(292, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(292, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(292, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(292, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(293, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(293, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(293, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(294, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(294, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(294, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(295, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(295, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(295, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(295, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(296, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(296, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(296, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(297, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(297, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(297, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(297, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(298, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(298, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(298, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(299, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(299, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(299, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(299, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(300, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(300, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(300, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(300, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(301, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(301, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(301, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(302, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(302, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(303, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(303, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(303, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(303, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(304, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(304, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(304, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(305, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(305, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(305, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(305, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(306, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(306, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(306, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(306, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(307, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(307, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(308, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(308, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(308, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(309, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(309, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(310, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(310, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(310, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(310, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(311, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(311, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(311, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(311, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(312, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(312, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(312, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(312, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(313, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(313, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(313, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(313, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(314, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(314, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(315, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(315, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(315, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(316, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(316, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(316, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(316, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(317, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(317, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(318, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(318, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(319, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(319, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(319, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(320, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(320, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(321, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(321, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(321, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(322, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(322, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(323, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(323, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(323, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(324, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(324, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(324, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(324, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(325, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(325, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(326, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(326, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(326, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(326, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(327, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(327, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(327, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(327, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(328, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(328, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(328, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(329, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(329, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(329, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(330, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(330, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(330, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(331, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(331, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(331, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(332, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(332, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(332, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(333, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(333, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(333, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(334, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(334, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(334, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(335, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(335, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(335, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(336, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(336, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(337, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(337, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(337, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(337, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(338, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(338, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(338, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(339, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(339, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(340, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(340, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(340, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(340, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(341, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(341, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(341, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(342, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(342, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(342, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(342, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(343, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(343, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(344, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(344, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(345, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(345, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(346, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(346, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(346, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(347, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(347, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(348, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(348, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(349, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(349, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(349, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(350, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(350, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(350, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(351, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(351, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(352, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(352, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(353, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(353, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(354, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(354, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(355, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(355, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(355, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(356, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(356, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(356, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(356, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(357, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(357, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(358, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(358, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(359, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(359, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(359, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(360, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(360, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(360, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(361, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(361, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(362, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(362, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(363, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(363, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(363, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(363, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(364, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(364, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(364, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(364, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(365, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(365, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(365, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(365, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(366, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(366, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(366, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(366, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(367, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(367, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(367, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(368, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(368, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(368, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(369, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(369, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(370, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(370, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(370, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(370, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(371, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(371, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(371, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(372, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(372, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(373, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(373, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(373, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(374, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(374, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(374, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(375, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(375, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(376, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(376, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(377, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(377, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(377, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(377, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(378, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(378, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(378, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(378, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(379, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(379, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(379, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(380, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(380, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(381, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(381, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(382, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(382, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(382, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(382, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(383, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(383, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(383, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(384, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(384, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(384, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(385, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(385, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(386, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(386, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(386, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(386, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(387, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(387, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(387, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(387, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(388, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(388, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(388, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(388, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(389, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(389, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(389, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(390, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(390, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(390, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(390, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(391, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(391, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(391, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(391, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(392, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(392, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(392, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(393, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(393, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(393, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(394, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(394, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(395, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(395, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(396, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(396, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(396, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(397, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(397, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(397, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(397, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(398, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(398, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(398, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(399, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(399, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(399, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(399, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(400, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(400, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(400, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(401, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(401, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(402, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(402, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(402, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(403, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(403, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(403, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(403, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(404, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(404, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(404, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(405, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(405, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(406, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(406, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(406, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(406, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(407, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(407, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(408, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(408, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(408, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(408, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(409, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(409, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(410, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(410, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(410, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(410, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(411, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(411, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(411, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(412, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(412, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(412, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(412, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(413, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(413, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(413, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(414, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(414, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(414, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(415, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(415, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(415, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(416, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(416, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(416, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(417, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(417, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(418, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(418, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(418, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(418, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(419, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(419, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(419, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(419, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(420, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(420, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(421, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(421, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(421, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(422, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(422, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(422, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(422, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(423, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(423, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(424, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(424, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(424, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(424, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(425, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(425, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(425, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(425, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(426, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(426, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(426, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(426, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(427, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(427, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(427, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(428, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(428, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(428, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(429, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(429, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(429, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(430, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(430, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(431, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(431, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(432, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(432, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(432, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(432, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(433, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(433, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(433, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(434, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(434, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(434, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(434, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(435, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(435, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(436, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(436, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(437, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(437, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(437, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(438, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(438, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(438, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(439, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(439, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(439, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(440, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(440, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(440, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(441, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(441, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(442, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(442, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(442, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(443, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(443, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(443, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(443, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(444, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(444, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(444, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(445, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(445, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(445, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(445, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(446, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(446, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(446, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(446, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(447, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(447, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(447, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(447, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(448, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(448, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(449, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(449, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(449, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(450, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(450, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(451, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(451, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(451, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(451, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(452, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(452, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(452, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(453, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(453, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(454, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(454, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(454, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(454, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(455, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(455, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(455, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(455, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(456, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(456, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(457, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(457, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(458, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(458, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(459, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(459, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(460, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(460, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(460, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(460, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(461, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(461, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(462, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(462, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(462, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(462, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(463, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(463, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(463, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(464, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(464, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(464, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(465, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(465, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(466, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(466, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(466, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(466, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(467, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(467, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(467, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(468, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(468, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(468, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(468, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(469, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(469, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(470, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(470, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(470, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(470, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(471, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(471, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(472, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(472, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(472, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(472, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(473, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(473, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(473, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(474, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(474, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(474, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(474, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(475, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(475, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(475, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(476, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(476, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(477, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(477, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(477, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(477, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(478, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(478, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(478, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(479, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(479, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(479, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(479, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(480, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(480, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(481, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(481, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(481, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(481, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(482, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(482, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(482, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(482, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(483, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(483, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(483, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(484, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(484, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(484, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(484, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(485, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(485, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(486, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(486, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(487, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(487, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(487, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(488, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(488, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(489, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(489, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(490, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(490, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(491, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(491, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(491, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(491, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(492, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(492, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(492, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(493, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(493, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(493, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(493, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(494, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(494, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(494, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(494, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(495, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(495, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(495, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(496, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(496, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(497, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(497, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(498, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(498, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(499, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(499, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(499, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(500, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(500, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(500, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(501, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(501, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(502, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(502, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(503, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(503, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(504, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(504, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(504, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(505, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(505, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(505, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(506, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(506, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(506, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(507, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(507, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(507, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(508, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(508, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(509, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(509, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(509, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(510, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(510, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(511, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(511, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(511, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(512, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(512, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(513, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(513, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(513, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(513, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(514, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(514, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(515, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(515, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(516, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(516, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(517, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(517, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(517, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(517, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(518, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(518, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(519, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(519, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(520, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(520, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(520, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(521, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(521, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(521, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(522, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(522, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(522, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(523, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(523, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(524, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(524, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(524, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(525, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(525, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(525, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(526, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(526, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(527, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(527, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(528, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(528, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(529, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(529, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(530, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(530, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(530, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(530, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(531, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(531, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(531, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(531, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(532, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(532, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(533, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(533, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(533, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(533, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(534, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(534, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(534, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(534, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(535, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(535, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(535, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(536, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(536, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(536, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(536, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(537, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(537, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(537, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(538, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(538, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(539, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(539, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(539, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(540, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(540, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(540, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(540, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(541, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(541, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(541, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(542, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(542, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(543, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(543, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(544, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(544, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(544, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(545, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(545, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(546, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(546, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(547, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(547, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(547, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(547, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(548, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(548, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(548, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(548, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(549, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(549, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(549, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(549, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(550, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(550, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(551, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(551, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(551, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(552, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(552, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(553, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(553, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(553, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(554, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(554, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(555, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(555, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(555, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(556, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(556, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(556, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(557, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(557, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(557, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(558, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(558, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(558, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(559, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(559, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(560, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(560, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(560, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(561, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(561, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(561, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(562, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(562, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(562, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(562, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(563, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(563, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(564, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(564, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(564, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(565, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(565, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(566, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(566, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(566, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(566, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(567, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(567, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(567, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(567, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(568, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(568, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(569, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(569, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(569, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(569, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(570, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(570, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(570, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(571, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(571, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(572, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(572, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(572, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(573, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(573, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(573, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(573, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(574, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(574, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(574, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(575, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(575, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(575, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(576, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(576, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(576, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(576, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(577, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(577, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(577, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(578, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(578, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(578, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(578, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(579, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(579, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(579, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(580, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(580, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(580, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(581, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(581, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(582, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(582, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(583, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(583, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(584, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(584, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(584, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(584, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(585, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(585, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(585, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(586, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(586, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(586, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(586, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(587, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(587, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(587, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(587, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(588, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(588, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(589, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(589, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(589, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(590, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(590, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(591, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(591, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(592, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(592, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(592, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(592, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(593, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(593, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(593, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(594, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(594, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(594, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(594, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(595, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(595, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(595, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(595, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(596, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(596, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(596, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(597, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(597, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(597, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(597, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(598, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(598, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(599, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(599, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(600, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(600, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(600, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(600, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(601, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(601, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(601, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(602, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(602, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(602, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(603, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(603, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(603, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(604, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(604, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(605, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(605, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(606, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(606, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(606, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(607, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(607, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(607, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(607, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(608, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(608, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(608, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(608, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(609, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(609, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(609, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(609, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(610, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(610, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(610, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(610, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(611, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(611, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(611, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(612, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(612, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(613, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(613, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(613, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(614, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(614, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(615, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(615, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(615, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(616, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(616, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(617, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(617, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(617, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(618, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(618, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(618, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(618, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(619, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(619, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(620, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(620, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(621, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(621, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(622, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(622, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(623, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(623, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(623, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(623, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(624, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(624, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(624, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(625, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(625, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(625, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(625, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(626, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(626, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(627, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(627, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(627, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(627, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(628, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(628, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(628, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(628, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(629, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(629, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(629, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(630, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(630, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(631, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(631, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(631, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(631, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(632, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(632, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(632, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(632, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(633, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(633, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(633, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(634, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(634, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(634, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(635, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(635, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(636, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(636, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(637, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(637, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(637, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(637, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(638, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(638, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(638, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(639, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(639, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(639, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(639, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(640, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(640, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(641, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(641, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(641, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(641, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(642, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(642, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(642, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(643, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(643, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(643, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(643, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(644, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(644, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(645, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(645, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(645, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(646, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(646, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(646, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(646, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(647, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(647, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(647, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(647, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(648, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(648, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(648, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(649, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(649, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(650, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(650, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(650, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(651, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(651, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(651, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(651, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(652, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(652, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(652, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(652, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(653, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(653, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(653, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(654, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(654, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(654, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(655, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(655, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(655, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(655, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(656, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(656, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(657, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(657, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(657, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(658, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(658, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(658, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(659, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(659, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(660, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(660, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(660, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(660, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(661, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(661, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(661, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(662, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(662, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(663, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(663, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(663, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(663, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(664, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(664, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(665, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(665, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(666, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(666, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(666, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(666, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(667, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(667, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(667, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(667, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(668, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(668, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(669, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(669, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(669, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(669, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(670, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(670, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(670, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(670, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(671, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(671, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(671, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(671, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(672, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(672, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(673, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(673, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(673, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(673, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(674, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(674, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(674, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(674, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(675, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(675, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(675, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(676, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(676, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(676, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(677, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(677, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(677, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(678, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(678, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(678, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(678, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(679, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(679, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(680, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(680, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(680, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(681, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(681, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(681, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(682, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(682, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(682, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(683, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(683, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(683, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(683, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(684, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(684, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(685, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(685, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(686, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(686, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(686, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(687, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(687, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(688, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(688, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(689, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(689, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(689, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(690, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(690, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(691, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(691, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(691, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(691, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(692, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(692, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(693, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(693, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(693, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(694, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(694, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(694, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(694, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(695, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(695, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(695, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(695, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(696, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(696, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(696, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(696, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(697, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(697, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(698, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(698, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(699, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(699, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(699, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(699, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(700, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(700, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(700, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(700, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(701, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(701, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(702, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(702, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(703, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(703, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(703, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(704, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(704, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(705, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(705, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(706, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(706, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(706, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(706, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(707, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(707, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(707, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(707, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(708, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(708, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(709, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(709, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(709, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(709, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(710, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(710, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(710, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(711, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(711, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(711, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(711, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(712, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(712, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(713, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(713, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(713, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(713, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(714, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(714, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(714, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(715, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(715, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(715, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(716, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(716, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(717, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(717, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(717, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(717, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(718, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(718, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(718, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(718, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(719, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(719, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(720, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(720, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(720, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(720, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(721, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(721, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(721, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(721, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(722, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(722, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(722, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(722, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(723, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(723, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(724, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(724, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(724, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(725, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(725, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(725, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(725, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(726, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(726, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(726, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(726, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(727, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(727, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(727, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(728, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(728, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(729, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(729, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(729, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(729, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(730, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(730, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(730, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(730, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(731, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(731, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(731, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(731, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(732, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(732, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(733, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(733, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(733, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(733, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(734, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(734, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(734, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(735, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(735, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(735, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(735, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(736, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(736, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(736, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(736, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(737, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(737, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(737, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(738, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(738, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(738, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(738, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(739, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(739, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(740, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(740, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(740, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(740, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(741, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(741, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(741, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(742, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(742, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(743, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(743, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(744, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(744, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(744, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(745, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(745, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(745, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(745, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(746, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(746, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(746, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(746, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(747, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(747, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(748, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(748, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(748, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(748, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(749, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(749, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(749, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(750, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(750, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(751, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(751, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(752, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(752, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(752, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(752, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(753, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(753, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(754, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(754, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(754, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(754, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(755, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(755, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(755, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(756, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(756, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(756, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(756, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(757, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(757, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(757, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(757, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(758, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(758, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(758, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(758, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(759, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(759, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(760, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(760, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(761, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(761, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(761, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(762, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(762, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(762, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(762, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(763, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(763, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(764, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(764, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(765, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(765, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(765, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(765, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(766, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(766, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(767, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(767, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(768, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(768, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(768, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(768, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(769, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(769, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(770, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(770, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(770, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(770, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(771, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(771, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(772, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(772, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(772, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(772, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(773, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(773, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(774, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(774, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(774, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(774, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(775, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(775, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(775, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(775, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(776, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(776, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(776, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(776, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(777, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(777, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(777, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(778, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(778, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(778, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(779, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(779, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(779, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(780, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(780, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(780, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(781, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(781, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(781, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(781, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(782, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(782, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(782, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(782, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(783, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(783, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(783, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(784, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(784, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(785, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(785, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(785, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(785, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(786, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(786, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(787, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(787, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(787, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(788, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(788, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(789, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(789, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(789, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(789, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(790, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(790, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(791, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(791, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(791, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(791, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(792, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(792, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(792, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(793, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(793, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(793, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(794, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(794, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(795, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(795, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(796, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(796, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(797, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(797, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(798, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(798, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(799, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(799, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(799, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(800, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(800, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(801, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(801, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(801, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(801, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(802, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(802, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(803, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(803, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(804, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(804, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(804, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(805, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(805, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(805, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(805, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(806, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(806, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(806, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(806, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(807, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(807, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(807, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(808, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(808, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(808, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(809, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(809, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(810, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(810, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(810, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(811, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(811, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(812, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(812, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(812, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(813, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(813, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(813, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(814, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(814, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(815, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(815, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(816, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(816, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(816, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(817, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(817, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(817, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(817, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(818, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(818, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(819, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(819, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(819, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(820, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(820, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(821, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(821, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(821, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(822, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(822, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(822, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(822, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(823, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(823, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(823, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(824, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(824, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(825, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(825, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(826, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(826, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(827, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(827, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(828, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(828, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(828, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(829, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(829, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(830, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(830, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(830, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(831, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(831, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(832, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(832, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(833, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(833, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(833, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(833, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(834, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(834, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(835, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(835, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(836, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(836, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(836, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(836, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(837, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(837, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(837, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(838, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(838, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(839, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(839, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(840, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(840, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(841, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(841, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(842, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(842, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(842, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(843, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(843, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(844, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(844, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(845, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(845, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(845, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(846, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(846, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(846, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(847, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(847, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(848, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(848, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(849, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(849, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(849, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(850, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(850, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(850, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(850, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(851, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(851, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(851, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(852, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(852, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(852, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(852, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(853, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(853, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(853, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(854, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(854, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(854, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(855, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(855, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(855, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(856, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(856, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(856, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(857, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(857, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(857, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(858, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(858, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(859, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(859, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(860, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(860, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(860, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(860, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(861, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(861, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(861, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(861, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(862, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(862, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(863, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(863, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(864, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(864, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(865, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(865, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(865, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(865, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(866, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(866, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(867, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(867, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(867, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(868, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(868, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(869, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(869, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(869, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(869, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(870, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(870, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(870, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(871, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(871, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(872, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(872, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(873, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(873, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(873, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(874, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(874, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(875, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(875, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(876, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(876, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(876, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(877, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(877, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(877, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(877, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(878, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(878, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(878, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(878, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(879, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(879, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(879, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(879, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(880, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(880, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(881, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(881, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(882, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(882, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(882, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(883, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(883, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(884, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(884, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(884, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(884, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(885, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(885, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(886, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(886, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(887, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(887, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(887, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(887, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(888, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(888, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(889, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(889, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(890, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(890, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(890, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(890, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(891, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(891, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(891, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(891, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(892, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(892, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(892, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(893, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(893, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(893, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(894, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(894, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(894, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(895, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(895, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(895, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(896, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(896, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(896, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(897, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(897, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(897, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(897, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(898, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(898, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(898, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(899, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(899, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(899, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(900, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(900, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(900, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(900, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(901, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(901, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(901, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(902, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(902, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(902, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(902, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(903, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(903, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(903, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(903, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(904, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(904, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(904, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(905, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(905, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(905, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(906, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(906, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(906, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(906, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(907, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(907, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(907, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(907, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(908, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(908, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(908, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(908, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(909, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(909, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(909, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(909, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(910, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(910, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(911, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(911, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(911, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(911, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(912, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(912, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(912, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(912, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(913, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(913, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(914, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(914, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(914, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(914, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(915, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(915, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(916, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(916, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(916, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(917, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(917, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(917, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(917, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(918, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(918, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(919, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(919, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(919, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(920, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(920, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(920, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(921, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(921, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(921, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(922, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(922, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(923, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(923, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(924, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(924, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(924, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(924, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(925, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(925, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(925, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(925, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(926, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(926, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(926, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(927, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(927, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(928, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(928, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(928, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(929, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(929, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(929, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(929, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(930, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(930, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(930, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(930, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(931, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(931, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(931, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(931, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(932, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(932, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(932, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(933, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(933, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(933, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(934, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(934, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(934, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(935, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(935, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(935, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(935, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(936, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(936, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(936, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(937, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(937, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(938, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(938, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(938, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(938, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(939, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(939, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(939, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(939, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(940, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(940, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(940, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(941, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(941, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(941, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(941, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(942, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(942, 7);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(942, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(942, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(943, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(943, 20);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(943, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(944, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(944, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(944, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(944, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(945, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(945, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(945, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(946, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(946, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(946, 52);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(946, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(947, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(947, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(948, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(948, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(949, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(949, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(949, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(950, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(950, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(951, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(951, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(952, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(952, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(952, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(952, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(953, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(953, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(953, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(954, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(954, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(955, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(955, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(956, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(956, 24);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(957, 2);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(957, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(957, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(958, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(958, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(958, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(959, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(959, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(959, 10);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(960, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(960, 15);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(960, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(960, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(961, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(961, 49);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(962, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(962, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(962, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(963, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(963, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(964, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(964, 34);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(964, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(965, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(965, 9);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(965, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(965, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(966, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(966, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(966, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(966, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(967, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(967, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(967, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(967, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(968, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(968, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(969, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(969, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(970, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(970, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(971, 1);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(971, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(971, 21);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(972, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(972, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(972, 14);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(973, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(973, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(973, 40);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(973, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(974, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(974, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(974, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(975, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(975, 3);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(975, 31);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(976, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(976, 38);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(976, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(977, 27);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(977, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(977, 33);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(977, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(978, 28);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(978, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(978, 41);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(979, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(979, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(980, 56);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(980, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(980, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(981, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(981, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(981, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(982, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(982, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(982, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(983, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(983, 17);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(984, 39);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(984, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(985, 8);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(985, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(985, 54);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(986, 23);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(986, 48);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(986, 43);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(986, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(987, 42);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(987, 6);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(987, 18);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(988, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(988, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(989, 46);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(989, 22);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(989, 16);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(989, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(990, 5);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(990, 37);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(991, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(991, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(991, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(991, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(992, 32);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(992, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(993, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(993, 53);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(993, 12);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(993, 44);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(994, 47);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(994, 13);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(995, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(995, 29);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(996, 55);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(996, 30);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(996, 51);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(997, 36);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(997, 19);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(997, 35);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(998, 4);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(998, 25);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(999, 45);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(999, 11);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1000, 26);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1000, 50);

INSERT INTO readifined.book_genre
(book_id, genre_id)
VALUES(1000, 33);

select count(*) from readifined.book_genre;
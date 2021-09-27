-- LIACS - Leiden University - Databases 2020
-- SQLite3 compatible file

-- NB: an oscar is linked to an actor, not to a movie: 
-- an actor can therefore have an oscar in a year and 
-- for genre for which no movie seems to exist in this database.

-- Do not forget that multiple roads lead to Rome.

DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Starring;
DROP TABLE IF EXISTS Oscar;
DROP TABLE IF EXISTS Studio;

CREATE TABLE Actor(
	a_id		integer,
	aname		string,
	genre		string,
	gender		char,
	age			integer,
	PRIMARY KEY(a_id)
);

CREATE TABLE Movie(
	m_id		integer,
	mname		string,
	genre		string,
	age_req		integer,
	year		integer,
	profit		integer,
	s_id		integer,
	PRIMARY KEY(m_id)
	FOREIGN KEY(s_id) REFERENCES Studio
);

CREATE TABLE Starring(
	a_id		integer,
	m_id		integer,
	PRIMARY KEY(a_id, m_id),
	FOREIGN KEY(a_id) REFERENCES Actor,
	FOREIGN KEY(m_id) REFERENCES Movie
);

CREATE TABLE Studio(
	s_id		integer,
	sname		string,
	PRIMARY KEY(s_id)
);

CREATE TABLE Oscar(
	o_id		integer,
	year		integer,
	genre		string,
	a_id		integer,
	PRIMARY KEY(o_id),
	FOREIGN KEY(a_id) REFERENCES Actor
);

BEGIN TRANSACTION;

-- ACTOR BLOCK
INSERT INTO Actor VALUES (1001,'Viktor Reznov','Action','M',45);
INSERT INTO Actor VALUES (1002,'Galadriel of Lorien','Fantasy','F',33);
INSERT INTO Actor VALUES (1003,'Wendy von Dyke','Comedy','F',14);
INSERT INTO Actor VALUES (1004,'Jeroen of the Tree','Comedy','M',70);
INSERT INTO Actor VALUES (1005,'Jean de Metz','Action','M',55);
INSERT INTO Actor VALUES (1006,'Ulfric Stormcloak','Action','M',74);
INSERT INTO Actor VALUES (1007,'Bertrand de Poulengy','Action','M',55);
INSERT INTO Actor VALUES (1008,'Fred Fuchs','Romance','M',66);
INSERT INTO Actor VALUES (1009,'John Fist','Action','M',24);
INSERT INTO Actor VALUES (1010,'Dirk Action','Romance','M',46);
INSERT INTO Actor VALUES (1011,'Gabriel Stone','Fantasy','M',35);
INSERT INTO Actor VALUES (1012,'Phil Swift','Fantasy','M',28);
INSERT INTO Actor VALUES (1013,'Johnny Star','Action','M',10);
INSERT INTO Actor VALUES (1014,'Josephi Krakowski','Action','M',25);
INSERT INTO Actor VALUES (1015,'Vickers McHorsepower','Action','M',25);

-- MOVIE BLOCK
INSERT INTO Movie VALUES (1,'Project Nova','Action',18,2017,5,1);
INSERT INTO Movie VALUES (2,'Where is Gandalf','Fantasy',10,2016,3,2);
INSERT INTO Movie VALUES (3,'Finding Joan','Action',16,2018,1,3);
INSERT INTO Movie VALUES (4,'Age of Opression','Fantasy',8,2017,3,2);
INSERT INTO Movie VALUES (5,'The rise of LJN','Romance',10,2019,10,3);
INSERT INTO Movie VALUES (6,'Finding Blake Shrapnel','Action',8,2020,1,3);
INSERT INTO Movie VALUES (7,'Flex Heal','Fantasy',6,2020,3,2);
INSERT INTO Movie VALUES (8,'Getting to Vorkuta','Action',18,2019,4,2);

-- STARRING BLOCK
INSERT INTO Starring VALUES (1001,1);
INSERT INTO Starring VALUES (1002,2);
INSERT INTO Starring VALUES (1005,3);
INSERT INTO Starring VALUES (1007,3);
INSERT INTO Starring VALUES (1006,4);
INSERT INTO Starring VALUES (1014,4);
INSERT INTO Starring VALUES (1008,5);
INSERT INTO Starring VALUES (1006,5);
INSERT INTO Starring VALUES (1009,6);
INSERT INTO Starring VALUES (1010,6);
INSERT INTO Starring VALUES (1011,6);
INSERT INTO Starring VALUES (1001,6);
INSERT INTO Starring VALUES (1013,7);
INSERT INTO Starring VALUES (1014,7);
INSERT INTO Starring VALUES (1015,7);
INSERT INTO Starring VALUES (1008,7);
INSERT INTO Starring VALUES (1009,8);
INSERT INTO Starring VALUES (1010,8);
INSERT INTO Starring VALUES (1011,8);
INSERT INTO Starring VALUES (1001,8);
INSERT INTO Starring VALUES (1002,8);

-- OSCARS BLOCK
INSERT INTO Oscar VALUES (1,2016,'Action',1001);
INSERT INTO Oscar VALUES (2,2016,'Action',1002);
INSERT INTO Oscar VALUES (3,2016,'Romance',1015);
INSERT INTO Oscar VALUES (4,2017,'Action',1014);
INSERT INTO Oscar VALUES (5,2017,'Romance',1006);
INSERT INTO Oscar VALUES (6,2017,'Romance',1003);
INSERT INTO Oscar VALUES (7,2018,'Fantasy',1011);
INSERT INTO Oscar VALUES (8,2019,'Fantasy',0111);
INSERT INTO Oscar VALUES (9,2019,'Action',1009);
INSERT INTO Oscar VALUES (10,2019,'Fantasy',1001);
INSERT INTO Oscar VALUES (11,2020,'Action',1015);
INSERT INTO Oscar VALUES (12,2020,'Romance',1005);
INSERT INTO Oscar VALUES (13,2020,'Fantasy',1001);
INSERT INTO Oscar VALUES (14,2020,'Action',1014);
INSERT INTO Oscar VALUES (15,2020,'Action',1009);

-- STUDIO BLOCK
INSERT INTO Studio VALUES (1,'Sony');
INSERT INTO Studio VALUES (2,'Universal');
INSERT INTO Studio VALUES (3,'Warner');

COMMIT;


--01 CREATE DB

CREATE DATABASE Minions

--USE DB
USE Minions
GO

--02 CREATE TABLES
CREATE TABLE Minions
(
   Id INT PRIMARY KEY,
   [Name] VARCHAR(50),
   Age INT
)
CREATE TABLE Towns
(
   Id INT PRIMARY KEY,
   [Name] VARCHAR(50)
)

--03. Alter Minions Table

ALTER TABLE Minions
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id)

--04 INSERT RECORDS IN BOTH TABLES
INSERT INTO Towns
 VALUES(1,'Sofia'),
       (2, 'Plovdiv'),
	   (3, 'Varna')

INSERT INTO Minions(Id, [Name], Age, TownId)
VALUES(1, 'Kevin', 22, 1),
		(2, 'Bob', 15, 3),
		(3, 'Steward', NULL, 2)

SELECT * FROM Minions

-- 05 Truncate Table Minions

TRUNCATE TABLE Minions

--06 Drop All Tables

DROP TABLE Minions
DROP TABLE Towns

--07 CREATE TABLE PEOPLE
CREATE TABLE People
(
  Id INT PRIMARY KEY IDENTITY,
  [NAME] VARCHAR(200)NOT NULL,
  Picture VARBINARY(MAX),
  Height DECIMAL(3, 2),
  [Weight] DECIMAL(5, 2),
  Gender CHAR(1) NOT NULL
   CHECK(Gender in('m', 'f')),
  Birthdate DATETIME2 NOT NULL,
  Biography VARCHAR(MAX)
)

INSERT INTO People ([NAME], Gender, Birthdate) 
  VALUES('Pesho', 'm', '1998-05-05'),
						('Radka', 'f', '1994-07-05'),
						('Ivan', 'm', '1998-05-01'),
						('Petkan', 'm', '2001-06-05'),
						('Dragan', 'm', '1990-11-12')

SELECT * FROM People

--08 CREATE TABLE USERS

CREATE TABLE Users
( 
  Id INT PRIMARY KEY IDENTITY,
  Username VARCHAR(30) NOT NULL,
  [Password] VARCHAR(26) NOT NULL,
  ProfilePicture VARBINARY(MAX),
  LastLoginTime DATETIME2,
  IsDeleted BIT
)
INSERT INTO Users (Username, [Password]) 
VALUES ('peshjo123', '126863'),
			('ivan96', '98745414'),
			('maria', '234634567'),
			('petan019', '671234532'),
			('radka_p', '9873482758329')

DROP

--09 CHANGE PRIMARY KEY
TRUNCATE TABLE Users 

DROP CONSTRAINT PK__Users__3214EC079A88A8BC

ALTER TABLE Users
ADD CONSTRAINT PK_UsersTable PRIMARY KEY(Id, Username)

--10 ADD CHECK CONSTRAINT

ALTER TABLE Users
ADD CONSTRAINT CHK_PasswordIsAtleastFiveSymbols
  CHECK(LEN(Password) >= 5)

  INSERT INTO Users (Username, [Password]) 
VALUES ('peshjo123', '126324234'),
			('ivan96', '98745414'),
			('maria', '234634567'),
			('petan019', '671234532'),
			('radka_p', '9873482758329')

--11 ADD LASTLOGIN TIME

ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime

SELECT * FROM Users

--12 Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users;

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id);

--13 Movies Database
CREATE DATABASE Movies

USE Movies
GO

CREATE TABLE Directors
(
 Id INT PRIMARY KEY IDENTITY,
 DirectorName VARCHAR(50),
 Notes TEXT
)

CREATE TABLE Genres
(
 Id INT PRIMARY KEY IDENTITY,
 GenreName VARCHAR(50),
 Notes TEXT
)

CREATE TABLE Categories
(
 Id INT PRIMARY KEY IDENTITY,
 CategoryName VARCHAR(50),
 Notes TEXT
)
CREATE TABLE Movies
(
 Id INT PRIMARY KEY IDENTITY,
 Title VARCHAR(50) NOT NULL,
 DirectorId INT NOT NULL,
 CopyrightYear INT NOT NULL,
 [Length] INT NOT NULL,
 GenreId INT NOT NULL,
 CategoryId INT NOT NULL,
 Rating VARCHAR(10) NOT NULL,
 Notes TEXT,
  FOREIGN KEY (DirectorId) REFERENCES Directors(Id),
  FOREIGN KEY (GenreId) REFERENCES Genres(Id),
  FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)
INSERT INTO Directors (DirectorName, Notes) VALUES
('Steven Spielberg', 'Famous for directing Jaws, E.T., and Jurassic Park.'),
('Christopher Nolan', 'Known for Inception, The Dark Knight, and Interstellar.'),
('Quentin Tarantino', 'Directed Pulp Fiction, Kill Bill, and Django Unchained.'),
('Martin Scorsese', 'Directed Goodfellas, Taxi Driver, and The Wolf of Wall Street.'),
('James Cameron', 'Directed Titanic, Avatar, and The Terminator.');

INSERT INTO Genres (GenreName, Notes) VALUES
('Action', 'Movies with high energy and lots of stunts.'),
('Drama', 'Movies with in-depth character development and emotion.'),
('Comedy', 'Movies intended to make the audience laugh.'),
('Horror', 'Movies intended to scare the audience.'),
('Science Fiction', 'Movies with futuristic elements and advanced technology.');

INSERT INTO Categories (CategoryName, Notes) VALUES
('Blockbuster', 'Movies with large budgets and mass appeal.'),
('Independent', 'Movies produced outside of the major film studio system.'),
('Documentary', 'Movies that document reality for the purposes of instruction or maintaining a historical record.'),
('Short Film', 'Movies with a shorter duration, typically less than 40 minutes.'),
('Animation', 'Movies that are created using animated techniques.');

INSERT INTO Movies (Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes) VALUES
('Inception', 2, 2010, 148, 5, 1, 'PG-13', 'A thief who steals corporate secrets through the use of dream-sharing technology.'),
('Titanic', 5, 1997, 195, 2, 1, 'PG-13', 'A romance that blossoms on the ill-fated RMS Titanic.'),
('Pulp Fiction', 3, 1994, 154, 2, 1, 'R', 'The lives of two mob hitmen, a boxer, a gangster, and his wife intertwine.'),
('Jurassic Park', 1, 1993, 127, 5, 1, 'PG-13', 'A theme park suffers a major power breakdown that allows its cloned dinosaur exhibits to run amok.'),
('The Wolf of Wall Street', 4, 2013, 180, 2, 1, 'R', 'Based on the true story of Jordan Belfort, from his rise to a wealthy stock-broker to his fall.');

SELECT * FROM Movies
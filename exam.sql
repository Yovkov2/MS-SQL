--01
CREATE TABLE Contacts (
    Id INT PRIMARY KEY IDENTITY,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    PostAddress VARCHAR(200),
    Website VARCHAR(50)
)
CREATE TABLE Authors (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(100) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)
CREATE TABLE Genres (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(30) NOT NULL
)
CREATE TABLE Libraries (
    Id INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    ContactId INT NOT NULL,
    FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)
CREATE TABLE Books (
    Id INT PRIMARY KEY IDENTITY,
    Title VARCHAR(100) NOT NULL,
    YearPublished INT NOT NULL,
    ISBN VARCHAR(13) NOT NULL UNIQUE,
    AuthorId INT NOT NULL,
    GenreId INT NOT NULL,
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
    FOREIGN KEY (GenreId) REFERENCES Genres(Id)
)
CREATE TABLE LibrariesBooks (
    LibraryId INT NOT NULL,
    BookId INT NOT NULL,
    PRIMARY KEY (LibraryId, BookId),
    FOREIGN KEY (LibraryId) REFERENCES Libraries(Id),
    FOREIGN KEY (BookId) REFERENCES Books(Id)
)
--02
INSERT INTO Contacts (Email, PhoneNumber, PostAddress, Website)
VALUES 
(NULL, NULL, NULL, NULL),
(NULL, NULL, NULL, NULL),
('stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
('suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com');

INSERT INTO Authors (Name, ContactId)
VALUES 
('George Orwell', 21),
('Aldous Huxley', 22),
('Stephen King', 23),
('Suzanne Collins', 24);

INSERT INTO Books (Title, YearPublished, ISBN, AuthorId, GenreId)
VALUES 
('1984', 1949, '9780451524935', 16, 2),
('Animal Farm', 1945, '9780451526342', 16, 2),
('Brave New World', 1932, '9780060850524', 17, 2),
('The Doors of Perception', 1954, '9780060850531', 17, 2),
('The Shining', 1977, '9780307743657', 18, 9),
('It', 1986, '9781501142970', 18, 9),
('The Hunger Games', 2008, '9780439023481', 19, 7),
('Catching Fire', 2009, '9780439023498', 19, 7),
('Mockingjay', 2010, '9780439023511', 19, 7);

INSERT INTO LibrariesBooks (LibraryId, BookId)
VALUES 
(1, 36),
(1, 37),
(2, 38),
(2, 39),
(3, 40),
(3, 41),
(4, 42),
(4, 43),
(5, 44);
--03
UPDATE Contacts
SET Website = 'www.' + LOWER(REPLACE(a.Name, ' ', '')) + '.com'
FROM Contacts c
INNER JOIN Authors a ON c.Id = a.ContactId
WHERE c.Website IS NULL;
--04
DECLARE @AuthorId INT;
SELECT @AuthorId = Id FROM Authors WHERE Name = 'Alex Michaelides';

DELETE lb
FROM LibrariesBooks lb
INNER JOIN Books b ON lb.BookId = b.Id
WHERE b.AuthorId = @AuthorId;

DELETE FROM Books WHERE AuthorId = @AuthorId;
DELETE FROM Authors WHERE Id = @AuthorId;
--05
SELECT
    Title AS "Book Title",
    ISBN,
    YearPublished AS "YearReleased"
FROM
    Books
ORDER BY
    YearPublished DESC,
    Title ASC
--06
SELECT
    b.Id,
    b.Title,
    b.ISBN,
    g.Name AS Genre
FROM
    Books b
JOIN
    Genres g ON b.GenreId = g.Id
WHERE
    g.Name IN ('Biography', 'Historical Fiction')
ORDER BY
    Genre ASC,
    Title ASC;
--07
SELECT
    l.Name AS Library,
    c.Email
FROM
    Libraries l
JOIN
    Contacts c ON l.ContactId = c.Id
WHERE
    l.Id NOT IN (
        SELECT DISTINCT
            lb.LibraryId
        FROM
            LibrariesBooks lb
        JOIN
            Books b ON lb.BookId = b.Id
        JOIN
            Genres g ON b.GenreId = g.Id
        WHERE
            g.Name = 'Mystery'
    )
ORDER BY
    Library ASC;
--08
ELECT TOP 3
    b.Title,
    b.YearPublished AS Year,
    g.Name AS Genre
FROM
    Books b
JOIN
    Genres g ON b.GenreId = g.Id
WHERE
    (b.YearPublished > 2000 AND b.Title LIKE '%a%')
    OR
    (b.YearPublished < 1950 AND g.Name LIKE '%Fantasy%')
ORDER BY
    b.Title ASC,
    b.YearPublished DESC;
--09
SELECT
    a.Name AS Author,
    c.Email,
    c.PostAddress AS Address
FROM
    Authors a
JOIN
    Contacts c ON a.ContactId = c.Id
WHERE
    c.PostAddress LIKE '%UK%'
ORDER BY
    a.Name ASC;
--11
CREATE FUNCTION dbo.udf_AuthorsWithBooks(@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TotalBooks INT;

    SELECT @TotalBooks = COUNT(*)
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    WHERE a.Name = @name;

    RETURN @TotalBooks;
END;
--12
CREATE PROCEDURE dbo.usp_SearchByGenre
    @genreName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT b.Title, b.YearPublished AS Year, b.ISBN, a.Name AS Author, g.Name AS Genre
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    JOIN Genres g ON b.GenreId = g.Id
    WHERE g.Name = @genreName
    ORDER BY b.Title ASC;
END;
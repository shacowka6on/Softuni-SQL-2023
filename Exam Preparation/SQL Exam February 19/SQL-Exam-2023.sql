USE Boardgames

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
StreetName NVARCHAR(100) NOT NULL,
StreetNumber INT NOT NULL,
Town VARCHAR(30) NOT NULL,
Country VARCHAR(50) NOT NULL,
ZIP INT NOT NULL
)

CREATE TABLE Publishers(
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) UNIQUE NOT NULL,
AddressId INT FOREIGN KEY REFERENCES Addresses(Id),
Website NVARCHAR(40) NULL,
Phone NVARCHAR(20) NULL
)

CREATE TABLE PlayersRanges(
Id INT PRIMARY KEY IDENTITY,
PlayersMin INT NOT NULL,
PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
YearPublished INT NOT NULL,
Rating DECIMAL(3,2) NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL
)

CREATE TABLE Creators(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL,
Email NVARCHAR(30) NOT NULL,
)

CREATE TABLE CreatorsBoardgames(
CreatorId INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL,
BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL,
PRIMARY KEY (CreatorId, BoardgameId)
)

--Insert
INSERT INTO Boardgames ([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES 
       ('Deep Blue', 2019, 5.67, 1, 15, 7),
	   ('Paris', 2016, 9.78, 7, 1, 5),
	   ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	   ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	   ('One Small Step', 2019, 5.75, 5, 9, 2)
     
INSERT INTO Publishers([Name], AddressId, Website, Phone)
VALUES
       ('Agman Games', 5, 'www.agmangames.com', '+16546135542' ),
	   ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992' ),
	   ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907' )

--Update
UPDATE PlayersRanges SET PlayersMax += 1 
WHERE  PlayersMax = 2 AND PlayersMin = 2
--FIX IT
SELECT * FROM [PlayersRanges]

UPDATE Boardgames SET [Name] += 'V2'
WHERE YearPublished > 2020
	  
--Delete
DELETE 
  FROM Addresses
 WHERE Town = (
			     SELECT Id
				   FROM Addresses
				  WHERE Town LIKE 'L%'
              )
DELETE
  FROM Addresses
 WHERE Town LIKE 'L%'
SELECT * FROM Addresses
--Dosent work FIX IT

--Problem 05
SELECT [Name],
       Rating
 FROM  Boardgames
ORDER BY YearPublished ASC, [Name] DESC

--Problem 06
SELECT b.Id,
       b.[Name],
	   b.YearPublished,
	   c.Name
  FROM Boardgames AS b
  JOIN Categories AS c ON c.Id = b.CategoryId 
 WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
 ORDER BY b.YearPublished DESC

--Problem 07
SELECT c.Id,
       CONCAT(c.FirstName, ' ', c.LastName) AS CreatorName,
	   c.Email
  FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
LEFT JOIN Boardgames AS b ON b.Id = cb.BoardgameId
WHERE cb.CreatorId IS NULL
ORDER BY CreatorName ASC

--Problem 08
SELECT TOP 5 b.[Name], 
             Rating,
			 c.[Name]
  FROM Boardgames AS b
  JOIN Categories AS c ON c.Id = b.CategoryId
  JOIN PlayersRanges AS pr ON pr.Id = b.PlayersRangeId
 WHERE (b.Rating > 7.00 AND b.[Name] LIKE '%a%') 
       OR (b.Rating > 7.5 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5)
ORDER BY b.[Name] ASC, b.Rating DESC

--Problem 09
SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
       c.Email,
	   MAX(b.Rating) AS Rating
  FROM Creators AS c
  JOIN CreatorsBoardgames AS cb ON cb.CreatorId = c.Id
  JOIN Boardgames AS b ON b.Id = cb.BoardgameId
 WHERE c.Email LIKE '%.com'
 GROUP BY c.FirstName, c.LastName, c.Email
 ORDER BY FullName ASC 

--Problem 10
SELECT c.LastName,
       CEILING(AVG(b.Rating)) AS AverageRating,
	   p.[Name]
  FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
LEFT JOIN Boardgames AS b ON b.Id = cb.BoardgameId
     JOIN Publishers AS p ON p.Id = b.PublisherId
WHERE cb.CreatorId IS NOT NULL AND p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

--Problem 11
--function should return the total number of boardgames that the creator has created
CREATE FUNCTION udf_CreatorWithBoardgames (@name NVARCHAR(30))
RETURNS INT AS
BEGIN 
	DECLARE @total1 INT;
	    SET @total1 = (
		SELECT COUNT(b.Id) 
               FROM Creators AS c
               JOIN CreatorsBoardgames AS cb ON c.Id = cb.CreatorId
               JOIN Boardgames AS b ON b.Id = cb.BoardgameId
              WHERE FirstName = @name
		);
	RETURN @total1;
END;

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

--Problem 12

CREATE PROCEDURE usp_SearchByCategory(@category VARCHAR(50))
AS
SELECT b.[Name],
       b.YearPublished,
	   b.Rating,
	   c.[Name] AS CategoryName,
	   p.[Name] AS PublisherName,
	   CONCAT(pr.PlayersMin, ' people') AS MinPlayers,
	   CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
  FROM Boardgames AS b
  JOIN Categories AS c ON c.Id = b.CategoryId
  JOIN Publishers AS p ON p.Id = b.PublisherId
  JOIN PlayersRanges AS pr ON pr.Id = b.PlayersRangeId
 WHERE c.[Name] = @category
 ORDER BY p.[Name] ASC, b.YearPublished DESC

 EXEC usp_SearchByCategory 'Wargames'
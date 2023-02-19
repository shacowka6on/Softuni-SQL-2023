
CREATE TABLE Passengers(
Id INT PRIMARY KEY IDENTITY,
FullName VARCHAR(100) UNIQUE NOT NULL,
Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots(
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(30) UNIQUE NOT NULL,
LastName VARCHAR(30) UNIQUE NOT NULL,
Age TINYINT NOT NULL CHECK(Age >= 21 AND Age <= 62),
Rating FLOAT NULL CHECK(Rating >= 0.0 AND Rating <= 10.0) 
)

CREATE TABLE AircraftTypes(
Id INT PRIMARY KEY IDENTITY,
TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft(
Id INT PRIMARY KEY IDENTITY,
Manufacturer VARCHAR(25) NOT NULL,
Model VARCHAR(30) NOT NULL,
[Year] INT NOT NULL,
FlightHours INT NULL,
Condition CHAR NOT NULL,
TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL 
)

CREATE TABLE PilotsAircraft(
AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
PilotId INT FOREIGN KEY REFERENCES Pilots(Id) NOT NULL,
PRIMARY KEY(AircraftId, PilotId)
)

CREATE TABLE Airports(
Id INT PRIMARY KEY IDENTITY,
AirportName VARCHAR(70) UNIQUE NOT NULL,
Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations(
Id INT PRIMARY KEY IDENTITY,
AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
[Start] DATETIME NOT NULL,
AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
TicketPrice DECIMAL (18,2) NOT NULL DEFAULT 15
)


UPDATE Aircraft SET Condition = 'A'
WHERE 
     (Condition = 'B' OR Condition = 'C')
     AND (FlightHours IS NULL OR FlightHours <= 100)
     AND [Year] >= 2013

INSERT INTO Passengers(FullName, Email)
SELECT CONCAT(FirstName, ' ', LastName),
	   CONCAT(FirstName, LastName, '@gmail.com')
FROM [Pilots]
WHERE Id >= 5 AND Id <= 15

DELETE FROM Passengers WHERE LEN(FullName) <= 10

--Problem 5
  SELECT Manufacturer,
         Model,
  	     FlightHours,
  	     Condition
    FROM Aircraft
ORDER BY FlightHours DESC

--Problem 6
    SELECT p.FirstName, 
           p.LastName,
		   a.Manufacturer,
		   a.Model,
		   a.FlightHours
      FROM Pilots AS p
INNER JOIN PilotsAircraft AS pa ON p.Id = pa.PilotId
INNER JOIN Aircraft AS a ON a.Id = pa.AircraftId
     WHERE FlightHours IS NOT NULL 
	       AND FlightHours < 304
  ORDER BY FlightHours DESC, 
           FirstName ASC

--Problem 07
SELECT TOP 20 fd.Id AS DestinationId,
			  fd.[Start],
			  p.FullName,
			  a.AirportName,
			  fd.TicketPrice
         FROM FlightDestinations AS fd
   INNER JOIN Passengers AS p ON p.Id = fd.PassengerId
   INNER JOIN Airports AS a ON a.Id = fd.AirportId
   WHERE DATEPART(DAY, fd.[Start]) % 2 = 0
     ORDER BY TicketPrice DESC, 
              AirportName ASC

--Problem 08
SELECT a.Id AS AircraftId,
	   a.Manufacturer,
	   a.FlightHours,
	   COUNT(fd.AirportId) AS FlightDestinationCount,
	   ROUND(AVG(fd.TicketPrice),2) AS AvgPrice
  FROM FlightDestinations AS fd
  JOIN Aircraft AS a ON a.Id = fd.AircraftId
 GROUP BY a.Id, a.Manufacturer, a.FlightHours
 HAVING COUNT(fd.Id) >= 2
 ORDER BY COUNT(fd.AirportId) DESC, a.Id ASC

--Problem 09
SELECT * FROM FlightDestinations WHERE PassengerId = 89
SELECT * FROM Passengers WHERE Id = 89

SELECT p.FullName,
       COUNT(fd.AircraftId) AS CountOfAircraft,
	   SUM(fd.TicketPrice) AS TotalPayed
  FROM FlightDestinations AS fd
  JOIN Passengers AS p ON p.Id = fd.PassengerId
 WHERE p.FullName LIKE '_a%'
 GROUP BY p.FullName
HAVING COUNT(fd.AircraftId) > 1
 ORDER BY p.FullName

--Problem 10
SELECT a.AirportName,
       fd.[Start] AS DayTime,
	   fd.TicketPrice,
	   p.FullName,
	   ac.Manufacturer,
	   ac.Model
  FROM FlightDestinations AS fd
  JOIN Airports AS a ON a.Id = fd.AirportId
  JOIN Passengers AS p ON p.Id = fd.PassengerId
  JOIN Aircraft AS ac ON ac.Id = fd.AircraftId
 WHERE DATEPART(HOUR, [Start]) >= 6 
   AND DATEPART(HOUR, [Start]) <= 20
   AND fd.TicketPrice >= 2500
ORDER BY ac.Model ASC

--Problem 11
CREATE FUNCTION udf_FlightDestinationsByEmail (@email VARCHAR(50))
RETURNS INT AS 
BEGIN
      DECLARE @destinationsCount INT;
	  SET @destinationsCount = (
	      SELECT 
		      COUNT(fd.Id)
		  FROM Passengers AS p
		  JOIN FlightDestinations AS fd ON p.Id = fd.PassengerId
		  WHERE p.Email = @email
		  GROUP BY p.Id
	  );

	  IF @destinationsCount IS NULL 
	     SET @destinationsCount

	  RETURN @destinationsCount

END;

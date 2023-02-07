USE [SoftUni]

--Problem 01
CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
		      AS
		   BEGIN
		         SELECT [FirstName],[LastName]
		           FROM [Employees]
		          WHERE [Salary] > 35000
		     END

--Problem 02
CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL (18, 4)
              AS
           BEGIN
				 SELECT [FirstName], [LastName]
				   FROM [Employees]
				  WHERE [Salary] >= @minSalary
             END

--Problem 03
CREATE PROCEDURE [usp_GetTownsStartingWith] @startingString VARCHAR(50)
			  AS
		   BEGIN
				  SELECT [Name] 
				    FROM [Towns]
			  WHERE LEFT ([Name], LEN(@startingString)) = @startingString
		     END

--Problem 04
CREATE PROCEDURE [usp_GetEmployeesFromTown] @townName VARCHAR(20)
			  AS
		   BEGIN
				 SELECT [e].[FirstName],
				        [e].[LastName]
				   FROM [Employees] AS [e]
			 INNER JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID]
			 INNER JOIN [Towns] AS [t] ON [t].[TownID] = [a].[TownID] 
				  WHERE [t].[Name] = @townName
		     END


--Problem 05
CREATE FUNCTION [ufn_GetSalaryLevel] (@salary DECIMAL (18,4)) 
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(8)
	IF @salary < 30000
	BEGIN
		SET @salaryLevel = 'Low'
	END
	ELSE IF @salary BETWEEN 30000 AND 50000

	BEGIN
		SET @salaryLevel = 'Average'
	END
	ELSE IF @salary > 50000
	BEGIN
		SET @salaryLevel = 'High'
	END

  RETURN @salaryLevel
END
--Problem 07
CREATE OR ALTER FUNCTION [ufn_IsWordComprised](@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @isWordCompromised BIT = 0
    DECLARE @i INT = 1
 
    WHILE @i <= LEN(@word)
    BEGIN
        DECLARE @currentWordLetter CHAR(1) = SUBSTRING(@word, @i, 1)
        DECLARE @j INT = 1
 
        WHILE @j <= LEN(@setOfLetters)
        BEGIN
            DECLARE @currentSetLetter CHAR(1) = SUBSTRING(@setOfLetters, @j, 1)
 
            IF @currentWordLetter = @currentSetLetter
            BEGIN
                SET @isWordCompromised = 1
                BREAK
            END
 
            SET @j += 1
        END
 
        IF @isWordCompromised = 0
        BEGIN
            RETURN 0
        END
 
        SET @isWordCompromised = 0
        SET @i += 1
    END
 
    RETURN 1
END
--Problem 06
CREATE PROCEDURE usp_EmployeesBySalaryLevel (@LevelOfSalary VARCHAR(10))
AS
	SELECT [FirstName],
	[LastName]
	FROM [Employees]
	WHERE [dbo].ufn_GetSalaryLevel ([Salary]) = @LevelOfSalary
--Problem 07
CREATE OR ALTER FUNCTION [ufn_IsWordComprised](@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @isWordCompromised BIT = 0
    DECLARE @i INT = 1
 
    WHILE @i <= LEN(@word)
    BEGIN
        DECLARE @currentWordLetter CHAR(1) = SUBSTRING(@word, @i, 1)
        DECLARE @j INT = 1
 
        WHILE @j <= LEN(@setOfLetters)
        BEGIN
            DECLARE @currentSetLetter CHAR(1) = SUBSTRING(@setOfLetters, @j, 1)
 
            IF @currentWordLetter = @currentSetLetter
            BEGIN
                SET @isWordCompromised = 1
                BREAK
            END
 
            SET @j += 1
        END
 
        IF @isWordCompromised = 0
        BEGIN
            RETURN 0
        END
 
        SET @isWordCompromised = 0
        SET @i += 1
    END
 
    RETURN 1
END
  
SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'Sofia')
--Problem 09
CREATE PROCEDURE usp_GetHoldersFullName
AS
SELECT CONCAT([FirstName], ' ', [LastName]) AS [FullName]
FROM [AccountHolders]

--Problem 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@Number MONEY)
AS
	SELECT [ah].[FirstName], [ah].[LastName]
	FROM 
	(
	SELECT [AccountHolderId], SUM([Balance]) AS [TotalBalance] FROM [Accounts]
	GROUP BY [AccountHolderId]
	)
	AS [data]
JOIN [AccountHolders] AS [ah] ON [data].AccountHolderId = [ah].Id
WHERE [data].TotalBalance > @Number
ORDER BY [ah].FirstName, [ah].LastName

--Problem 11
CREATE FUNCTION ufn_CalculateFutureValue (@Sum MONEY, @Rate FLOAT , @Years INT)
RETURNS MONEY AS
BEGIN
 RETURN @Sum * POWER(1+@Rate,@Years)
END

--Problem 12
CREATE PROC usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT) AS
SELECT a.Id AS [Account Id],
	   ah.FirstName AS [First Name],
	   ah.LastName AS [Last Name],
	   a.Balance,
	   dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5) AS [Balance in 5 years]
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON ah.Id = a.Id
 WHERE a.Id = @AccountId
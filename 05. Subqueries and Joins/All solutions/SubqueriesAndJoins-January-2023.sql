USE [SoftUni]

--Problem 01
SELECT TOP (5) 
           [EmployeeID], 
		   [JobTitle], 
		   [e].[AddressID], 
		   [a].[AddressText]
      FROM [Employees]
        AS [e]
 LEFT JOIN [Addresses] 
        AS [a]
 	    ON [e].[AddressID] = [a].[AddressID]
  ORDER BY [e].[AddressID]

--Problem 02
SELECT TOP (50) 
           [FirstName],
           [LastName],
		   [t].[Name],
		   [a].[AddressText]
      FROM [Employees] 
        AS [e] 
INNER JOIN [Addresses] AS [a] ON [e].[AddressID] = [a].[AddressID]
INNER JOIN [Towns] AS [t] ON [a].[TownID] = [t].[TownID]
  ORDER BY [e].[FirstName], 
           [e].[LastName]

--Problem 03
    SELECT [EmployeeID],
           [FirstName],
           [LastName],
           [d].[Name] 
      FROM [Employees]
        AS [e]
INNER JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
     WHERE [d].[Name] = 'Sales'
  ORDER BY [e].[EmployeeID]
-- DepartmentID for Sales: 3

--Problem 04
SELECT TOP 5 [e].[EmployeeID],
			 [e].[FirstName],
			 [e].[Salary],
			 [d].[Name]
  	    FROM [Employees]
  	      AS [e]
  INNER JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
       WHERE [e].[Salary] >= 15000 
    ORDER BY [e].[DepartmentID] ASC

--Problem 05
SELECT TOP 3 [e].[EmployeeID],
      	     [FirstName]
        FROM [Employees]
          AS [e] 
   LEFT JOIN [EmployeesProjects] 
          ON [e].[EmployeeID] = [EmployeesProjects].[EmployeeID]
       WHERE [EmployeesProjects].[EmployeeID] IS NULL
    ORDER BY [e].[EmployeeID] ASC

--Problem 06
    SELECT [FirstName], 
           [LastName], 
    	   [HireDate], 
    	   [d].[Name]
      FROM [Employees] 
        AS [e]
INNER JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
     WHERE [d].[Name] = 'Sales' OR [d].[Name] = 'Finance' AND [e].[HireDate] >= 1999
  ORDER BY [HireDate] ASC

--Problem 07
SELECT TOP 5 [e].[EmployeeID],
			 [e].[FirstName],
			 [p].[Name]
	    FROM [Employees]
		  AS [e]
  INNER JOIN [EmployeesProjects] AS [ep] ON [e].[EmployeeID] = [ep].[EmployeeID]
  INNER JOIN [Projects] AS [p] ON [ep].[ProjectID] = [p].[ProjectID] 
       WHERE [p].[StartDate] > 
	   (
	   	     SELECT CONVERT(DATE, '13.08.2002', 103)
	   )
	     AND [p].[EndDate] IS NULL
	ORDER BY [e].[EmployeeID] ASC
	
--Problem 08
    SELECT [e].[EmployeeID],
    	   [e].[FirstName],
		   CASE
			   WHEN [p].[StartDate] > '2005'
			   THEN NULL
			   ELSE [p].[Name]
			END AS [ProjectName]
      FROM [Employees] 
        AS [e]
INNER JOIN [EmployeesProjects] AS [ep] ON [e].[EmployeeID] = [ep].[EmployeeID]
INNER JOIN [Projects] AS [p] ON [ep].[ProjectID] = [p].[ProjectID] 
	 WHERE [e].[EmployeeID] = 24

--Problem 09
    SELECT [e].[EmployeeID],
           [e].[FirstName],
   		   [e].[ManagerID],
   		   [m].[FirstName]
      FROM [Employees] AS [e]
INNER JOIN [Employees] AS [m] ON [e].[ManagerID] = [m].[EmployeeID]
     WHERE [e].[ManagerID] = 3 OR [e].[ManagerID] = 7
  ORDER BY [e].[EmployeeID] ASC

--Problem 10
SELECT TOP 50 [e].[EmployeeID],
              CONCAT([e].[FirstName],' ',[e].[LastName]) AS [EmployeeName],
  		      CONCAT([m].[FirstName],' ',[m].[LastName]) AS [ManagerName],
  		      [d].[Name]
  	     FROM [Employees] AS [m] 
   INNER JOIN [Employees] AS [e] ON [e].[ManagerID] = [m].[EmployeeID]
   INNER JOIN [Departments] AS [d] ON [e].[DepartmentID] = [d].[DepartmentID]
     ORDER BY [e].[EmployeeID]

--Problem 11
SELECT MIN([minAverageSalary].[AverageSalary])
FROM 
(
	SELECT AVG([Salary]) AS [AverageSalary]
	FROM [Employees]
	GROUP BY [DepartmentID]
)AS [minAverageSalary]

--Problem 12
USE [Geography]

    SELECT [c].[CountryCode],
    	   [m].[MountainRange],
    	   [p].[PeakName],
    	   [p].[Elevation]
      FROM [Countries] AS [c] 
INNER JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
INNER JOIN [Mountains] AS [m] ON [mc].[MountainId] = [m].[Id]
INNER JOIN [Peaks] AS [p] ON [p].[MountainId] = [m].[Id]
     WHERE [c].[CountryName] = 'Bulgaria'
	   AND [p].[Elevation] > 2835
  ORDER BY [p].[Elevation] DESC


--Problem 13
    SELECT [c].[CountryCode],
      	   COUNT([mc].[MountainId]) AS MountainRanges
      FROM [Countries] AS [c] 
INNER JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
INNER JOIN [Mountains] AS [m] ON [m].[Id] = [mc].[MountainId]
GROUP BY [mc].[CountryCode],
         [c].[CountryCode],
         [CountryName]
HAVING [c].[CountryCode] IN ('US', 'RU', 'BG'); 

--Problem 14
SELECT TOP 5 [CountryName],
      	     [RiverName]
        FROM [Countries] AS [c]
   LEFT JOIN [CountriesRivers] AS [cr] ON [c].[CountryCode] = [cr].[CountryCode]
   LEFT JOIN [Rivers] AS [r] ON [r].[Id] = [cr].[RiverId]
  INNER JOIN [Continents] AS [ct] ON [ct].[ContinentCode] = [c].[ContinentCode]
       WHERE [ct].[ContinentName] = 'Africa'
    ORDER BY [c].[CountryName] ASC

--Problem 16
   SELECT COUNT([c].[CountryCode]) 
     FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc] ON [c].[CountryCode] = [mc].[CountryCode]
    WHERE [mc].[CountryCode] IS NULL
  

--Problem 17
SELECT TOP (5) peaks.CountryName,
               peaks.Elevation AS HighestPeakElevation,
               rivers.Length AS LongestRiverLength
FROM
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS DescendingElevationRank,
           p.Elevation
    FROM Countries AS c
         FULL OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         FULL OUTER JOIN Mountains AS m ON mc.MountainId = m.Id
         FULL OUTER JOIN Peaks AS p ON m.Id = p.MountainId
) AS peaks
FULL OUTER JOIN
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY r.Length DESC) AS DescendingRiversLenghRank,
           r.Length
    FROM Countries AS c
         FULL OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
         FULL OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
) AS rivers ON peaks.CountryCode = rivers.CountryCode
WHERE peaks.DescendingElevationRank = 1
      AND rivers.DescendingRiversLenghRank = 1
      AND (peaks.Elevation IS NOT NULL
           OR rivers.Length IS NOT NULL)
ORDER BY HighestPeakElevation DESC,
         LongestRiverLength DESC,
         CountryName



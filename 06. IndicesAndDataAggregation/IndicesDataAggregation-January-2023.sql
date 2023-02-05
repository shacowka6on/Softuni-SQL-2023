USE [Gringotts]

--Problem 01
SELECT COUNT(Id) AS [Count]
FROM WizzardDeposits 

--Problem 02
SELECT MAX([MagicWandSize]) FROM [WizzardDeposits]

--Problem 03
  SELECT [DepositGroup],
		 MAX([MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--Problem 04
  SELECT [DepositGroup]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]
HAVING AVG([MagicWandSize]) = 
(
	SELECT MIN(WizAvgWandSize.avgWandSize)
	FROM
	(
		SELECT AVG(MagicWandSize) AS avgWandSize
		FROM [WizzardDeposits]
		GROUP BY [DepositGroup]
	) AS WizAvgWandSize
)

--Problem 05
  SELECT [DepositGroup],
		 SUM([DepositAmount]) AS TotalSum
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--Problem 06
  SELECT [DepositGroup],
		 SUM([DepositAmount]) AS TotalSum
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

--Problem 07
SELECT [DepositGroup],
		 SUM([DepositAmount]) AS TotalSum
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family' 
GROUP BY [DepositGroup]
HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

--Problem 08
  SELECT [DepositGroup],
  	     [MagicWandCreator],
  	     MIN([DepositCharge]) AS MinDepositCharge
    FROM [WizzardDeposits] 
GROUP BY [DepositGroup], 
		 [MagicWandCreator]
ORDER BY [MagicWandCreator], 
         [DepositGroup] ASC

--Problem 09
 SELECT CASE
		WHEN [Age] BETWEEN 0 AND 10
		THEN '[0-11]'
		WHEN [Age] BETWEEN 11 AND 20
		THEN '[11-20]'
		WHEN [Age] BETWEEN 21 AND 30
		THEN '[21-30]'
		WHEN [Age] BETWEEN 31 AND 40
		THEN '[31-40]'
		WHEN [Age] BETWEEN 41 AND 50
		THEN '[41-50]'
		WHEN [Age] BETWEEN 51 AND 60
		THEN '[51-60]'
		WHEN [Age] > 60
		THEN '[61+]'
		ELSE 'N\A'
	  END AS [AgeGroup],
 COUNT(*) AS [WizzardsCount]
	    FROM [WizzardDeposits] AS [w]
GROUP BY CASE
		 WHEN [w].[Age] BETWEEN 0 AND 10
		 THEN '[0-11]'
		 WHEN [w].[Age] BETWEEN 11 AND 20
		 THEN '[11-20]'
		 WHEN [w].[Age] BETWEEN 21 AND 30
		 THEN '[21-30]'
		 WHEN [w].[Age] BETWEEN 31 AND 40
		 THEN '[31-40]'
		 WHEN [w].[Age] BETWEEN 41 AND 50
		 THEN '[41-50]'
		 WHEN [w].[Age] BETWEEN 51 AND 60
		 THEN '[51-60]'
		 WHEN [w].[Age] > 60
		 THEN '[61+]'
		 ELSE 'N\A'
	  END

--Problem 10
SELECT LEFT([FirstName], 1) AS [FirstLetter]
  FROM [WizzardDeposits] 
WHERE [DepositGroup] = 'Troll Chest'
GROUP BY LEFT([FirstName], 1)
ORDER BY [FirstLetter] ASC

--Problem 11
  SELECT [DepositGroup],
  	     [IsDepositExpired],
  	     AVG([DepositInterest]) AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '01/01/1985'
GROUP BY [DepositGroup],
		 [IsDepositExpired]
ORDER BY [DepositGroup] DESC,
		 [IsDepositExpired]

--Problem 13
USE [SoftUni]

  SELECT [DepartmentID],
  	     SUM([Salary]) AS [TotalSalary]
    FROM [Employees] 
GROUP BY [DepartmentID]

--Problem 14
  SELECT [DepartmentID],
  	     MIN([Salary]) AS [MinimumSalary]
    FROM [Employees]
   WHERE [DepartmentID] IN (2,5,7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]

--Problem 15
SELECT *
INTO NewTable
FROM Employees
WHERE Salary > 30000;

DELETE FROM NewTable
WHERE ManagerID = 42;

UPDATE NewTable
  SET
      Salary += 5000
WHERE DepartmentID = 1;

SELECT DepartmentID,
       AVG(Salary)
FROM NewTable
GROUP BY DepartmentID

--Problem 16
  SELECT [DepartmentID],
	     MAX([Salary]) AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

--Problem 17
SELECT COUNT([EmployeeID]) AS [Count]
  FROM [Employees]
 WHERE [ManagerID] IS NULL


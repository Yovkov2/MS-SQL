USE SoftUni

--01 
SELECT TOP(5) 
 e.EmployeeID, e.JobTitle, e.AddressID, AddressText
FROM 
Employees AS e
JOIN Addresses AS ad ON ad.AddressID = e.AddressID
ORDER BY AddressID
--02
SELECT TOP(50) 
 e.FirstName, e.LastName, t.[Name], ad.AddressText
FROM 
Employees AS e
JOIN Addresses AS ad ON ad.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = ad.TownID
ORDER BY FirstName, LastName
--03
SELECT EmployeeID, FirstName, LastName, [Name]
FROM Employees AS e
JOIN Departments AS dp ON dp.DepartmentID = e.DepartmentID
WHERE [Name] = 'Sales'
ORDER BY EmployeeID
--04
SELECT TOP(5)
EmployeeID, FirstName, Salary, [Name]
FROM Employees AS e
JOIN Departments AS dp ON dp.DepartmentID = e.DepartmentID
WHERE Salary > 15000
ORDER BY e.DepartmentID
--05
WITH EmployeesWithoutProjects AS (
	SELECT e.EmployeeID, FirstName
	FROM Employees AS e
	EXCEPT
	SELECT e.EmployeeID, FirstName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID)

SELECT TOP(3) EmployeeID, FirstName
FROM EmployeesWithoutProjects 
--06
SELECT FirstName, LastName, HireDate, dp.[Name]
FROM Employees AS e
JOIN Departments AS dp ON dp.DepartmentID = e.DepartmentID
WHERE HireDate > '1.1.1999' AND 
[Name] IN ('Sales', 'Finance')
ORDER BY HireDate
--07
SELECT TOP(5)
	e.EmployeeID, FirstName, [Name] AS [ProjectName]
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE StartDate > '2002-08-13' AND
	EndDate IS NULL
ORDER BY 
	e.EmployeeID
--08
SELECT TOP(5)
	e.EmployeeID, FirstName, [Name] =
CASE
	WHEN DATEPART(YEAR, StartDate) > 2004 THEN NULL
	ELSE [Name]
END
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24
--09
SELECT 
	emp.EmployeeID, emp.FirstName, mgr.EmployeeID, mgr.FirstName
FROM Employees AS emp
JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
WHERE
	emp.ManagerID IN (3, 7)
ORDER BY
	emp.EmployeeID
--10
SELECT TOP(50)
	emp.EmployeeID,
	CONCAT_WS(' ', emp.FirstName, emp.LastName) AS EmployeeName,
	CONCAT_WS(' ', mgr.FirstName, mgr.LastName) AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees AS emp
JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
JOIN Departments AS d on d.DepartmentID = emp.DepartmentID
ORDER BY emp.EmployeeID
--11
SELECT TOP 1 AVG(SALARY) AS 'MinAverageSalary'
FROM Employees
GROUP BY
	DepartmentID
ORDER BY MinAverageSalary

USE Geography
--12
SELECT	c.CountryCode
		,m.MountainRange
		,p.PeakName
		,p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON p.MountainId = mc.MountainId
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC
--13
SELECT mc.CountryCode, COUNT(m.MountainRange)
FROM Mountains AS m
JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
WHERE mc.CountryCode IN ('BG', 'RU', 'US')
GROUP BY mc.CountryCode
--14
SELECT TOP 5
	   c.CountryName
	  ,r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
LEFT JOIN Continents AS cn ON cn.ContinentCode = c.ContinentCode
WHERE cn.ContinentName = 'Africa'
ORDER BY c.CountryName
--15
SELECT [ContinentCode]
	  ,[CurrencyCode]
	  ,[CurrencyUsage]
FROM 
	(
			SELECT *,
				DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY CurrencyUsage DESC)
			AS [CurrencyRank]
			FROM
		 (
		     SELECT 
		    	 [ContinentCode]
		    	 ,[CurrencyCode]
		    	 ,COUNT(*) AS CurrencyUsage
		    FROM Countries
		    GROUP BY [ContinentCode], [CurrencyCode]
		    HAVING COUNT(*) > 1
		)
			AS [CurrencyUsageSubquery]
	)
	AS [CurrencyRankingSubquery]
	WHERE [CurrencyRank] = 1
--16
SELECT
	COUNT(c.[CountryCode]) AS [Count]
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
WHERE mc.MountainId IS NULL
--17
SELECT	TOP 5
		c.CountryName
	  ,MAX(p.Elevation) AS HighestPeakElevation
	  ,MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId
WHERE p.Elevation IS NOT NULL AND r.[Length] IS NOT NULL
GROUP BY c.CountryName 
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC
--18
SELECT TOP 5 [CountryName] AS Country,
		CASE 
		  WHEN [PeakName] IS NULL THEN '(no highest peak)'   --  
		  ELSE PeakName									      
		  END											      
		  AS [Highest Peak Name],						      
		CASE 											      
		  WHEN [Elevation] IS NULL THEN 0				     
		  ELSE [Elevation]								      
		  END											      
		  AS [Highest Peak Elevation],					      
		CASE											      
		  WHEN [MountainRange] IS NULL THEN '(no mountain)'	 
		  ELSE [MountainRange]
		  END
		  AS [Mountain]
FROM 
	(
		SELECT c.CountryName 
		  ,p.PeakName
		  ,p.Elevation
		  ,m.MountainRange
		  ,DENSE_RANK() OVER(PARTITION BY c.[CountryName] ORDER BY p.[Elevation] DESC) AS PeakRank
		FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks AS p ON p.MountainId = m.Id		
	)
	AS [RankingSubquery]
WHERE PeakRank = 1
ORDER BY Country, [Highest Peak Name]
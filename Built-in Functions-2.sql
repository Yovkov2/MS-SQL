--10
USE SoftUni
SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER
(PARTITION BY SALARY ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC
--11
WITH CTE_RankesEmployees AS
(
 SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER
(PARTITION BY SALARY ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
)
SELECT * 
FROM CTE_RankesEmployees 
WHERE [Rank] = 2
ORDER BY Salary DESC
--12
USE Geography
SELECT CountryName, IsoCode 
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode
--13
SELECT PeakName, RiverName,
LOWER(CONCAT(SUBSTRING(PeakName, 1, LEN(PeakName)-1), RiverName)) AS Mix
FROM PEAKS,Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY MIX
--14
USE Diablo
SELECT (50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM Games
WHERE DATEPART(YEAR, [Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name]
--15
SELECT Username,
SUBSTRING(Email, CHARINDEX('@',Email) + 1, LEN(Email)) AS EmailProvider
FROM Users
ORDER BY EmailProvider, Username
--16
SELECT Username, IpAddress
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username
--17
SELECT [Name], [Part of the Day] =
	CASE
		WHEN DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
		ELSE 'Evening'
	END, 
	[Duration2] = 
	CASE
		WHEN [Duration] <= 3 THEN 'Extra Short'
		WHEN [Duration] <= 6 THEN 'Short'
		WHEN [Duration] > 6 THEN 'Long'
		ELSE 'Extra Long'
	END, Duration
FROM Games
ORDER BY [Name], [Duration], [Part of the Day]
--18
CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	ProductName VARCHAR(60),
	OrderDate DATETIME2
)

INSERT INTO Orders VALUES ('Butter', GETDATE()),
							('Milk', GETDATE()),
							('Honey', GETDATE())

SELECT ProductName, OrderDate,
	DATEADD(DAY, 3, OrderDate) AS [Pay Due],
	DATEADD(MONTH, 1, OrderDate) AS [Delivery Due]
FROM Orders
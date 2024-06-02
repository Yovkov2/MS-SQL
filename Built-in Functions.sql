--01
USE SoftUni
GO

SELECT FirstName, LastName 
FROM Employees
WHERE FirstName LIKE 'Sa%'
--02
SELECT FirstName, LastName 
FROM Employees
WHERE LastName LIKE '%EI%'
--03
SELECT FirstName
FROM Employees
WHERE DepartmentID = 3 OR DepartmentID = 10 AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005
--04
SELECT FirstName, LastName 
FROM Employees
WHERE JobTitle NOT LIKE '%ENGINEER%'
--05
SELECT [Name]
FROM Towns
WHERE LEN([Name]) BETWEEN 5 AND 6
ORDER BY [Name]
--06
SELECT TownID, [Name]
FROM Towns
WHERE [Name] LIKE '[M,K,B,E]%'
ORDER BY [Name]
--07
SELECT TownID, [Name]
FROM Towns
WHERE [Name] NOT LIKE '[R,B,D]%'
ORDER BY [Name]
--08
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000 
--09
SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5
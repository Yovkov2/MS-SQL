-- 13 Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID
--14 Employees Minimum SalariesSELECT DepartmentID, MIN(Salary) AS MinimumSalaryFROM EmployeesWHERE  DepartmentID IN (2,5,7) AND HireDate > '2000-01-01' GROUP BY DepartmentID--15 Employees Average Salaries
CREATE TABLE HighEarners AS
SELECT *
FROM Employees
WHERE Salary > 30000;

DELETE FROM HighEarners
WHERE ManagerID = 42;

UPDATE HighEarners
SET Salary = Salary + 5000
WHERE DepartmentID = 1;

SELECT 
    DepartmentID, 
    AVG(Salary) AS AverageSalary
FROM 
    HighEarners
GROUP BY 
    DepartmentID;
--16 Employees Maximum SalariesSELECT DepartmentID, MAX(Salary) AS MaxSalaryFROM EmployeesWHERE Salary < 30000 OR Salary > 70000GROUP BY DepartmentID--17 Employees Count SalariesSELECT COUNT(Salary) AS CountOfSalaries
FROM Employees
WHERE ManagerID IS NULL;
--18. *3rd Highest SalaryWITH RankedSalaries AS (
    SELECT 
        DepartmentID,
        Salary,
        DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
    FROM 
        Employees
)

SELECT 
    DepartmentID,
    Salary AS ThirdHighestSalary
FROM 
    RankedSalaries
WHERE 
    SalaryRank = 3;
--19. **Salary ChallengeSELECT TOP 10 
    FirstName, 
    LastName, 
    DepartmentID
FROM 
    Employees
WHERE 
    Salary > (
        SELECT AVG(Salary)
        FROM Employees AS e
        WHERE e.DepartmentID = Employees.DepartmentID
    )
ORDER BY 
    DepartmentID;
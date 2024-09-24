-- 13 Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID
--14 Employees Minimum Salaries
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
--16 Employees Maximum Salaries
FROM Employees
WHERE ManagerID IS NULL;
--18. *3rd Highest Salary
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
--19. **Salary Challenge
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
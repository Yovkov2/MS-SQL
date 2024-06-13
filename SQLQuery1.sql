--18 JUDJE IS JOKE
WITH RankedSalaries AS (
    SELECT 
        DepartmentID, 
        Salary,
        ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS rank
    FROM Employees
)
SELECT TOP(3)
    DepartmentID,
    Salary AS ThirdHighestSalary
FROM RankedSalaries
WHERE [rank] = 3
ORDER BY DepartmentID;
--19
WITH DepartmentAverages AS (
    SELECT 
        DepartmentID, 
        AVG(Salary) AS AvgSalary
    FROM 
        Employees
    GROUP BY 
        DepartmentID
)
SELECT TOP(10)
    e.FirstName,
    e.LastName,
    e.DepartmentID
FROM 
    Employees e
JOIN 
    DepartmentAverages da ON e.DepartmentID = da.DepartmentID
WHERE 
    e.Salary > da.AvgSalary
ORDER BY 
    e.DepartmentID

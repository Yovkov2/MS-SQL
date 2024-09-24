--1. Records' Count
USE Gringotts
SELECT COUNT(*) FROM WizzardDeposits AS COUNT
--2 Longest Magic Wand
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup;
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING TotalSum < 150000
ORDER BY TotalSum;
    CASE 
        WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]' 
    END AS AgeGroup,
    COUNT(*) AS WizardCount
FROM WizzardDeposits
GROUP BY AGE
ORDER BY MIN(Age);
FROM WizzardDeposits
WHERE DepositInterest = 'Troll Chest'
GROUP BY FirstLetter
ORDER BY FirstLetter;
    DepositGroup, 
    CASE 
        WHEN IsDepositExpired = 1 THEN 'Expired' 
        ELSE 'Not Expired' 
    END AS ExpirationStatus,
    AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC;
FROM WizzardDeposits AS CurrentWizard
JOIN WizzardDeposits AS NextWizard 
    ON CurrentWizard.Id = NextWizard.Id - 1;
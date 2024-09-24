--1. Records' Count
USE Gringotts
SELECT COUNT(*) FROM WizzardDeposits AS COUNT
--2 Longest Magic WandSELECT MAX(MagicWandSize)FROM WizzardDeposits AS LongestMagicWand--3 Longest Magic Wand Per Deposit GroupsSELECT MagicWandCreator, MAX(MagicWandSize) AS LongestMagicWandFROM WizzardDeposits GROUP BY MagicWandCreator--4  Smallest Deposit Group Per Magic Wand SizeSELECT DepositGroup, AVG(MagicWandSize) AS AverageWandSizeFROM WizzardDepositsGROUP BY DepositGroupORDER BY AverageWandSize--5  Deposits SumSELECT DepositGroup, SUM(DepositAmount) AS TotalSumFROM WizzardDepositsGROUP BY DepositGroup--6 Deposits Sum for Ollivander FamilySELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup;--7 Deposits FilterSELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING TotalSum < 150000
ORDER BY TotalSum;--8  Deposit ChargeSELECT DepositGroup, MagicWandCreator, MIN(DepositCharge)FROM WizzardDepositsGROUP BY DepositGroup, MagicWandCreatorORDER BY DepositGroup, MagicWandCreator--9  Age GroupsSELECT 
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
ORDER BY MIN(Age);--10  First LetterSELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositInterest = 'Troll Chest'
GROUP BY FirstLetter
ORDER BY FirstLetter;--11  Average Interest SELECT 
    DepositGroup, 
    CASE 
        WHEN IsDepositExpired = 1 THEN 'Expired' 
        ELSE 'Not Expired' 
    END AS ExpirationStatus,
    AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC;--12  *Rich Wizard, Poor WizardSELECT SUM(NextWizard.DepositAmount - CurrentWizard.DepositAmount) AS TotalDifference
FROM WizzardDeposits AS CurrentWizard
JOIN WizzardDeposits AS NextWizard 
    ON CurrentWizard.Id = NextWizard.Id - 1;
/*
===========================================================
SQL Server Window Functions Series
Episode 2 - LEAD & LAG Window Functions
===========================================================
*/

DROP TABLE IF EXISTS EmployeeSalary;
-- =========================================================
-- 1. Create Sample Table
-- =========================================================

CREATE TABLE EmployeeSalary
(
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Salary INT,
    SalaryDate DATE
);

-- =========================================================
-- 2. Insert Sample Data
-- =========================================================

INSERT INTO EmployeeSalary
VALUES
(101, 'John', 50000, '2024-01-01'),
(101, 'John', 55000, '2024-06-01'),
(101, 'John', 60000, '2025-01-01'),
(102, 'David', 45000, '2024-01-01'),
(102, 'David', 50000, '2024-07-01'),
(102, 'David', 58000, '2025-01-01');

-- =========================================================
-- 3. View the Data
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate
FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 4. LAG - Get Previous Salary
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate,
    LAG(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS PreviousSalary
FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 5. LAG - Calculate Salary Increase
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate,
    LAG(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS PreviousSalary,
    Salary -
    LAG(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS SalaryIncrease
FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 6. LEAD - Get Next Salary
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate,
    LEAD(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS NextSalary
FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 7. LEAD + LAG Together
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate,

    LAG(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS PreviousSalary,

    LEAD(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS NextSalary

FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 8. Practical Example - Current vs Previous Salary
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary AS CurrentSalary,
    LAG(Salary)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS PreviousSalary
FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- 9. LAG / LEAD with Offset
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    SalaryDate,

    LAG(Salary, 2)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS SalaryTwoRowsBack,

    LEAD(Salary, 2)
        OVER
        (
            PARTITION BY EmployeeID
            ORDER BY SalaryDate
        ) AS SalaryTwoRowsAhead

FROM EmployeeSalary
ORDER BY EmployeeID, SalaryDate;


-- =========================================================
-- Cleanup
-- =========================================================

DROP TABLE EmployeeSalary;

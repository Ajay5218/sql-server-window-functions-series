/*
============================================================
SQL Server Tutorial Series - Episode 4
Title: SQL GROUP BY Explained | COUNT, SUM, AVG, MIN, MAX & HAVING
Channel: Ajay Kumar | SQL & Data Engineering
============================================================

IMPORTANT:
This episode uses a NEW table: EmployeeDepartmentSalary

The EmployeeSalary table from previous episodes is NOT
dropped, altered, or replaced.

Run the sections individually while following the video.
SQL Server | T-SQL
============================================================
*/

SET NOCOUNT ON;

-- =========================================================
-- 1. CREATE A NEW TABLE FOR EPISODE 4
-- =========================================================

DROP TABLE IF EXISTS EmployeeDepartmentSalary;

CREATE TABLE EmployeeDepartmentSalary
(
    EmployeeID   INT,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       INT
);

-- =========================================================
-- 2. INSERT SAMPLE DATA
-- =========================================================

INSERT INTO EmployeeDepartmentSalary
(
    EmployeeID,
    EmployeeName,
    Department,
    Salary
)
VALUES
(101, 'John',   'IT',      90000),
(102, 'David',  'IT',      85000),
(103, 'Mike',   'IT',      85000),
(104, 'Sarah',  'IT',      75000),
(105, 'Emma',   'HR',      80000),
(106, 'Olivia', 'HR',      80000),
(107, 'James',  'HR',      70000),
(108, 'Robert', 'Finance', 95000),
(109, 'Daniel', 'Finance', 90000),
(110, 'Chris',  'Finance', 90000),
(111, 'Alex',   'Finance', 75000);

-- =========================================================
-- 3. VIEW THE SAMPLE DATA
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM EmployeeDepartmentSalary
ORDER BY Department, Salary DESC;

-- =========================================================
-- 4. GROUP BY + COUNT()
-- =========================================================

SELECT
    Department,
    COUNT(*) AS EmployeeCount
FROM EmployeeDepartmentSalary
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 5. GROUP BY + SUM()
-- =========================================================

SELECT
    Department,
    SUM(Salary) AS TotalSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 6. GROUP BY + AVG()
-- =========================================================

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 7. GROUP BY + MIN() + MAX()
-- =========================================================

SELECT
    Department,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 8. COMBINE MULTIPLE AGGREGATE FUNCTIONS
-- =========================================================

SELECT
    Department,
    COUNT(*) AS EmployeeCount,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary,
    MIN(Salary) AS MinimumSalary,
    MAX(Salary) AS MaximumSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 9. COMMON GROUP BY ERROR
--    EmployeeName is not grouped or aggregated.
-- =========================================================

/*
SELECT
    Department,
    EmployeeName,
    COUNT(*) AS EmployeeCount
FROM EmployeeDepartmentSalary
GROUP BY Department;
*/

-- =========================================================
-- 10. CORRECTED VERSION
-- =========================================================

SELECT
    Department,
    EmployeeName,
    COUNT(*) AS EmployeeCount
FROM EmployeeDepartmentSalary
GROUP BY
    Department,
    EmployeeName
ORDER BY
    Department,
    EmployeeName;

-- =========================================================
-- 11. HAVING
--     Filter groups based on an aggregate calculation.
-- =========================================================

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
HAVING AVG(Salary) > 80000
ORDER BY AverageSalary DESC;

-- =========================================================
-- 12. WHERE + GROUP BY
--     WHERE filters rows before grouping.
-- =========================================================

SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM EmployeeDepartmentSalary
WHERE Salary > 70000
GROUP BY Department
ORDER BY Department;

-- =========================================================
-- 13. PRACTICAL EXAMPLE
--     Departments with at least 3 employees
--     and total salary above 250,000.
-- =========================================================

SELECT
    Department,
    COUNT(*) AS EmployeeCount,
    SUM(Salary) AS TotalSalary
FROM EmployeeDepartmentSalary
GROUP BY Department
HAVING COUNT(*) >= 3
   AND SUM(Salary) > 250000
ORDER BY TotalSalary DESC;

-- =========================================================
-- 14. QUICK REFERENCE
-- =========================================================

/*
GROUP BY  -> Creates groups
COUNT(*)  -> Counts rows
SUM()     -> Adds values
AVG()     -> Calculates average
MIN()     -> Lowest value
MAX()     -> Highest value
WHERE     -> Filters rows before grouping
HAVING    -> Filters groups after grouping
*/

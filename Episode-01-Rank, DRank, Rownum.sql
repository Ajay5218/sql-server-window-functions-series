/*
===========================================================
SQL Server Window Functions Series
Episode 1 - ROW_NUMBER, RANK & DENSE_RANK
===========================================================

This script accompanies:
Episode 1 - SQL Server Window Functions Explained
ROW_NUMBER, RANK & DENSE_RANK

Run the sections individually while following the video.
===========================================================
*/

-- =========================================================
-- 1. Create Sample Employee Data
-- =========================================================

DROP TABLE IF EXISTS EmployeeSalary;

CREATE TABLE EmployeeSalary
(
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);

-- =========================================================
-- 2. Insert Sample Data
-- =========================================================

INSERT INTO EmployeeSalary
(
    EmployeeID,
    EmployeeName,
    Department,
    Salary
)
VALUES
(101, 'John',  'IT',        90000),
(102, 'David', 'IT',        85000),
(103, 'Mike',  'IT',        85000),
(104, 'Sarah', 'IT',        75000),
(105, 'Emma',  'HR',        80000),
(106, 'Olivia','HR',        80000),
(107, 'James', 'HR',        70000),
(108, 'Robert','Finance',   95000),
(109, 'Daniel','Finance',   90000),
(110, 'Chris', 'Finance',   90000),
(111, 'Alex',  'Finance',   75000);

-- =========================================================
-- 3. View the Sample Data
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM EmployeeSalary
ORDER BY Department, Salary DESC;


-- =========================================================
-- 4. ROW_NUMBER()
--    Assigns a unique sequential number to every row.
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER()
        OVER
        (
            ORDER BY Salary DESC
        ) AS RowNumber
FROM EmployeeSalary
ORDER BY Salary DESC;


-- =========================================================
-- 5. ROW_NUMBER() with PARTITION BY
--    Ranking starts again for each department.
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS RowNumber
FROM EmployeeSalary
ORDER BY Department, Salary DESC;


-- =========================================================
-- 6. RANK()
--    Employees with the same salary receive the same rank.
--    Gaps are created after ties.
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    RANK()
        OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryRank
FROM EmployeeSalary
ORDER BY Salary DESC;


-- =========================================================
-- 7. RANK() with PARTITION BY
--    Rank employees within each department.
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    RANK()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryRank
FROM EmployeeSalary
ORDER BY Department, Salary DESC;


-- =========================================================
-- 8. DENSE_RANK()
--    Same salary = same rank, but no gaps after ties.
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    DENSE_RANK()
        OVER
        (
            ORDER BY Salary DESC
        ) AS SalaryDenseRank
FROM EmployeeSalary
ORDER BY Salary DESC;


-- =========================================================
-- 9. DENSE_RANK() with PARTITION BY
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    DENSE_RANK()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryDenseRank
FROM EmployeeSalary
ORDER BY Department, Salary DESC;


-- =========================================================
-- 10. Compare ROW_NUMBER, RANK and DENSE_RANK
-- =========================================================

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,

    ROW_NUMBER()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS RowNumber,

    RANK()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryRank,

    DENSE_RANK()
        OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS DenseSalaryRank

FROM EmployeeSalary
ORDER BY Department, Salary DESC;


-- =========================================================
-- 11. Practical Example - Find the Highest Paid Employee
--     in Each Department using ROW_NUMBER()
-- =========================================================

WITH RankedEmployees AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        ROW_NUMBER()
            OVER
            (
                PARTITION BY Department
                ORDER BY Salary DESC
            ) AS RowNumber
    FROM EmployeeSalary
)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM RankedEmployees
WHERE RowNumber = 1
ORDER BY Department;


-- =========================================================
-- 12. Practical Example - Find Top 2 Salaries
--     in Each Department using DENSE_RANK()
-- =========================================================

WITH RankedEmployees AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        DENSE_RANK()
            OVER
            (
                PARTITION BY Department
                ORDER BY Salary DESC
            ) AS SalaryRank
    FROM EmployeeSalary
)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    SalaryRank
FROM RankedEmployees
WHERE SalaryRank <= 2
ORDER BY Department, Salary DESC;


-- =========================================================
-- QUICK REFERENCE
-- =========================================================

/*
ROW_NUMBER()
-------------
Always gives a unique sequential number.

Example:
1
2
3
4


RANK()
------
Same value = same rank.
Gaps are created after ties.

Example:
1
2
2
4


DENSE_RANK()
------------
Same value = same rank.
No gaps are created after ties.

Example:
1
2
2
3


Easy way to remember:

ROW_NUMBER  -> Unique number for every row
RANK        -> Same rank + gaps after ties
DENSE_RANK  -> Same rank + no gaps
*/


-- =========================================================
-- CLEANUP
-- =========================================================
-- Uncomment the following line if you want to remove
-- the sample table after completing the exercises.

-- DROP TABLE IF EXISTS EmployeeSalary;

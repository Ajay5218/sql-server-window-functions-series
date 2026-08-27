/*
=====================================================================
    SQL Server Window Functions - Episode 3
    NTILE()

    Business Example:
    Employee Salary Distribution
=====================================================================
*/


/*
=====================================================================
    1. CREATE SAMPLE TABLE
=====================================================================
*/

DROP TABLE IF EXISTS #Employees;

CREATE TABLE #Employees
(
    EmployeeID   INT,
    EmployeeName VARCHAR(50),
    Department   VARCHAR(50),
    Salary       INT
);


/*
=====================================================================
    2. INSERT SAMPLE DATA

    15 employees across 3 departments.
=====================================================================
*/

INSERT INTO #Employees
(
    EmployeeID,
    EmployeeName,
    Department,
    Salary
)
VALUES
(1,  'John',   'IT',       95000),
(2,  'Sarah',  'IT',       85000),
(3,  'Mike',   'IT',       75000),
(4,  'David',  'IT',       65000),
(5,  'Tom',    'IT',       62000),

(6,  'Emma',   'HR',       90000),
(7,  'James',  'HR',       80000),
(8,  'Lisa',   'HR',       70000),
(9,  'Robert', 'HR',       60000),
(10, 'Kevin',  'HR',       55000),

(11, 'Anna',   'Finance',  88000),
(12, 'Chris',  'Finance',  78000),
(13, 'Mark',   'Finance',  68000),
(14, 'Laura',  'Finance',  58000),
(15, 'Nina',   'Finance',  52000);


/*
=====================================================================
    3. VIEW THE SOURCE DATA
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM #Employees
ORDER BY Salary DESC;


/*
=====================================================================
    4. BASIC NTILE()

    Divide all employees into 4 salary groups.

    NTILE(4) → creates 4 groups
    ORDER BY Salary DESC → highest salary comes first
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    NTILE(4) OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryQuartile
FROM #Employees
ORDER BY Salary DESC;


/*
=====================================================================
    5. UNEVEN DISTRIBUTION

    15 rows cannot be divided equally into 4 groups.

    NTILE() distributes the rows as evenly as possible.

    Result:
        Group 1 → 4 rows
        Group 2 → 4 rows
        Group 3 → 4 rows
        Group 4 → 3 rows
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Salary,
    NTILE(4) OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryQuartile
FROM #Employees
ORDER BY Salary DESC;


/*
=====================================================================
    6. NTILE() WITH PARTITION BY

    Divide employees into 4 salary groups within each department.

    PARTITION BY Department means the NTILE calculation
    restarts for every department.
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    NTILE(4) OVER
    (
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS DepartmentQuartile
FROM #Employees
ORDER BY
    Department,
    Salary DESC;


/*
=====================================================================
    7. PRACTICAL BUSINESS USE CASE

    Business Question:
    Who belongs to the top salary quartile within each department?

    NTILE(4) divides each department into 4 groups.
    We then filter for Quartile 1.
=====================================================================
*/

WITH EmployeeQuartiles AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        NTILE(4) OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryQuartile
    FROM #Employees
)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    SalaryQuartile
FROM EmployeeQuartiles
WHERE SalaryQuartile = 1
ORDER BY
    Department,
    Salary DESC;


/*
=====================================================================
    8. FINAL EXAMPLE

    Add a business-friendly category to the quartile.

        1 → Top 25%
        2 → 25% - 50%
        3 → 50% - 75%
        4 → Bottom 25%
=====================================================================
*/

WITH EmployeeSalaryDistribution AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        NTILE(4) OVER
        (
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS SalaryQuartile
    FROM #Employees
)
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    SalaryQuartile,
    CASE SalaryQuartile
        WHEN 1 THEN 'Top 25%'
        WHEN 2 THEN '25% - 50%'
        WHEN 3 THEN '50% - 75%'
        WHEN 4 THEN 'Bottom 25%'
    END AS SalaryCategory
FROM EmployeeSalaryDistribution
ORDER BY
    Department,
    Salary DESC;


/*
=====================================================================
    KEY TAKEAWAY

    NTILE(n) divides ordered rows into n approximately equal groups.

    NTILE() is useful for:
        - Quartile analysis
        - Salary distribution
        - Customer segmentation
        - Performance bands
        - Top/bottom percentage groups
=====================================================================
*/
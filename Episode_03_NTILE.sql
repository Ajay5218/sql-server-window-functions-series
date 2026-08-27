/*
=====================================================================
    SQL Server Window Functions - Episode 3
    NTILE()

    Topic:
    Dividing rows into approximately equal groups

    Business Example:
    Employee salary distribution / quartiles
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

    Before using NTILE(), let's look at the employees and salaries.
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

    NTILE(4) divides the ordered rows into 4 groups.

    ORDER BY Salary DESC means the highest-paid employees
    are placed into the first group.

    SalaryQuartile:
        1 → Highest salary group
        2 → Upper-middle salary group
        3 → Lower-middle salary group
        4 → Lowest salary group
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
    5. CHANGING THE NUMBER OF GROUPS

    The number passed to NTILE() determines the number of groups.

        NTILE(2) → 2 groups
        NTILE(4) → 4 groups
        NTILE(5) → 5 groups

    Here we divide employees into 2 salary groups.
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    NTILE(2) OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryGroup
FROM #Employees
ORDER BY Salary DESC;


/*
=====================================================================
    6. UNEVEN DISTRIBUTION

    We have 15 employees and want 4 groups.

        15 / 4 = 3 remainder 3

    NTILE() distributes the rows as evenly as possible.

        Group 1 → 4 rows
        Group 2 → 4 rows
        Group 3 → 4 rows
        Group 4 → 3 rows

    The extra rows are assigned to the earlier groups.
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
    7. NTILE() WITH PARTITION BY

    Without PARTITION BY:
        All employees are divided into 4 groups.

    With PARTITION BY Department:
        Employees are divided into 4 groups within each department.

    The NTILE() calculation restarts for every department.
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
    8. FIND THE TOP QUARTILE WITHIN EACH DEPARTMENT

    Business Question:
        Who belongs to the top salary quartile in each department?

    Step 1:
        Calculate the quartile using NTILE(4).

    Step 2:
        Filter for SalaryQuartile = 1.
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
    9. NTILE() VS ROW_NUMBER() VS RANK()

    ROW_NUMBER():
        Gives every row a unique sequential number.

    RANK():
        Gives rows a ranking based on the ORDER BY value.
        Tied values receive the same rank.

    NTILE():
        Divides ordered rows into a specified number of groups.
=====================================================================
*/

SELECT
    EmployeeID,
    EmployeeName,
    Salary,

    ROW_NUMBER() OVER
    (
        ORDER BY Salary DESC
    ) AS RowNumber,

    RANK() OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryRank,

    NTILE(4) OVER
    (
        ORDER BY Salary DESC
    ) AS SalaryQuartile

FROM #Employees
ORDER BY Salary DESC;


/*
=====================================================================
    10. ADD BUSINESS-FRIENDLY CATEGORY LABELS

    Convert the numeric quartile into a meaningful category.
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

FROM EmployeeQuartiles
ORDER BY Salary DESC;


/*
=====================================================================
    11. CAPSTONE EXAMPLE

    Business Question:
        Within each department, classify employees into salary
        quartiles and assign a business-friendly category.

    Concepts used:
        - NTILE()
        - PARTITION BY
        - ORDER BY
        - CTE
        - CASE
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
    KEY TAKEAWAYS

    1. NTILE(n) divides ordered rows into n groups.

    2. NTILE() distributes rows as evenly as possible.

    3. NTILE(4) can be used for quartile-style analysis.

    4. PARTITION BY creates separate NTILE() calculations
       within each group.

    5. NTILE() groups rows; it does not assign a unique rank.

    6. ROW_NUMBER(), RANK(), and NTILE() solve different problems.
=====================================================================
*/
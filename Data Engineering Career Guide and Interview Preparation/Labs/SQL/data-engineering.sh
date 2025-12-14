-- Step 1: Identify duplicate employee entries
SELECT First_Name, Last_Name, COUNT(*) AS row_count
FROM Employees
GROUP BY First_Name, Last_Name
HAVING COUNT(*) > 1;

-- Step 2: Create a CTE to identify duplicates by keeping the lowest EMP_ID
CREATE TABLE my_cte (
    Emp_ID VARCHAR(100),
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Row_Num INT
) AS
(
    SELECT Emp_ID, First_Name, Last_Name,
           ROW_NUMBER() OVER (PARTITION BY First_Name, Last_Name ORDER BY Emp_ID) AS Row_Num
    FROM Employees
);

-- Step 3: Display duplicate records (Row_Num > 1)
SELECT * FROM my_cte WHERE Row_Num > 1;

-- Step 4: Delete duplicate by EMP_ID (replace E04713 with actual duplicate IDs if needed)
DELETE FROM Employees
WHERE Emp_ID = 'E04713';

-- Step 5: Data transformation - Rename column Salary to Annual_Income
ALTER TABLE Salary
RENAME COLUMN Salary TO Annual_Income;

-- Query 1: Total number of men and women employees under 50 years old
SELECT Gender, COUNT(*) AS "Total Employees"
FROM Employees
WHERE Age <= 50
GROUP BY Gender;

-- Optional: Rename column Annual_Income back to Salary (only if needed)
ALTER TABLE Salary RENAME COLUMN Annual_Income TO Salary;

-- Query 2: Employees whose salary is greater than $150000
SELECT e.First_Name, e.Last_Name, e.Gender, e.Country, s.Salary
FROM Employees e
INNER JOIN Salary s ON e.Emp_ID = s.Emp_ID
WHERE s.Salary > 150000;


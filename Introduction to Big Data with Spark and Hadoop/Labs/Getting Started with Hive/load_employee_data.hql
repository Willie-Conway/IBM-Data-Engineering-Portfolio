-- Create Employee table
CREATE TABLE IF NOT EXISTS Employee (
    emp_id STRING,
    emp_name STRING,
    salary INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- Show all tables
SHOW TABLES;

-- Load data from mounted CSV file
LOAD DATA INPATH '/hive_custom_data/emp.csv' INTO TABLE Employee;

-- View contents of the table
SELECT * FROM Employee;

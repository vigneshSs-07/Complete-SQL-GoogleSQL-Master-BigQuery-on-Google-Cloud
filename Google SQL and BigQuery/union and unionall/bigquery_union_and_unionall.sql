/*
Practical Hands-on UNION and UNION ALL in Bigquery.
*/

-- Create the sales_team table with employee_id and employee_name columns
CREATE TABLE `amiable-might-453515-g6.demo_dataset.sales_team` (
    employee_id INT,
    employee_name STRING
);

-- Insert sample data into the sales_team table
INSERT INTO `amiable-might-453515-g6.demo_dataset.sales_team` (employee_id, employee_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Select all data from the sales_team table to verify the insertion
SELECT * FROM `amiable-might-453515-g6.demo_dataset.sales_team`;

-- Create the customer_team table with employee_id and employee_name columns
CREATE TABLE `amiable-might-453515-g6.demo_dataset.customer_team` (
    employee_id INT,
    employee_name STRING
);

-- Insert sample data into the customer_team table
INSERT INTO `amiable-might-453515-g6.demo_dataset.customer_team` (employee_id, employee_name) VALUES
(3, 'Charlie'),
(4, 'David'),
(5, 'Eve');

-- Select all data from the customer_team table to verify the insertion
SELECT * FROM `amiable-might-453515-g6.demo_dataset.customer_team`;

-- Use UNION DISTINCT to combine data from sales_team and customer_team tables, excluding duplicates
SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.sales_team`
UNION DISTINCT
SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.customer_team`
ORDER BY employee_id;


-- Use UNION ALL to combine data from sales_team and customer_team tables, including duplicates
SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.sales_team`
UNION ALL
SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.customer_team`
ORDER BY employee_id;
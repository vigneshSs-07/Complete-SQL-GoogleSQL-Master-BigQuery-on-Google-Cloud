CREATE TABLE `amiable-might-453515-g6.demo_dataset.sales_team` (
    employee_id INT,
    employee_name STRING
);

INSERT INTO `amiable-might-453515-g6.demo_dataset.sales_team` (employee_id, employee_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

select * from `amiable-might-453515-g6.demo_dataset.sales_team`;

CREATE TABLE `amiable-might-453515-g6.demo_dataset.customer_team` ( 
employee_id INT, 
employee_name STRING
 );

INSERT INTO `amiable-might-453515-g6.demo_dataset.customer_team` (employee_id, employee_name) VALUES 
(3, 'Charlie'), 
(4, 'David'), 
(5, 'Eve');

select * from `amiable-might-453515-g6.demo_dataset.customer_team`;


SELECT employee_id, employee_name
    FROM `amiable-might-453515-g6.demo_dataset.sales_team`
   UNION ALL
SELECT employee_id, employee_name
    FROM  `amiable-might-453515-g6.demo_dataset.customer_team`
    order by employee_id;


SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.sales_team`
UNION DISTINCT
SELECT employee_id, employee_name
FROM `amiable-might-453515-g6.demo_dataset.customer_team`
order by employee_id;
--Identify Duplicate Emails
select email from person group by email having count(email)>=2
--Remove duplicates
Distinct keyword OR select email from person group by email
--Exactly One Occurrence
select email from person group by email having count(email)=1

-- delete duplicates
DELETE FROM employee
WHERE id IN (
    SELECT id
    FROM (
        SELECT id,
               ROW_NUMBER() OVER (
                   PARTITION BY name
                   ORDER BY id
               ) AS rn
        FROM employee
    ) t
    WHERE rn > 1
);
-- The columns in PARTITION BY define what you consider a duplicate.
-- the column defined in order by defines what duplicate you want to delete

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY name, salary  -- combination
               ORDER BY id
           ) AS rn
    FROM employee
)
DELETE FROM cte
WHERE rn > 1;

-- employees whose department does not exist in the Department table

SELECT *
FROM employee
WHERE dept_id NOT IN (
    SELECT dept_id
    FROM department
);

SELECT e.*
FROM employee e
LEFT JOIN department d
    ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- find all transactions done by a person
SELECT * FROM transactions WHERE UPPER(customer_name) = 'JOHN';

-- self join cases
select e2.name as Employee from employee e1 join employee e2 on e1.id=e2.managerid where e2.salary>e1.salary
--e1.id=e2.managerid --> this means e1 is the manager of e2, therefore we check e2.salary>e1.salary which means employee is getting more than manager
                                                        OR
select e1.name as Employee from employee e1 join employee e2 on e1.managerid=e2.id where e1.salary>e2.salary

select e1.name from employee e1 join employee e2 on e1.id=e2.managerid group by e1.id having count(*)>4 (managers with at least 5 direct reports)


-- update male to female and vice versa
UPDATE employee
SET gender = CASE
                WHEN gender = 'Male' THEN 'Female'
                WHEN gender = 'Female' THEN 'Male'
             END;


-- pivot and unpivot

| emp_id | salary_component_type | val   |
| ------ | --------------------- | ----- |
| 101    | salary                | 50000 |
| 101    | bonus                 | 5000  |
| 101    | hike_percent          | 10    |
| 102    | salary                | 60000 |
| 102    | bonus                 | 6000  |
| 102    | hike_percent          | 15    |

| emp_id | salary | bonus | hike_percent |
| ------ | ------ | ----- | ------------ |
| 101    | 50000  | 5000  | 10           |
| 102    | 60000  | 6000  | 15           |

SELECT
    emp_id,
    MAX(CASE WHEN salary_component_type = 'salary'
             THEN val END) AS salary,
    MAX(CASE WHEN salary_component_type = 'bonus'
             THEN val END) AS bonus,
    MAX(CASE WHEN salary_component_type = 'hike_percent'
             THEN val END) AS hike_percent
FROM emp_compensation
GROUP BY emp_id;

select emp_id,'salary' as salary_component_type,salary as val from emp_compensation_pivot
union all 
select emp_id,'bonus' as salary_component_type,bonus as val from emp_compensation_pivot
union all 
select emp_id,'hike_percent' as salary_component_type,hike_percent as val from emp_compensation_pivot

| name  | city      |
| ----- | --------- |
| Virat | Bangalore |
| Rohit | Mumbai    |
| Rahul | Bangalore |
| Surya | Mumbai    |
| Pant  | Delhi     |
| Iyer  | Delhi     |

| Bangalore | Delhi | Mumbai |
| --------- | ----- | ------ |
| Rahul     | Iyer  | Rohit  |
| Virat     | Pant  | Surya  |

WITH cte AS (
    SELECT 
        name, 
        city,
        ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) as rn
    FROM players_location
)
SELECT 
    MAX(CASE WHEN city = 'Bangalore' THEN name END) AS Bangalore,
    MAX(CASE WHEN city = 'Delhi' THEN name END) AS Delhi,
    MAX(CASE WHEN city = 'Mumbai' THEN name END) AS Mumbai
FROM cte
GROUP BY rn;

Compensation pivot → group by a real key (emp_id).
Players query → no real key exists, so create one using ROW_NUMBER().
if a particular group key does not have all values then you have to handle nulls explicitly during unpivot

SELECT 'Bangalore' AS city, Bangalore AS name FROM pivoted_data WHERE Bangalore IS NOT NULL
UNION ALL
SELECT 'Delhi' AS city, Delhi AS name FROM pivoted_data WHERE Delhi IS NOT NULL
UNION ALL
SELECT 'Mumbai' AS city, Mumbai AS name FROM pivoted_data WHERE Mumbai IS NOT NULL;


-- Rank departments based on the number of employees earning more than ₹50,000 having atleast 2 employees.
--(as window functions run after group by both are done in a single query)
| emp_id | dept    | salary |                                                                          
| ------ | ------- | ------ |
| 1      | IT      | 70000  |
| 2      | IT      | 80000  |
| 3      | IT      | 90000  |
| 4      | HR      | 60000  |
| 5      | HR      | 70000  |
| 6      | Finance | 100000 |

SELECT
    dept_id,
    COUNT(*) AS emp_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
FROM employees
WHERE salary > 50000
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- Order of Execution:-
FROM
JOIN
WHERE
GROUP BY
AGGREGATES
HAVING
WINDOW FUNCTIONS
SELECT
DISTINCT
ORDER BY
LIMIT/TOP

--For each customer, show the first transaction amount and the latest transaction amount.
--(first ranking and then group by and max )
| customer_id | txn_date   | amount |
| ----------- | ---------- | ------ |
| 101         | 2025-01-01 | 1000   |
| 101         | 2025-01-10 | 1500   |
| 101         | 2025-01-20 | 1200   |
| 102         | 2025-01-05 | 2000   |
| 102         | 2025-01-15 | 2500   |

| customer_id | first_txn_amount | latest_txn_amount |
| ----------- | ---------------- | ----------------- |
| 101         | 1000             | 1200              |
| 102         | 2000             | 2500              |

WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id
               ORDER BY txn_date ASC
           ) AS first_txn,
           ROW_NUMBER() OVER(
               PARTITION BY customer_id
               ORDER BY txn_date DESC
           ) AS latest_txn
    FROM transactions
)
SELECT
    customer_id,
    MAX(CASE WHEN first_txn = 1 THEN amount END) AS first_txn_amount,
    MAX(CASE WHEN latest_txn = 1 THEN amount END) AS latest_txn_amount
FROM ranked
GROUP BY customer_id;


-- YOY Growth and 3 day Rolling Average

SELECT
    year,
    revenue,
    prev_year_revenue,
    ROUND(
        (revenue - prev_year_revenue) * 100.0
        / prev_year_revenue,
        2
    ) AS yoy_growth_pct
FROM (
    SELECT
        year,
        revenue,
        LAG(revenue,1,revenue) OVER (ORDER BY year) AS prev_year_revenue
    FROM sales
) t;

select user_id, tweet_date,
       round(avg(tweet_count) over(partition by user_id 
       order by tweet_date range between 
       interval '2' day preceding and current row),2) as running_weekly_sum
from tweets order by user_id ;

-- exclude computation of current row (ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING, SUM(salary) OVER (PARTITION BY dept_id) - salary)

-- group_concat, split, collect_list and explode

SELECT city, GROUP_CONCAT(name) as names
FROM players_location 
GROUP BY city;

SELECT city, EXPLODE(SPLIT(names, ',')) AS name
FROM temp_table;

SELECT city, COLLECT_LIST(name) AS names
FROM players_location
GROUP BY city;

SELECT city, COLLECT_SET(name) AS names
FROM players_location
GROUP BY city;

SELECT city, EXPLODE(names) AS name
FROM temp_table;

SELECT category,
       CONCAT_WS(',', COLLECT_LIST(amount)) AS amounts   -- spark specific
FROM supplies
GROUP BY category;

-- work with json objects

SELECT customer_id, profile:first_name, profile:address:country 
FROM customers
-- when column is a nested json string

CREATE OR REPLACE TEMP VIEW parsed_customers AS
  SELECT customer_id, from_json(profile, schema_of_json('{"first_name":"Thomas","last_name":"Lane","gender":"Male",
  "address":{"street":"06 Boulevard Victor Hugo","city":"Paris","country":"France"}}')) AS profile_struct
  FROM customers;
  
SELECT * FROM parsed_customers
-- make sure to pass a not null record in schema_of_json

SELECT customer_id, profile_struct.first_name, profile_struct.address.country
FROM parsed_customers

CREATE OR REPLACE TEMP VIEW customers_final AS
  SELECT customer_id, profile_struct.*
  FROM parsed_customers;
-- flatten all fields

normalized_json =
    when(col("payload").startswith("["),
         col("payload"))
    .otherwise(
         concat(lit("["), col("payload"), lit("]"))
    )

from_json(normalized_json, array_schema)

array_schema = ArrayType(
    StructType([
        StructField("id", IntegerType()),
        StructField("name", StringType())
    ])
)
from_json(col("normalized_json"), array_schema)
from_json(col("normalized_json"), schema_of_json(lit('[{"id":1,"name":"John"}]')))

--Complex functions in Databricks

order_id	customer_id	books
000000000003559	C00001	[{"book_id":"B09","quantity":2,"subtotal":48}]
000000000004243	C00002	[{"book_id":"B07","quantity":1,"subtotal":33},{"book_id":"B06","quantity":1,"subtotal":22}]

SELECT order_id, customer_id, explode(books) AS book 
FROM orders

000000000003559	C00001	{"book_id":"B09","quantity":2,"subtotal":48}
000000000004243	C00002	{"book_id":"B07","quantity":1,"subtotal":33}
000000000004243	C00002	{"book_id":"B06","quantity":1,"subtotal":22}

SELECT customer_id,
  collect_set(order_id) AS orders_set,
  collect_set(books.book_id) AS books_set
FROM orders
GROUP BY customer_id

C00001	["000000000003559","000000000005067","000000000005191"]	[["B09"],["B03","B12"],["B08","B02"]]
C00002	["000000000004243","000000000004550","000000000005192"]	[["B07","B06"],["B04","B06"],["B02","B06","B01"]]

SELECT customer_id,
  collect_set(books.book_id) As before_flatten,
  array_distinct(flatten(collect_set(books.book_id))) AS after_flatten
FROM orders
GROUP BY customer_id limit 2

customer_id	before_flatten	after_flatten
C00001	[["B09"],["B03","B12"],["B08","B02"]]	["B09","B03","B12","B08","B02"]
C00002	[["B07","B06"],["B04","B06"],["B02","B06","B01"]]	["B07","B06","B04","B02","B01"]

-- Working with months

| Month |  Amt | Running Total |
| ----- | ---: | ------------: |
| Jan   | 2345 |          2345 |
| Feb   | 3562 |          5907 |
| Mar   | 3562 |          9469 |
| Apr   | 4628 |         14097 |
| May   | 2900 |         16997 |

SELECT month,
       SUM(amt) OVER (
           ORDER BY
           CASE month
               WHEN 'Jan' THEN 1
               WHEN 'Feb' THEN 2
               WHEN 'Mar' THEN 3
               WHEN 'Apr' THEN 4
               WHEN 'May' THEN 5
           END
       ) AS running_total
FROM table;

SELECT *,
       SUM(amt) OVER (
           ORDER BY month_no
           RANGE BETWEEN 1 PRECEDING AND 2 FOLLOWING
       ) AS sum_amt
FROM sales;

-- if order by column is a date

SUM(amt) OVER (
    ORDER BY order_date
    RANGE BETWEEN INTERVAL 1 MONTH PRECEDING
          AND INTERVAL 2 MONTH FOLLOWING
)

SELECT date_format(order_date, 'MM-yyyy') AS month_year,
       SUM(amount) AS total
FROM sales
GROUP BY date_format(order_date, 'MM-yyyy');

-- Having Clause Scenarios

Employees working on BOTH project1 and project2

SELECT empid
FROM emp_project
WHERE project IN ('project1','project2')
GROUP BY empid
HAVING COUNT(DISTINCT project)=2;

Employees working on project1 and project2 but NO other projects

SELECT employee_id
FROM Employee_Projects
GROUP BY employee_id
HAVING COUNT(DISTINCT project_id)=2
AND COUNT(DISTINCT CASE
WHEN project_id IN ('project1','project2')
THEN project_id
END)=2;

Employees working ONLY on project1

SELECT empid
FROM emp_project
GROUP BY empid
HAVING COUNT(DISTINCT project)=1
AND MAX(project)='project1';

Employees working on project1 but NOT project2

SELECT empid
FROM emp_project
GROUP BY empid
HAVING SUM(CASE WHEN project='project1' THEN 1 ELSE 0 END)>0
AND SUM(CASE WHEN project='project2' THEN 1 ELSE 0 END)=0;

Employees NOT working on project3

SELECT empid
FROM emp_project
GROUP BY empid
HAVING SUM(CASE WHEN project='project3'
                THEN 1
                ELSE 0
           END)=0;

Employees working on AT LEAST one of project1/project2

SELECT DISTINCT empid
FROM emp_project
WHERE project IN ('project1','project2');

Employees working on ALL projects

SELECT empid
FROM emp_project
GROUP BY empid
HAVING COUNT(DISTINCT project) =
(
    SELECT COUNT(DISTINCT project)
    FROM emp_project
);

P1 or P2, but NOT both

SELECT empid FROM emp_project
WHERE project IN ('P1','P2')
GROUP BY empid
HAVING COUNT(DISTINCT project) = 1;

Employees working on EXACTLY N projects

SELECT empid
FROM emp_project
GROUP BY empid
HAVING COUNT(DISTINCT project)=3;

Bought every product EXACTLY ONCE (no duplicates at all)

SELECT userid FROM purchase_history
GROUP BY userid
HAVING COUNT(DISTINCT productid) = COUNT(productid);

same marks in physics and chemistry
select student_id 
from exams 
where subject in ('Physics','Chemistry') 
group by student_id 
having count(distinct subject)=2 and count(distinct marks)=1;

select student_id from exams where subject in ('Chemistry','Physics')
group by student_id having count(distinct subject)=2 and max(marks)=min(marks)


-- testing

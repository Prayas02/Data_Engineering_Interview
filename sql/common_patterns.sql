-- Consequtive Numbers
with cte as
(select seat_no , seat_no-row_number() over(order by seat_no) as rn from bms
where is_empty = 'Y'),
cte1 as 
(select rn from cte group by rn having count(*)>2)

select seat_no from cte where rn in (select rn from cte1)


-- Trips and Users --> 2 join scenario
select request_at as Day, round(sum(case when status='cancelled_by_client' or status='cancelled_by_driver' then 1 else 0 end)*1.0 / count(*),2) as 'Cancellation Rate' 
from (select t.client_id, t.driver_id, t.status, t.request_at, u.banned as cb, ur.banned as db 
from trips t join users u on t.client_id =u.users_id join Users ur on t.driver_id = ur.users_id)m 
where cb='No' and db='No' and request_at between '2013-10-01' and '2013-10-03' group by request_at 


-- New and Repeat Customers
select order_date, sum(case when order_date=min_date then 1 else 0 end) as 
new_customer, sum(case when order_date>min_date then 1 else 0 end) as 
repeat_customer  from customer_orders c join 
(select customer_id, min(order_date) as min_date from customer_orders group by customer_id)m on 
c.customer_id =m.customer_id group by order_date


-- Price on a particular date
with cte as 
(select distinct p.product_id, n.price from Products p left join 
(select product_id, new_price as price from 
(select *, row_number() over(partition by product_id order by change_date desc) as rn 
from Products where change_date <= '2019-08-16')m where rn=1)n on p.product_id=n.product_id)
select product_id, case when price is null then 10 else price end as price from cte


--	Most visited floor
with cte as (
select 
name,
floor,
count(*) as cnt
from entries
group by name, floor
),
ranked as (
select *,
row_number() over(partition by name order by cnt desc) as rn
from cte
)
select name, floor
from ranked
where rn = 1;

-- missing quarter --> cross join scenario (remember cross join syntax)
with cte as 
(SELECT * FROM 
  (SELECT DISTINCT Quarter as quar FROM STORES) AS q
CROSS JOIN 
  (SELECT DISTINCT Store as str FROM STORES) AS s)
  
select str,quar from
  
(select * from cte left join stores s on cte.quar=s.Quarter and cte.Str=s.Store)m 
where store is null order by str


-- same marks in physics and chemistry
select student_id 
from exams 
where subject in ('Physics','Chemistry') 
group by student_id 
having count(distinct subject)=2 and count(distinct marks)=1;

select student_id from exams where subject in ('Chemistry','Physics')
group by student_id having count(distinct subject)=2 and max(marks)=min(marks)

-- Users who have done purchase on more than 1 day and products purchased on a given day are never repeated on any other day.
Select userid from purchase_history 
group by userid 
having count(distinct productid )= count (productid) 
and count(distinct purchasedate)>1

--differentiate between 2 binaries 0 and 1 --> give favourable condition as 1
select city from
(select *, case when prev is null or prev<cases then 1 else 0 end as bi from
(select *, lag(cases) over(partition by city order by days) as prev from covid)m)n
group by city having min(bi)=1;


-- product in range -- cumulative sum
with running_cost as (
  select
    *,
    sum(cost) over (order by cost asc) as r_cost
  from products
)
, cte as
(select * from customer_budget cb left join running_cost rc on r_cost<budget)

select customer_id, budget, count(*) as no_of_products, group_concat(product_id) as product_list
from cte group by customer_id, budget


-- continously increasing

SELECT city
FROM (
    SELECT *, 
           LAG(cases) OVER(PARTITION BY city ORDER BY days) as prev_cases
    FROM covid
) t
GROUP BY city
-- Ensure every day (after the first) has more cases than the day before
HAVING COUNT(*) = SUM(CASE WHEN prev_cases IS NULL OR cases > prev_cases THEN 1 ELSE 0 END);
-- HAVING COUNT(*) = SUM(all rows)



-- horizantal sorting

select sms_date, p1, p2, sum(sms_no) as total_sms 
from (
    select sms_date, 
           case when sender < receiver then sender else receiver end as p1,
           case when sender > receiver then sender else receiver end as p2,
           sms_no
    from subscriber
) A
group by sms_date, p1, p2;


-- group key creation

with xxx as (
  select
    *,
    sum(case when status = 'on' and prev_status = 'off' then 1 else 0 end) over (order by event_time) as group_key
  from (
    select
      *,
      lag(status, 1, status) over (order by event_time asc) as prev_status
    from
      event_status) A
)
select
  min(event_time) as login,
  max(event_time) as logout,
  count(*) - 1 as on_count
from
  xxx
group by group_key;


-- customer retention

SELECT 
    MONTH(this_month.order_date) AS month_date,
    COUNT(DISTINCT last_month.cust_id) AS repeat_customers
FROM transactions this_month
LEFT JOIN transactions last_month
    ON this_month.cust_id = last_month.cust_id
    AND PERIOD_DIFF(
        DATE_FORMAT(this_month.order_date, '%Y%m'),
        DATE_FORMAT(last_month.order_date, '%Y%m')
    ) = 1
GROUP BY MONTH(this_month.order_date);


-- customer churn

SELECT 
    MONTH(this_month.order_date) AS month_date,
    COUNT(DISTINCT this_month.cust_id) AS repeat_customers
FROM transactions this_month
LEFT JOIN transactions last_month
    ON this_month.cust_id = last_month.cust_id
    AND PERIOD_DIFF(
        DATE_FORMAT(last_month.order_date, '%Y%m'),
        DATE_FORMAT(this_month.order_date, '%Y%m')
    ) = 1
where last_month.cust_id is null
GROUP BY MONTH(this_month.order_date);


-- group by, max and double window (Use window functions when you need row context, aggregation when you need only values)

WITH ranked AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open ASC) as lowest_open,
ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY close DESC) as highest_close
FROM stock_prices
)

SELECT 
ticker,
MAX(CASE WHEN lowest_open = 1 THEN open END) as lowest_open,
MAX(CASE WHEN highest_close = 1 THEN close END) as highest_close
FROM ranked
GROUP BY ticker;

-- top n per group (group first and then window) wrt order of execution both are done in 1 query

SELECT category, product, total_spend
FROM (
    SELECT 
        category,
        product,
        SUM(spend) as total_spend,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY SUM(spend) DESC
        ) as rnk
    FROM product_spend
    GROUP BY category, product
) x
WHERE rnk <= 2;


-- rolling average

select user_id, tweet_date,
       round(avg(tweet_count) over(partition by user_id 
       order by tweet_date range between 
       interval '2' day preceding and current row),2) as running_weekly_sum
from tweets order by user_id ;



select visited_on , amount , round(average_amount , 2) as average_amount from 
(select visited_on, 
sum(amount) over(order by visited_on range between interval '6' day preceding and current row) as amount, 
sum(amount) over(order by visited_on range between interval '6' day preceding and current row)/7 as average_amount from Customer )m 
where visited_on >=(SELECT MIN(visited_on) + INTERVAL '6' DAY FROM Customer ) group by 1,2,3

-- WHERE visited_on >= MIN(visited_on) + INTERVAL '6' DAY --> ERROR as agg functions are calculated after group by and where exectes before and logically also incorrect as it is not fetching the min on the entire group
-- RANGE operates on values, not row count. If duplicate dates exist, multiple rows fall within the same range, causing AVG() to divide by extra rows and skew the result.


-- node classification

select node,
       CASE
            when node not in (select distinct parent from tree where parent is not null) then 'LEAF'
            when parent is null then 'ROOT'
            else 'INNER'
       END as node_type
from tree;

-- Pivot and Unpivot

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
-- idea is to generate 1 value per group by per column so we can apply aggregates

SELECT 'Bangalore' AS city, Bangalore AS name FROM pivoted_data WHERE Bangalore IS NOT NULL
UNION ALL
SELECT 'Delhi' AS city, Delhi AS name FROM pivoted_data WHERE Delhi IS NOT NULL
UNION ALL
SELECT 'Mumbai' AS city, Mumbai AS name FROM pivoted_data WHERE Mumbai IS NOT NULL;


-- group_concat, split, collect_list and explode

SELECT city, GROUP_CONCAT(name) as names
FROM players_location 
GROUP BY city;

SELECT city, EXPLODE(SPLIT(names, ',')) AS name
FROM temp_table;

SELECT city, COLLECT_LIST(name) AS names
FROM players_location
GROUP BY city;

SELECT city, EXPLODE(names) AS name
FROM temp_table;


-- employee median salary

select
  company,
  avg(salary)
from
  (
    select
      *,
      row_number() over (partition by company order by salary) as rn,
      count(1) over (partition by company) as total_cnt
    from
      employee
  ) a
where
  rn between total_cnt * 1.0 / 2 and total_cnt * 1.0 / 2 + 1
group by
  company;


-- condition inside where

WITH cte1 AS (
    SELECT 
        emp_id, 
        emp_name, 
        salary, 
        COUNT(*) OVER(PARTITION BY dep_id) AS cn, 
        ROW_NUMBER() OVER(PARTITION BY dep_id ORDER BY salary DESC) AS rn 
    FROM emp
)
SELECT emp_id, emp_name, salary 
FROM cte1 
WHERE (cn > 2 AND rn = 3) 
   OR (cn <= 2 AND rn = 1);
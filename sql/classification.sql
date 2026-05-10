create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

select * from spending;

WITH user_day AS (
    SELECT
        spend_date,
        user_id,
        SUM(amount) AS amount,
        MAX(CASE WHEN platform = 'desktop' THEN 1 ELSE 0 END) AS used_desktop,
        MAX(CASE WHEN platform = 'mobile' THEN 1 ELSE 0 END) AS used_mobile
    FROM spending
    GROUP BY spend_date, user_id
),
classified AS (
    SELECT
        spend_date,
        user_id,
        amount,
        CASE
            WHEN used_desktop = 1 AND used_mobile = 1 THEN 'both'
            WHEN used_desktop = 1 THEN 'desktop'
            ELSE 'mobile'
        END AS platform
    FROM user_day
),
platforms AS (
    SELECT 'desktop' AS platform
    UNION SELECT 'mobile'
    UNION SELECT 'both'
),
dates AS (
    SELECT DISTINCT spend_date FROM spending
)

SELECT
    d.spend_date,
    p.platform,
    COALESCE(SUM(c.amount), 0) AS total_amount,
    COUNT(DISTINCT c.user_id) AS total_users
FROM dates d
CROSS JOIN platforms p
LEFT JOIN classified c
    ON d.spend_date = c.spend_date
    AND p.platform = c.platform
GROUP BY d.spend_date, p.platform
ORDER BY d.spend_date, p.platform DESC;

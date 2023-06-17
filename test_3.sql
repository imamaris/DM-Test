WITH
  all_buyers AS (
    SELECT DISTINCT idBuyer
    FROM `project-imam-dev.aruna.order`
  ),
  monthly_buyers AS (
    SELECT DATE(DATE_TRUNC(date,month)) AS month, idBuyer, 1 AS found
    FROM `project-imam-dev.aruna.order`
    WHERE idBuyer IN (SELECT idBuyer FROM all_buyers)
  ),

agg_table AS (SELECT m.month, ab.idBuyer, COALESCE(mb.found, 0) AS found
FROM (
  SELECT DISTINCT DATE(DATE_TRUNC(date,month)) AS month
  FROM `project-imam-dev.aruna.order`
) m
LEFT JOIN (
  SELECT DISTINCT idBuyer
  FROM all_buyers
) ab
ON TRUE
LEFT JOIN monthly_buyers mb
ON m.month = mb.month
AND ab.idBuyer = mb.idBuyer),

final_table AS(select
month, idBuyer, sum(found) total,
CASE
      WHEN SUM(found) = 0 THEN 'Inactive'
      WHEN SUM(found) BETWEEN 1 AND 2 THEN 'Casual'
      ELSE 'Power'
    END AS segment
from agg_table
group by 1,2)

SELECT
month,
segment,
count(segment) total_users_segment
from final_table
group by 1,2
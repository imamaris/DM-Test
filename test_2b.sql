/*
brief: Which sales person achieved the target (generate revenue >= target) for 2 years in a
row?
author: Imam Aris Munandar
Created: 2023-06-16
This query build SQL in Bigquery
*/

WITH
  order_source AS(
  SELECT
    Date,
    EXTRACT(YEAR FROM Date) AS year,
    os.idSales,
    s.Name,
    Revenue,
    SUM(RawMaterial + Handling + Logistic) AS cost_revenue,
  FROM
    `project-imam-dev.aruna.order` os -- Order dataset
      LEFT JOIN
    `project-imam-dev.aruna.sales` s -- Sales dataset
  ON
    os.idSales = s.idSales
  GROUP BY 1,2,3,4,5),

total_revenue AS (
SELECT gs.year, idSales, Name, sum(revenue) achievement,
FROM order_source gs
group by 1,2,3
order by 1 desc),

target_revenue AS (SELECT
      year,
      ROUND(AVG(achievement)) AS target
    FROM
      total_revenue
    GROUP BY 1)

SELECT
  tr.year,
  t.idSales,
  t.Name,
  t.achievement
FROM
  total_revenue t
JOIN
  target_revenue tr
ON
  t.year = tr.year
  AND t.achievement >= tr.target
ORDER BY year DESC
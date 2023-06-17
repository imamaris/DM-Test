/*
brief: Find Top 5 Sales Person by gross profit in each year!
author: Imam Aris Munandar
Created: 2023-06-16
This query build SQL in Bigquery
*/

WITH
  order_source AS(
  SELECT
    Date,
    EXTRACT(YEAR FROM Date) AS year,
    idSales,
    Revenue,
    SUM(RawMaterial + Handling + Logistic) AS cost_revenue,
  FROM
    `project-imam-dev.aruna.order` -- Order dataset
  GROUP BY 1,2,3,4),
  
  group_source AS (
  SELECT
    year,
    os.idSales,
    s.Name,
    ROUND(SUM(Revenue - cost_revenue),2) gross_profit,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(Revenue - cost_revenue) DESC) AS rn
  FROM
    order_source os
  LEFT JOIN
    `project-imam-dev.aruna.sales` s -- Sales dataset
  ON
    os.idSales = s.idSales
  GROUP BY 1, 2,3
  ORDER BY
    year DESC )

SELECT year, idSales, Name, gross_profit
FROM
  group_source
WHERE
  rn <= 5
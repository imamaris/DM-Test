/*
brief: Find monthly revenue, cost revenue, and gross profit in each year!
author: Imam Aris Munandar
Created: 2023-06-16
This query build SQL in Bigquery
*/

WITH
  revenue_over_month AS (
  SELECT
    DATE_TRUNC(DATE(date),MONTH) AS monthly,
    EXTRACT(MONTH FROM Date) AS month,
    Product,
    ROUND(SUM(Revenue),2) AS revenue,
    ROUND(SUM(RawMaterial + Handling + Logistic),2) AS cost_revenue,
    ROUND(SUM(Revenue - (RawMaterial + Handling + Logistic)),2) gross_profit,
  FROM
    `project-imam-dev.aruna.order`
  GROUP BY 1,2,3
  ORDER BY monthly DESC)

SELECT * FROM revenue_over_month
/*
brief: Find Top 10 Buyer by revenue in each year
author: Imam Aris Munandar
Created: 2023-06-16
This query build SQL in Bigquery
*/

WITH soure_order AS(
  SELECT
    EXTRACT(YEAR FROM Date) AS year,
    idBuyer,
    SUM(Revenue) Revenue,
  FROM
    `project-imam-dev.aruna.order` -- Order dataset
  GROUP by 1,2),

rank_filter AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY year ORDER BY Revenue DESC) AS rank
FROM soure_order)

SELECT year, idBuyer, Revenue FROM rank_filter
WHERE rank <= 10 -- get rank top 10
ORDER BY year DESC


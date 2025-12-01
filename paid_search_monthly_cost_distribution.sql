SELECT
  date,
  SUM(total_cost) OVER () AS cost,
  total_cost / SUM(total_cost) OVER() * 100 AS percentage_of_total_cost
FROM(


  SELECT
    DATE(extract(year FROM date),
    extract(month FROM date),
    1) as date,
 
   sum(cost) as total_cost


  FROM
    `DA.paid_search_cost`
    group by DATE(extract(year FROM date),
    extract(month FROM date) ,
    1)
  ) as sub


order by date

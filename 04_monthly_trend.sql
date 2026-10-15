-- 04. Seasonality: trips and average duration by month.
SELECT
  month_num,
  month_name,
  COUNT(*)                        AS trips,
  ROUND(AVG(tripduration_min), 1) AS avg_duration_min
FROM `new_york_citibike.clean_trips_2015`
GROUP BY month_num, month_name
ORDER BY month_num;

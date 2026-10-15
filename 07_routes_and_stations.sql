-- 07. Popular routes and stations.

-- 7.1 Top 10 routes (round trips excluded)
SELECT start_station_name, end_station_name, COUNT(*) AS trips
FROM `new_york_citibike.clean_trips_2015`
WHERE start_station_id != end_station_id
GROUP BY start_station_name, end_station_name
ORDER BY trips DESC
LIMIT 10;

-- 7.2 Top 10 start stations
SELECT start_station_id, start_station_name, COUNT(*) AS trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY start_station_id, start_station_name
ORDER BY trips DESC
LIMIT 10;

-- 7.3 Top 5 start stations in each month (window function + QUALIFY)
SELECT
  month_num,
  month_name,
  start_station_name,
  COUNT(*) AS trips,
  DENSE_RANK() OVER (PARTITION BY month_num ORDER BY COUNT(*) DESC) AS station_rank
FROM `new_york_citibike.clean_trips_2015`
GROUP BY month_num, month_name, start_station_id, start_station_name
QUALIFY station_rank <= 5
ORDER BY month_num, station_rank;

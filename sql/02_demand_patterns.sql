
-- Analyze monthly trip demand throughout 2015.
SELECT
  month_num,
  month_name,
  COUNT(*) AS total_trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY
  month_num,
  month_name
ORDER BY total_trips DESC;


-- Analyze trip demand by day of the week.
SELECT
  day_of_week,
  COUNT(*) AS total_trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY day_of_week
ORDER BY total_trips DESC;


-- Identify peak hours based on trip start times.
SELECT
  hour_of_day,
  COUNT(*) AS total_trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY hour_of_day
ORDER BY total_trips DESC;


-- Compare hourly trip demand on weekdays and weekends.

SELECT
  CASE
    WHEN day_of_week_num IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  hour_of_day,
  COUNT(*) AS total_trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY
  day_type,
  hour_of_day
ORDER BY
  day_type,
  hour_of_day;

-- 05. When do people ride?

-- 5.1 Top 10 busiest weekday + hour combinations
SELECT day_of_week, hour_of_day, COUNT(*) AS trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY day_of_week, hour_of_day
ORDER BY trips DESC
LIMIT 10;

-- 5.2 Busiest hour for each day of the week
SELECT day_of_week, hour_of_day, COUNT(*) AS trips
FROM `new_york_citibike.clean_trips_2015`
GROUP BY day_of_week, day_of_week_num, hour_of_day
QUALIFY ROW_NUMBER() OVER (PARTITION BY day_of_week ORDER BY COUNT(*) DESC) = 1
ORDER BY day_of_week_num;

-- 5.3 Weekday vs weekend by hour
-- Divided by the number of days of each type, otherwise weekdays look bigger
-- only because there are more of them in a year.
SELECT
  hour_of_day,
  CASE WHEN day_of_week_num IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
  ROUND(COUNT(*) / COUNT(DISTINCT trip_date), 0) AS avg_trips_per_day
FROM `new_york_citibike.clean_trips_2015`
GROUP BY hour_of_day, day_type
ORDER BY day_type, hour_of_day;

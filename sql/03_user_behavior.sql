
-- Compare trip volume and share by user type.
SELECT
  usertype,
  COUNT(*) AS total_trips,
  ROUND(
    100 * SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()),
    2
  ) AS trip_share_pct
FROM `new_york_citibike.clean_trips_2015`
GROUP BY usertype
ORDER BY total_trips DESC;


-- Compare trip duration by user type for trips up to 24 hours.
-- Calculate average and approximate median trip duration.
SELECT
  usertype,
  COUNT(*) AS total_trips,
  ROUND(AVG(tripduration / 60.0), 1) AS avg_duration_min,
  ROUND(
    APPROX_QUANTILES(tripduration / 60.0, 100)[OFFSET(50)],
    1
  ) AS median_duration_min
FROM `new_york_citibike.clean_trips_2015`
WHERE tripduration <= 86400
GROUP BY usertype
ORDER BY avg_duration_min DESC;


-- Compare weekend trip share by user type.

SELECT
  usertype,
  COUNT(*) AS total_trips,
  COUNTIF(day_of_week_num IN (1, 7)) AS weekend_trips,
  ROUND(
    SAFE_DIVIDE(
      COUNTIF(day_of_week_num IN (1, 7)),
      COUNT(*)
    ) * 100,
    2
  ) AS weekend_share_pct
FROM `new_york_citibike.clean_trips_2015`
GROUP BY usertype
ORDER BY weekend_share_pct DESC;

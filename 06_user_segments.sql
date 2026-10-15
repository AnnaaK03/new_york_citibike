-- 06. Subscriber (annual member) vs Customer (24-hour or 7-day pass).
SELECT
  usertype,
  COUNT(*)                                                        AS trips,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)                AS share_pct,
  ROUND(AVG(tripduration_min), 1)                                 AS avg_min,
  APPROX_QUANTILES(tripduration_min, 2)[OFFSET(1)]                AS median_min,
  ROUND(100 * COUNTIF(day_of_week_num IN (1, 7)) / COUNT(*), 1)   AS weekend_pct,
  ROUND(100 * COUNTIF(start_station_id = end_station_id) / COUNT(*), 1) AS same_station_pct
FROM `new_york_citibike.clean_trips_2015`
GROUP BY usertype;

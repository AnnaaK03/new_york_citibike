-- 01. Check the date range before cleaning.
-- Why: BETWEEN '2015-01-01' AND '2015-12-31' on a DATETIME column treats the end
-- date as 2015-12-31 00:00:00, so the whole of 31 December is silently cut off.
-- The fix is a half-open interval: >= start AND < start of next year.

SELECT COUNT(*) AS dec_31_trips
FROM `new_york_citibike.citibike_trips`
WHERE starttime >= '2015-12-31' AND starttime < '2016-01-01';

-- Row count and time range for the whole year (correct filter)
SELECT
  COUNT(*)       AS total_rows,
  MIN(starttime) AS first_trip,
  MAX(starttime) AS last_trip,
  MIN(tripduration) AS min_duration_sec,
  MAX(tripduration) AS max_duration_sec,
  ROUND(AVG(tripduration), 1) AS avg_duration_sec,
  COUNTIF(tripduration > 86400) AS trips_over_24h
FROM `new_york_citibike.citibike_trips`
WHERE starttime >= '2015-01-01' AND starttime < '2016-01-01';

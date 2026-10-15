-- 02. Clean table used by all later queries and by Power BI.
-- Decisions:
--   * Period: 2015 only (2018 data is incomplete by month).
--   * Trips longer than 24 hours (86400 sec) are excluded. This is a working rule
--     for this project, not proof that every such trip is an error.
--   * Nothing else is deleted: NULLs, same-station trips and odd birth years stay.
-- Derived columns are added here so Power BI can sort months and weekdays correctly.

CREATE OR REPLACE TABLE `new_york_citibike.clean_trips_2015` AS
SELECT
  *,
  ROUND(tripduration / 60, 1)              AS tripduration_min,
  DATE(starttime)                          AS trip_date,
  FORMAT_DATETIME('%A', starttime)         AS day_of_week,
  EXTRACT(DAYOFWEEK FROM starttime)        AS day_of_week_num,  -- 1 = Sunday, 7 = Saturday
  EXTRACT(HOUR FROM starttime)             AS hour_of_day,
  FORMAT_DATETIME('%B', starttime)         AS month_name,
  EXTRACT(MONTH FROM starttime)            AS month_num
FROM `new_york_citibike.citibike_trips`
WHERE starttime >= '2015-01-01' AND starttime < '2016-01-01'
  AND tripduration <= 86400;

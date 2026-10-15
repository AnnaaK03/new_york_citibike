
-- Check the coverage and quality of 2015 Citi Bike trips.
-- Identify missing end times and invalid trip durations.

SELECT
  COUNT(*) AS total_trips,
  MIN(starttime) AS first_trip,
  MAX(starttime) AS last_trip,
  COUNTIF(stoptime IS NULL) AS null_stoptime,
  COUNTIF(tripduration IS NULL) AS null_duration,
  COUNTIF(tripduration <= 0) AS invalid_duration,
  COUNTIF(tripduration > 86400) AS trips_over_24h,
  ROUND(
    SAFE_DIVIDE(COUNTIF(tripduration > 86400), COUNT(*)) * 100,
    2
  ) AS pct_trips_over_24h

FROM `new_york_citibike.citibike_trips`

WHERE starttime >= '2015-01-01'
  AND starttime < '2016-01-01';


-- Create the 2015 Citi Bike analytical dataset.
-- Add date and time features for further analysis.

CREATE OR REPLACE TABLE `new_york_citibike.clean_trips_2015` AS

SELECT
  *,
  ROUND(tripduration / 60, 1) AS tripduration_min,
  DATE(starttime) AS trip_date,
  FORMAT_DATETIME('%A', starttime) AS day_of_week,
  EXTRACT(DAYOFWEEK FROM starttime) AS day_of_week_num,
  EXTRACT(HOUR FROM starttime) AS hour_of_day,
  FORMAT_DATETIME('%B', starttime) AS month_name,
  EXTRACT(MONTH FROM starttime) AS month_num

FROM `new_york_citibike.citibike_trips`

WHERE starttime >= '2015-01-01'
  AND starttime < '2016-01-01';

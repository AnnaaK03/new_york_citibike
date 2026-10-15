-- 03. Data quality checks on the clean table. SELECT only, nothing is changed.

-- 3.1 Missing values and basic sanity
SELECT
  COUNT(*)                                   AS total_trips,
  COUNTIF(birth_year IS NULL)                AS null_birth_year,
  COUNTIF(start_station_id IS NULL)          AS null_start_station,
  COUNTIF(end_station_id IS NULL)            AS null_end_station,
  COUNTIF(start_station_id = end_station_id) AS same_station_trips
FROM `new_york_citibike.clean_trips_2015`;

-- 3.2 Is birth_year missing only for one user type?
SELECT
  usertype,
  COUNT(*)                    AS trips,
  COUNTIF(birth_year IS NULL) AS null_birth_year
FROM `new_york_citibike.clean_trips_2015`
GROUP BY usertype;

-- 3.3 Odd birth years (kept in the data, only documented)
SELECT
  COUNTIF(birth_year < 1900)                 AS born_before_1900,
  COUNTIF(birth_year BETWEEN 1998 AND 2015)  AS age_under_18
FROM `new_york_citibike.clean_trips_2015`;

-- 3.4 Does tripduration match stoptime - starttime?
-- DATETIME has no time zone, so trips that cross a daylight-saving change
-- (8 Mar and 1 Nov 2015) show a 1 hour difference. tripduration is not changed.
SELECT
  COUNTIF(stoptime < starttime) AS stop_before_start,
  COUNTIF(ABS(tripduration - DATETIME_DIFF(stoptime, starttime, SECOND)) > 1) AS duration_mismatch
FROM `new_york_citibike.clean_trips_2015`;

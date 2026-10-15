-- 08. Station net flow on weekdays: which stations gain or lose bikes in the peaks.
-- net = arrivals - departures
--   positive = the station fills up, negative = the station empties.
-- Morning = 07:00-09:59, evening = 17:00-19:59. Arrivals are counted by stoptime hour,
-- departures by starttime hour. Trips that cross a window edge count on one side only,
-- so the sum over all stations is not exactly zero.
-- INNER JOIN: a station must have both departures and arrivals to appear.
-- Valet / depot / event stations are excluded: they are service points, not normal stations.
-- Result goes to Power BI as a table with coordinates for a map.

CREATE OR REPLACE TABLE `new_york_citibike.station_flow_2015` AS
WITH dep AS (
  SELECT
    start_station_id                    AS station_id,
    ANY_VALUE(start_station_name)       AS station_name,
    ANY_VALUE(start_station_latitude)   AS latitude,
    ANY_VALUE(start_station_longitude)  AS longitude,
    COUNTIF(hour_of_day BETWEEN 7 AND 9)   AS dep_morning,
    COUNTIF(hour_of_day BETWEEN 17 AND 19) AS dep_evening
  FROM `new_york_citibike.clean_trips_2015`
  WHERE day_of_week_num BETWEEN 2 AND 6   -- Monday to Friday
  GROUP BY station_id
),
arr AS (
  SELECT
    end_station_id AS station_id,
    COUNTIF(EXTRACT(HOUR FROM stoptime) BETWEEN 7 AND 9)   AS arr_morning,
    COUNTIF(EXTRACT(HOUR FROM stoptime) BETWEEN 17 AND 19) AS arr_evening
  FROM `new_york_citibike.clean_trips_2015`
  WHERE day_of_week_num BETWEEN 2 AND 6
  GROUP BY station_id
)
SELECT
  station_id, station_name, latitude, longitude,
  arr_morning - dep_morning AS net_morning,
  arr_evening - dep_evening AS net_evening
FROM dep
JOIN arr USING (station_id)
WHERE station_name NOT LIKE '%Valet%'
  AND station_name NOT LIKE '%Depot%'
  AND station_name NOT LIKE '%Bike-In%';

-- Quick look: biggest morning gainers and donors
SELECT * FROM `new_york_citibike.station_flow_2015` ORDER BY net_morning DESC LIMIT 10;
SELECT * FROM `new_york_citibike.station_flow_2015` ORDER BY net_morning ASC  LIMIT 10;

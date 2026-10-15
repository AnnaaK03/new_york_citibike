
-- Create a monthly route summary for Power BI.
-- Use the most frequent station name for each station ID.

CREATE OR REPLACE TABLE `new_york_citibike.routes_2015` AS

WITH stations AS (
  SELECT
    start_station_id AS station_id,
    start_station_name AS station_name
  FROM `new_york_citibike.clean_trips_2015`

  UNION ALL

  SELECT
    end_station_id AS station_id,
    end_station_name AS station_name
  FROM `new_york_citibike.clean_trips_2015`
),

station_names AS (
  SELECT
    station_id,
    station_name
  FROM stations
  WHERE station_id IS NOT NULL
  GROUP BY station_id, station_name
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY COUNT(*) DESC, station_name
  ) = 1
),

routes AS (
  SELECT
    month_num,
    start_station_id,
    end_station_id,
    COUNT(*) AS total_trips
  FROM `new_york_citibike.clean_trips_2015`
  GROUP BY
    month_num,
    start_station_id,
    end_station_id
)

SELECT
  r.month_num,
  r.start_station_id,
  s.station_name AS start_station_name,
  r.end_station_id,
  e.station_name AS end_station_name,
  r.total_trips

FROM routes AS r

LEFT JOIN station_names AS s
  ON r.start_station_id = s.station_id

LEFT JOIN station_names AS e
  ON r.end_station_id = e.station_id;


-- Create a monthly station flow summary for Power BI.
-- Calculate departures, arrivals, and net trip flow by station.

CREATE OR REPLACE TABLE `new_york_citibike.station_flow_2015` AS

WITH station_trips AS (
  SELECT
    month_num,
    start_station_id AS station_id,
    start_station_name AS station_name,
    1 AS departures,
    0 AS arrivals
  FROM `new_york_citibike.clean_trips_2015`

  UNION ALL

  SELECT
    EXTRACT(MONTH FROM stoptime) AS month_num,
    end_station_id AS station_id,
    end_station_name AS station_name,
    0 AS departures,
    1 AS arrivals
  FROM `new_york_citibike.clean_trips_2015`
  WHERE stoptime >= '2015-01-01'
    AND stoptime < '2016-01-01'
),

station_names AS (
  SELECT
    station_id,
    station_name
  FROM station_trips
  WHERE station_id IS NOT NULL
  GROUP BY station_id, station_name
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY COUNT(*) DESC, station_name
  ) = 1
)

SELECT
  st.month_num,
  st.station_id,
  sn.station_name,
  SUM(st.departures) AS departures,
  SUM(st.arrivals) AS arrivals,
  SUM(st.arrivals) - SUM(st.departures) AS net_flow

FROM station_trips AS st

LEFT JOIN station_names AS sn
  ON st.station_id = sn.station_id

GROUP BY
  st.month_num,
  st.station_id,
  sn.station_name;


-- Validate total departures and arrivals in the station flow summary.

SELECT
  SUM(departures) AS total_departures,
  SUM(arrivals) AS total_arrivals,
  SUM(net_flow) AS total_net_flow

FROM `new_york_citibike.station_flow_2015`;

# NYC Citi Bike | 2015 Trip Analysis

**SQL · Google BigQuery · Power BI**

## Overview

This project explores approximately 9.94 million Citi Bike trips recorded in New York City in 2015.

The analysis focuses on one main question:

**How does Citi Bike usage vary across time, user types, and stations?**

I used Google BigQuery to explore and prepare the data, investigate usage patterns, and follow up on findings with additional analysis. I then built a two-page Power BI dashboard to present the results.

## Power BI Dashboard

### Trip Demand & User Behavior

![Trip Demand & User Behavior](images/trip_demand.png)

Explores seasonal and hourly demand, differences between Customers and Subscribers, trip duration, and weekday versus weekend activity.

### Routes & Station Activity

![Routes & Station Activity](images/station_activity.png)

Examines frequently used station pairs, station-level departures and arrivals, and differences between incoming and outgoing trip volumes.

## Key Findings

### 1. Different User Types, Different Usage Patterns

Subscribers accounted for **86.8% of all trips**, but trip volume alone did not explain how the two groups used the service.

I started by comparing trip duration. Customers took longer trips on average (**29.4 vs. 12.8 minutes**). To check whether this difference was driven mainly by unusually long rides, I also compared median durations. The difference remained substantial (**20.5 vs. 9.6 minutes**).

This raised another question: **could the two groups be using Citi Bike for different purposes?**

I explored this by looking at weekend activity. Weekend trips accounted for **43.42% of Customer trips**, compared with **20.42% for Subscribers**.

I also examined trips that started and ended at the same station. These were nearly five times more common among Customers, adding another indication of different usage patterns.

Together, these findings suggest more leisure-oriented usage among Customers and more routine travel among Subscribers. Since trip purpose is not recorded, this remains an interpretation rather than a confirmed explanation.

### 2. Demand Patterns Across Time

Trip demand varied considerably throughout the year. September recorded approximately **1.29 million trips**, compared with around **197,000 in February**.

I then examined hourly demand to understand how activity differed between weekdays and weekends.

Weekdays showed clear morning and evening peaks, while weekend trips were more concentrated during the daytime.

To make this comparison meaningful, I normalized hourly trip counts by the number of weekdays and weekend days rather than comparing raw totals.

These patterns show that demand differs not only across months but also throughout the week.

### 3. Routes and Station Activity

I explored frequently used station pairs and compared trip activity across stations.

The route analysis also included trips that started and ended at the same station, providing another perspective on the usage patterns examined earlier.

At the station level, I compared recorded arrivals and departures using:

**Net Flow = Arrivals − Departures**

This helped identify stations with differences between incoming and outgoing trip volumes.

Net Flow describes recorded trip activity, not actual bicycle availability. It does not account for operational bike movements and therefore cannot independently establish whether a station needs rebalancing.

## Data Preparation & Methodology

Data exploration and preparation were performed using SQL in Google BigQuery.

- Checked missing values, duplicate records, trip durations, and timestamp consistency.
- Created `clean_trips_2015` with additional date and time fields.
- Built `routes_2015` and `station_flow_2015` for route and station-level analysis.
- Retained flagged records in overall trip counts rather than automatically removing unusual trips.
- Excluded trips longer than 24 hours from duration comparisons.
- Used station IDs to identify stations and station pairs.
- Normalized weekday and weekend hourly demand by the corresponding number of calendar days.

### Limitations

The dataset represents trips, not unique riders, and does not identify trip purpose.

The analysis is based on historical data from 2015 and does not include external factors such as weather or operational bike movements. These limitations should be considered when interpreting the findings or applying them to operational decisions.

## Repository Structure

```text
new_york_citibike/
├── README.md
├── sql/
│   ├── 01_data_preparation.sql
│   ├── 02_demand_patterns.sql
│   ├── 03_user_behavior.sql
│   └── 04_routes_and_stations.sql
├── dashboard/
│   └── CitiBike_2015_Design.pbix
└── images/
    ├── trip_demand.png
    └── station_activity.png
```

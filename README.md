# 🚲 NYC Citi Bike Trip Analysis | 2015

**SQL Data Analysis Portfolio Project**

**Tools:** Google BigQuery (SQL) · Power BI (In Progress)  
**Dataset:** NYC Citi Bike Trip Histories  
**Period:** January–December 2015  
**Total Trips:** 9,937,969

---

## 📌 Project Overview

This project explores **9.94 million Citi Bike trips** recorded in New York City during 2015.

The objective is to understand how bike-sharing demand changes over time, how trip behavior differs between user categories, and which routes and stations experience the highest activity.

Beyond calculating metrics, the analysis focuses on **data quality, analytical reasoning, and careful interpretation of results**.

The project follows a structured workflow:

**Data Exploration → Data Quality Assessment → Data Preparation → SQL Analysis → Power BI Visualization**

---

## 🎯 Business Questions

The analysis addresses four key areas:

1. **Trip Demand:** How does ridership vary by month, day of the week, and hour?
2. **User Behavior:** How do Subscriber and Customer trips differ in duration and weekend usage?
3. **Route Popularity:** Which station-to-station routes are most frequently used?
4. **Station Activity:** Which stations have the highest departures and arrivals, and where do imbalances occur?

---

## 🧹 Data Preparation & Quality Assessment

Before performing the analysis, the dataset was examined for:

- Missing values and invalid trip durations
- Duplicate records
- Unusually long trips
- Station ID and station name inconsistencies

### 1. Handling Long-Duration Trips

The dataset contained **2,591 trips lasting more than 24 hours**, representing approximately **0.03%** of all trips.

Some trips lasted several days or even weeks, these observations are unusual for a bike-sharing service

**Decision:**

- Retain all trips in the main analytical dataset.
- Include long-duration trips in overall trip counts and demand analysis.
- Exclude trips exceeding 24 hours when calculating average and median trip duration.

**Reasoning:** Removing these records entirely could distort demand metrics, while including extreme durations in typical trip-duration calculations could make those statistics less representative.

### 3. Station Name Consistency

Some station IDs were associated with more than one station name.

Grouping by station name could therefore split activity belonging to the same station.

**Decision:**

- Use station IDs to identify routes and stations.
- Select the most frequently recorded name for each station ID when preparing reporting tables.

This preserves consistent station-level aggregation.

### 4. Analytical Tables

Three tables were prepared in BigQuery:

| Table | Purpose |
|---|---|
| `clean_trips_2015` | Trip-level analytical dataset with additional date and time features |
| `routes_2015` | Monthly trip counts by starting and ending station |
| `station_flow_2015` | Monthly departures, arrivals, and net flow by station |

**Why use aggregated tables?**

The main dataset contains nearly 10 million records. Preparing route and station summaries in BigQuery simplifies Power BI calculations and reduces the volume of data required for these visualizations.

---

## 📊 Key Findings

### 1. Trip Demand & Seasonality

Trip demand varied significantly throughout the year.

| Metric | Result |
|---|---|
| Total trips | **9,937,969** |
| Highest-demand month | **September — 1,289,699 trips** |
| Lowest-demand month | **February — 196,930 trips** |
| Busiest hour | **5 PM — 970,198 trips** |

**Daily and hourly patterns:**

- Weekday demand showed pronounced peaks around **8 AM** and **5–6 PM**.
- Weekend activity was more concentrated during afternoon hours.
- Trip volumes were substantially higher during warmer months than in winter.

**Interpretation:**

The weekday peaks are consistent with commuting-related activity, while weekend afternoon usage suggests a different demand pattern.

However, **trip timing does not directly reveal why a person traveled**. Commuting and recreational use are plausible interpretations, not confirmed trip purposes.

### 2. Subscriber vs Customer Behavior

The dataset distinguishes between two user categories:

| User Type | Total Trips | Share |
|---|---:|---:|
| Subscriber | 8,626,638 | 86.8% |
| Customer | 1,311,331 | 13.2% |

Subscribers accounted for the majority of recorded trips.

#### Trip Duration Comparison

For trips lasting no more than 24 hours:

| Metric | Subscriber | Customer |
|---|---:|---:|
| Average trip duration | **12.8 min** | **29.4 min** |
| Median trip duration | **9.6 min** | **20.5 min** |
| Weekend trip share | **20.42%** | **43.42%** |

#### Analytical Reasoning

**Initial observation:** Customer trips had a substantially higher average duration than Subscriber trips.

However, relying on the average alone could be misleading because unusually long trips can increase the mean.

**Additional checks:**

1. **Median duration:** The median was also considerably higher for Customer trips, supporting the observation that the difference is not limited to extreme values.
2. **Weekend usage:** Customers had a substantially larger share of trips on weekends.
3. **Trip-level interpretation:** The dataset measures trips, not unique riders. Frequent users may contribute multiple observations.

**Same-Station Trip Behavior**

Customer trips were approximately **4.9 times more likely to start and end at the same station** than Subscriber trips (7.25% vs. 1.47%).
Combined with longer trip durations and a higher weekend trip share, this finding supports the hypothesis that Customer trips are more frequently associated with recreational use.
However, trip purpose is not directly recorded in the dataset, so this remains an interpretation rather than a confirmed explanation.

**Conclusion:**

Customer-category trips were typically longer than Subscriber-category trips, and a larger proportion occurred on weekends.

These patterns are **consistent with greater recreational usage among Customers**, but the dataset does not directly establish individual travel motivations.

We therefore cannot conclude that every Customer rides longer than every Subscriber, or that all Customer trips are recreational.

### 3. Popular Routes

Routes were defined using combinations of **starting station ID and ending station ID**.

The analysis identified both point-to-point routes and trips that started and ended at the same station.

The most frequently recorded directional route was:

**Central Park S & 6 Ave → Central Park S & 6 Ave**

**18,873 trips**

**Interpretation:**

Same-station trips should not automatically be treated as errors. They may represent legitimate round trips, including recreational rides.

For this reason, these trips were retained in the route analysis.

### 4. Station Activity & Net Flow

Station activity was evaluated using three metrics:

- **Departures:** Trips starting at a station
- **Arrivals:** Trips ending at a station
- **Net Flow:** Arrivals − Departures

A positive net flow indicates more recorded arrivals than departures. A negative value indicates more departures than arrivals.

**Example — W 52 St & 11 Ave, September 2015:**

| Metric | Value |
|---|---:|
| Departures | 3,667 |
| Arrivals | 3,534 |
| Net Flow | **−133** |

The station recorded 133 more departures than arrivals during September.

**Important limitation:**

Net flow measures the balance of recorded trips, **not the actual number of available bicycles**.

Citi Bike may redistribute bicycles between stations through operational activities that are not represented in the trip history dataset.

Therefore, a negative net flow alone does not prove that a station experienced a bicycle shortage.

---

## ✅ Data Validation

The aggregated tables were checked against the main analytical dataset.

| Validation Check | Result |
|---|---:|
| Trips in main dataset | 9,937,969 |
| Total trips in route summary | 9,937,969 |
| Total station departures | 9,937,969 |
| Total station arrivals | 9,937,860 |
| Overall station net flow | −109 |

The difference of **109 trips** between departures and arrivals is consistent with the reporting logic: departures are counted for trips starting in 2015, while arrivals are included only when the trip ended within 2015.

The exact composition of those 109 records has not been separately verified.

---

## ⚠️ Limitations

Several limitations should be considered when interpreting the findings:

- **Single-year analysis:** Results describe 2015 and should not automatically be generalized to other years.
- **Trips vs. riders:** Trip counts do not represent the number of unique individuals.
- **Unknown trip purpose:** Commuting and recreational activity are inferred from patterns, not directly observed.
- **Long-duration records:** Extreme durations may reflect unusual usage or recording issues; their exact causes cannot always be established.
- **Operational data:** The dataset does not include bicycle redistribution, station capacity, or real-time availability.
- **Arrival reporting period:** Trips starting in 2015 but ending outside the year can contribute to departures without contributing to 2015 arrivals.

---

## 📈 Power BI Dashboard

**Status: In Progress**

The dashboard will contain two analytical pages:

**Page 1 — Trip Demand & Rider Behavior**

- Total trips and monthly demand
- Weekday and hourly usage patterns
- Weekday vs. weekend activity
- Subscriber vs. Customer comparison
- Trip duration metrics

**Page 2 — Routes & Station Flow**

- Most popular routes
- Station departures and arrivals
- Monthly station activity
- Net flow and station-level imbalances

Dashboard screenshots and interactive report details will be added after development.

---

## 📁 Repository Structure

```text
nyc-citibike-trip-analysis/
│
├── README.md
│
├── sql/
│   ├── 01_clean_data.sql
│   ├── 02_demand_patterns.sql
│   ├── 03_riders.sql
│   ├── 04_routes_stations.sql
│   └── 05_station_net_flow.sql
│
└── dashboard/
    └── (Power BI report to be added)
```

---

## 💡 Project Takeaways

This project demonstrates practical skills in:

- **SQL data exploration and quality assessment**
- **Data preparation and feature engineering**
- **Conditional aggregation and analytical queries**
- **Mean vs. median comparisons**
- **Temporal demand and user segmentation analysis**
- **Route and station-level aggregation**
- **Data validation and reporting preparation**
- **Interpreting findings without overstating conclusions**

**The central analytical principle of this project is to distinguish what the data shows from what it only suggests.**

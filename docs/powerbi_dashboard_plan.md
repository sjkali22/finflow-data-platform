# FinFlow Power BI Dashboard Plan

This document defines the planned Power BI dashboard for FinFlow.

The dashboard will use the existing dbt models and reporting SQL queries to turn the engineered transaction data into business-facing monitoring views.

## Dashboard Objective

The dashboard is designed for a fictional financial services client that needs to monitor transaction activity and suspicious behaviour.

The dashboard should help users review:

- Transaction volume
- Transaction value
- Fraud rate
- Suspicious activity
- High-value transactions
- Channel performance
- Merchant category activity

## Target Users

The planned dashboard is intended for:

- Financial crime monitoring team
- Analytics team
- Operations team
- Data engineering team
- Business stakeholders

## Data Sources

The first Power BI version should use the existing reporting SQL queries:

```text
dashboard/queries/daily_transaction_volume.sql
dashboard/queries/transaction_type_summary.sql
dashboard/queries/suspicious_activity_summary.sql
dashboard/queries/high_value_transactions.sql
dashboard/queries/channel_summary.sql
dashboard/queries/merchant_category_summary.sql
dashboard/queries/risk_band_trend.sql
```

These queries read from the dbt staging and mart models in PostgreSQL.

## Proposed Dashboard Pages

### Page 1 - Executive Overview

Suggested visuals:

- KPI card: total transactions
- KPI card: total transaction value
- KPI card: fraud rate
- KPI card: suspicious transaction count
- Line chart: daily transaction volume
- Bar chart: transaction value by transaction type
- Donut or bar chart: transaction volume by channel

### Page 2 - Suspicious Activity Monitoring

Suggested visuals:

- KPI card: suspicious transaction count
- Bar chart: suspicious activity by risk band
- Line chart: risk band trend over time
- Table: suspicious transactions
- Filters: transaction type, channel, merchant category, risk band

### Page 3 - Transaction Type Analysis

Suggested visuals:

- Bar chart: total transaction value by type
- Bar chart: transaction count by type
- Table: transaction type metrics
- Fraud rate by transaction type

### Page 4 - High-Value Transactions

Suggested visuals:

- Table of high-value transactions
- KPI: count of high-value transactions
- KPI: total high-value transaction amount
- Breakdown by channel
- Breakdown by transaction type

### Page 5 - Channel and Merchant Category Analysis

Suggested visuals:

- Channel summary
- Merchant category summary
- Transaction value by channel
- Transaction value by merchant category

## KPI Definitions

| KPI | Definition |
| --- | --- |
| Total transactions | Count of transaction records in the selected reporting context. |
| Total transaction value | Sum of transaction amounts in the selected reporting context. |
| Average transaction value | Total transaction value divided by total transactions. |
| Fraud transaction count | Count of transactions where `is_fraud = 1`. |
| Fraud rate percentage | Fraud transaction count divided by total transactions, shown as a percentage. |
| Suspicious transaction count | Count of transactions in `analytics.mart_suspicious_activity`. |
| High-value transaction count | Count of transactions in `analytics.mart_high_value_transactions`. |
| Suspicious risk band | Risk category derived from `suspicious_score`, such as low, medium, high, or critical. |

## Suggested Filters and Slicers

Suggested report filters:

- Transaction date
- Transaction type
- Channel
- Merchant category
- Suspicious risk band
- Location

## Power BI Build Approach

The first dashboard build should stay local and simple:

- Connect Power BI to local PostgreSQL.
- Use the existing reporting SQL queries as source queries.
- Build visuals page by page.
- Validate totals against the dbt marts and SQL query outputs.
- Take screenshots for GitHub evidence after the dashboard is ready.
- Keep `.pbix` files out of Git unless a later decision is made to commit one.

The initial portfolio evidence should use screenshots rather than committing the Power BI binary file.

## Portfolio Value

The dashboard supports the FinFlow portfolio project by showing that the engineered data can be used for business-facing insight.

It helps demonstrate:

- An end-to-end pipeline from ingestion to reporting.
- How dbt marts support analytics and monitoring use cases.
- How technical pipeline outputs translate into business value.
- A clear client/problem framing for interviews.

## Future Enhancements

Potential later improvements:

- Scheduled refresh
- Snowflake source instead of local PostgreSQL
- S3 raw storage
- Airflow-triggered reporting refresh
- More advanced fraud rules

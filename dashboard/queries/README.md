# FinFlow Reporting SQL Queries

This folder contains reporting-ready SQL queries for dashboard and Power BI development.

The queries read from the dbt staging and mart models in the `analytics` schema. They are designed to support transaction monitoring, fraud analysis, suspicious activity reporting, and later dashboard evidence.

## How To Run Manually

Start the local Docker services:

```powershell
docker compose up -d
```

Open PostgreSQL:

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

Then copy and run the SQL from one of the files in this folder.

If running from a local PostgreSQL client, connect to:

```text
Host: localhost
Port: 5432
Database: finflow
Schema: analytics
```

## Query Guide

| Query | Source model | Dashboard use |
| --- | --- | --- |
| `daily_transaction_volume.sql` | `analytics.mart_daily_transaction_volume` | Daily transaction volume, value, and fraud trend visuals |
| `transaction_type_summary.sql` | `analytics.mart_transaction_type_summary` | Transaction type comparison charts |
| `suspicious_activity_summary.sql` | `analytics.mart_suspicious_activity` | Suspicious activity by risk band |
| `high_value_transactions.sql` | `analytics.mart_high_value_transactions` | High-value transaction detail table |
| `channel_summary.sql` | `analytics.stg_transactions` | Channel breakdown visuals |
| `merchant_category_summary.sql` | `analytics.stg_transactions` | Merchant category breakdown visuals |
| `risk_band_trend.sql` | `analytics.mart_suspicious_activity` | Suspicious risk band trend over time |

These queries are intentionally kept separate from dbt models. dbt owns transformation logic; this folder provides dashboard-facing query examples.

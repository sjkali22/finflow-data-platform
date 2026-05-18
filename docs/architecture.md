# FinFlow Architecture

FinFlow is a local-first data engineering platform for financial transaction monitoring and reporting.

The project is designed to show how raw transaction data can be generated, stored, loaded, transformed, tested, and prepared for analytics using widely recognised data engineering tools.

## Current Local MVP Architecture

```text
Synthetic transaction generator
        ↓
data/raw/transactions_sample.csv
        ↓
Python PostgreSQL loader
        ↓
PostgreSQL public.raw_transactions
        ↓
dbt staging model
        ↓
dbt intermediate models
        ↓
dbt mart models
        ↓
SQL analysis / future Power BI dashboard
```

## Current Components

| Component        | Tool                       | Purpose                                                                     |
| ---------------- | -------------------------- | --------------------------------------------------------------------------- |
| Data generation  | Python                     | Creates realistic synthetic financial transaction data                      |
| Raw file storage | Local filesystem           | Stores generated CSV files under `data/raw/`                                |
| Database         | PostgreSQL in Docker       | Local landing database for raw transaction records                          |
| Loading          | Python, pandas, SQLAlchemy | Loads CSV data into PostgreSQL                                              |
| Transformation   | dbt                        | Builds staging, intermediate, and mart models                               |
| Testing          | dbt tests                  | Validates key fields, accepted values, uniqueness, and not-null constraints |
| Version control  | Git/GitHub                 | Tracks project history and supports portfolio visibility                    |

## Database Layers

### Raw Layer

The raw layer stores source-like transaction records loaded from CSV.

Current table:

```text
public.raw_transactions
```

This table is created by:

```text
sql/ddl/create_raw_transactions.sql
```

and loaded by:

```text
ingestion/load_postgres.py
```

### Staging Layer

The staging layer cleans and standardises raw data.

Current model:

```text
analytics.stg_transactions
```

Key responsibilities:

- Standardise transaction type casing
- Standardise channel and merchant category casing
- Derive transaction date from transaction timestamp
- Preserve raw fraud indicators
- Prepare clean fields for downstream models

### Intermediate Layer

The intermediate layer prepares reusable business logic.

Current models:

```text
analytics.int_daily_transaction_summary
analytics.int_transaction_type_summary
analytics.int_suspicious_transaction_flags
```

Key responsibilities:

- Aggregate transaction values by day
- Aggregate transaction values by transaction type
- Add suspicious transaction rule flags
- Calculate suspicious activity scores

### Mart Layer

The mart layer provides analytics-ready reporting tables.

Current models:

```text
analytics.mart_daily_transaction_volume
analytics.mart_transaction_type_summary
analytics.mart_suspicious_activity
analytics.mart_high_value_transactions
```

Key responsibilities:

- Provide daily transaction reporting metrics
- Provide transaction type performance and fraud summaries
- Provide suspicious activity monitoring output
- Provide high-value transaction reporting output

## Current dbt Model Flow

```text
public.raw_transactions
        ↓
analytics.stg_transactions
        ↓
analytics.int_daily_transaction_summary
        ↓
analytics.mart_daily_transaction_volume

public.raw_transactions
        ↓
analytics.stg_transactions
        ↓
analytics.int_transaction_type_summary
        ↓
analytics.mart_transaction_type_summary

public.raw_transactions
        ↓
analytics.stg_transactions
        ↓
analytics.int_suspicious_transaction_flags
        ↓
analytics.mart_suspicious_activity
        ↓
analytics.mart_high_value_transactions
```

## Data Quality Approach

The current project uses dbt tests to validate:

- Primary identifiers are not null
- Transaction IDs are unique
- Transaction types are accepted values
- Channels are accepted values
- Fraud flags are accepted values
- Reporting dates are not null
- Mart-level keys are unique

## Future Architecture

The planned production-style architecture is:

```text
Financial transaction CSV/API
        ↓
Python ingestion/generation script
        ↓
Raw file storage: local data/raw first, later AWS S3
        ↓
PostgreSQL local landing database
        ↓
dbt transformations
        ↓
Snowflake cloud warehouse later
        ↓
dbt staging/intermediate/mart models
        ↓
dbt tests / data quality checks
        ↓
Power BI dashboard/reporting
        ↓
Airflow orchestration
        ↓
GitHub Actions CI
```

## Planned Future Components

| Future Component                | Purpose                                                  |
| ------------------------------- | -------------------------------------------------------- |
| Apache Airflow                  | Orchestrate ingestion, loading, dbt runs, and dbt tests  |
| AWS S3 or S3-compatible storage | Store raw transaction files in a cloud-style data lake   |
| Snowflake                       | Use a cloud data warehouse for analytics transformations |
| Power BI                        | Build reporting dashboard for transaction monitoring     |
| GitHub Actions                  | Add automated checks for code and dbt project validation |
| Great Expectations              | Optional additional data quality framework               |

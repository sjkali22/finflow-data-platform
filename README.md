# FinFlow — Financial Transactions Data Engineering Platform

FinFlow is a production-style data engineering portfolio project built for a fictional financial services client.

The project demonstrates how financial transaction data can be generated, stored, loaded, transformed, tested, documented, and prepared for analytics using widely recognised data engineering tools.

## Business Problem

A fictional financial services client needs an automated daily data pipeline that ingests transaction data, stores raw files in a cloud-style data lake, loads records into a warehouse, transforms them into analytics-ready tables, validates data quality, and produces reporting outputs for transaction monitoring and suspicious activity analysis.

## Project Summary

FinFlow currently implements a local batch data pipeline using Python, PostgreSQL, Docker, and dbt.

The current pipeline:

1. Generates synthetic financial transaction data
2. Stores the raw CSV file locally
3. Loads raw records into PostgreSQL
4. Builds dbt staging, intermediate, and mart models
5. Runs dbt data quality tests
6. Generates dbt documentation and lineage
7. Provides analytics-ready marts for transaction monitoring

## Current Status

Current phase:

```text
Phase 3 — Airflow orchestration in progress
```

Completed so far:

- Project structure created
- GitHub repository created
- PostgreSQL Docker Compose setup added
- Synthetic transaction data generator added
- Sample transaction CSV generated
- Raw transaction table created
- Transaction data loaded into PostgreSQL
- dbt project configured for PostgreSQL
- dbt staging model created
- dbt intermediate models created
- dbt reporting mart models created
- dbt tests added and passing
- dbt docs generated locally
- Project documentation added

## Tech Stack

Current stack:

| Area              | Tool                    |
| ----------------- | ----------------------- |
| Programming       | Python                  |
| Data manipulation | pandas                  |
| Database          | PostgreSQL              |
| Containerisation  | Docker / Docker Compose |
| Transformation    | dbt                     |
| Data quality      | dbt tests               |
| Version control   | Git / GitHub            |
| Documentation     | Markdown, dbt docs      |

Planned additions:

| Area                | Tool                            |
| ------------------- | ------------------------------- |
| Orchestration       | Apache Airflow                  |
| Cloud raw storage   | AWS S3 or S3-compatible storage |
| Cloud warehouse     | Snowflake                       |
| Reporting           | Power BI                        |
| CI/CD               | GitHub Actions                  |
| Optional validation | Great Expectations              |

## Current Architecture

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

More detail is available in:

```text
docs/architecture.md
```

## Repository Structure

```text
finflow-data-platform/
  README.md
  .gitignore
  .env.example
  requirements.txt
  docker-compose.yml
  docs/
    architecture.md
    data_dictionary.md
    data_sources.md
    governance_notes.md
    setup_windows.md
  data/
    raw/
      transactions_sample.csv
    processed/
    sample/
  ingestion/
    __init__.py
    generate_sample_transactions.py
    load_postgres.py
  sql/
    ddl/
      create_raw_transactions.sql
    exploratory/
      basic_transaction_checks.sql
  dbt/
    finflow_dbt/
      models/
        staging/
        intermediate/
        marts/
  tests/
  dashboard/
    screenshots/
  .github/
    workflows/
```

## Data

The current version uses synthetic financial transaction data generated inside the project.

The dataset contains 1,000 sample transactions with fields including:

- transaction_id
- transaction_datetime
- transaction_type
- amount
- origin_account
- destination_account
- old_balance_origin
- new_balance_origin
- old_balance_destination
- new_balance_destination
- is_fraud
- is_flagged_fraud
- merchant_category
- location
- channel

More detail is available in:

```text
docs/data_sources.md
docs/data_dictionary.md
```

## dbt Models

### Raw Layer

| Object                  | Description                                                 |
| ----------------------- | ----------------------------------------------------------- |
| public.raw_transactions | Raw synthetic financial transaction records loaded from CSV |

### Staging Layer

| Model                      | Description                                  |
| -------------------------- | -------------------------------------------- |
| analytics.stg_transactions | Cleaned and standardised transaction records |

### Intermediate Layer

| Model                                      | Description                                        |
| ------------------------------------------ | -------------------------------------------------- |
| analytics.int_daily_transaction_summary    | Daily transaction volume, value, and fraud summary |
| analytics.int_transaction_type_summary     | Aggregated metrics by transaction type             |
| analytics.int_suspicious_transaction_flags | Transaction-level suspicious activity rule flags   |

### Mart Layer

| Model                                   | Description                                   |
| --------------------------------------- | --------------------------------------------- |
| analytics.mart_daily_transaction_volume | Final daily transaction monitoring table      |
| analytics.mart_transaction_type_summary | Final transaction type reporting table        |
| analytics.mart_suspicious_activity      | Final suspicious activity monitoring table    |
| analytics.mart_high_value_transactions  | Final high-value transaction monitoring table |

## Data Quality Tests

The project currently uses dbt tests to validate:

- Unique transaction IDs
- Not-null transaction IDs
- Not-null transaction dates
- Accepted transaction types
- Accepted transaction channels
- Accepted fraud flag values
- Unique reporting dates in daily marts
- Unique transaction types in type summary marts
- Not-null reporting metrics

Current dbt test result:

```text
PASS=68 WARN=0 ERROR=0
```

## Local Setup — Windows

### 1. Clone the repository

```powershell
git clone https://github.com/sjkali22/finflow-data-platform.git
cd finflow-data-platform
```

### 2. Create a local environment file

```powershell
Copy-Item .env.example .env
```

Update `.env` if needed.

Default local development values:

```text
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=finflow
POSTGRES_USER=finflow_user
POSTGRES_PASSWORD=finflow_password
```

### 3. Create and activate a Python virtual environment

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### 4. Install dependencies

```powershell
pip install -r requirements.txt
```

### 5. Start local Docker services

```powershell
docker compose up -d
```

This starts PostgreSQL and the local Airflow services.

Airflow UI:

```text
http://localhost:8080
```

Local Airflow login:

```text
Username: admin
Password: admin
```

Current local DAG:

```text
finflow_local_pipeline
```

The DAG runs the local pipeline in order: generate transactions, load PostgreSQL, run dbt models, and run dbt tests.

Check the containers:

```powershell
docker ps
```

Expected container:

```text
finflow-postgres
```

### 6. Generate sample transaction data

```powershell
python ingestion/generate_sample_transactions.py
```

This creates:

```text
data/raw/transactions_sample.csv
```

### 7. Load transactions into PostgreSQL

```powershell
python ingestion/load_postgres.py
```

Expected output:

```text
Created raw_transactions table
Loaded 1000 rows into raw_transactions
```

### 8. Run dbt models

```powershell
cd dbt\finflow_dbt
dbt run
```

Expected result:

```text
PASS=8 WARN=0 ERROR=0
```

### 9. Run dbt tests

```powershell
dbt test
```

Expected result:

```text
PASS=68 WARN=0 ERROR=0
```

### 10. Generate dbt documentation

```powershell
dbt docs generate
dbt docs serve
```

The local dbt documentation site usually opens at:

```text
http://localhost:8080
```

## Useful Commands

Start PostgreSQL:

```powershell
docker compose up -d
```

Stop PostgreSQL:

```powershell
docker compose down
```

Reset PostgreSQL and delete the local database volume:

```powershell
docker compose down -v
```

Connect to PostgreSQL:

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

Run the full local pipeline manually:

```powershell
python ingestion/generate_sample_transactions.py
python ingestion/load_postgres.py
cd dbt\finflow_dbt
dbt run
dbt test
```

## Example SQL Checks

Check raw transaction count:

```sql
SELECT COUNT(*) FROM public.raw_transactions;
```

Check daily mart count:

```sql
SELECT COUNT(*) FROM analytics.mart_daily_transaction_volume;
```

Check suspicious activity risk bands:

```sql
SELECT
    suspicious_risk_band,
    COUNT(*) AS transaction_count
FROM analytics.mart_suspicious_activity
GROUP BY suspicious_risk_band
ORDER BY transaction_count DESC;
```

## Documentation

| Document                     | Purpose                                                    |
| ---------------------------- | ---------------------------------------------------------- |
| `docs/architecture.md`       | Explains current and future architecture                   |
| `docs/data_sources.md`       | Documents current and future data sources                  |
| `docs/data_dictionary.md`    | Documents raw, staging, intermediate, and mart fields      |
| `docs/orchestration_plan.md` | Plans the Apache Airflow orchestration layer               |
| `docs/governance_notes.md`   | Explains privacy, secrets, reproducibility, and governance |
| `docs/setup_windows.md`      | Windows setup guide                                        |

## Portfolio Evidence

Evidence collected or planned:

- Docker container running
- PostgreSQL raw table populated
- dbt run success
- dbt test success
- dbt docs site
- dbt lineage graph
- dbt model pages
- GitHub repository structure
- Final architecture diagram
- Future Power BI dashboard

Screenshots should be stored under:

```text
dashboard/screenshots/
```

## Governance Notes

The project uses synthetic data only.

It does not contain:

- Real customer data
- Real account data
- Real bank data
- Real personal data
- Real merchant data

Local secrets are stored in `.env`, which is ignored by Git.

A safe template is provided in:

```text
.env.example
```

More detail is available in:

```text
docs/governance_notes.md
```

## Roadmap

### Completed

- Local project structure
- PostgreSQL Docker setup
- Synthetic data generation
- PostgreSQL loading
- dbt staging model
- dbt intermediate models
- dbt mart models
- dbt tests
- dbt docs
- Core documentation
- Airflow local Docker services
- Airflow local pipeline DAG

### Next

- Add Airflow screenshots and evidence files
- Add Power BI reporting output

### Later

- Add S3-compatible raw storage
- Add Snowflake warehouse
- Move dbt transformations to Snowflake
- Add cloud architecture documentation
- Optional Great Expectations validation
- Optional larger public dataset extension

## CV Summary

FinFlow is an end-to-end batch data engineering platform for a fictional financial services client. It uses Python and SQL to generate, ingest, load, transform, and validate transaction data. The project includes a PostgreSQL landing database, Docker-based local development environment, dbt staging/intermediate/mart models, automated dbt data quality tests, and analytics-ready outputs for transaction monitoring and suspicious activity analysis.

## Technologies

Python, SQL, PostgreSQL, Docker, Docker Compose, dbt, pandas, SQLAlchemy, Git, GitHub.

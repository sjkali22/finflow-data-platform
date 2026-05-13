# FinFlow — Financial Transactions Data Engineering Platform

FinFlow is a production-style data engineering portfolio project built for a fictional financial services client.

The project demonstrates how financial transaction data can be ingested, stored, transformed, tested, orchestrated, and prepared for reporting using widely used data engineering tools.

## Business Problem

A fictional financial services client needs an automated daily data pipeline that ingests transaction data, stores raw files in a cloud-style data lake, loads records into a warehouse, transforms them into analytics-ready tables, validates data quality, and produces reporting outputs for transaction monitoring and suspicious activity analysis.

## Project Goals

- Generate or ingest realistic financial transaction data
- Store raw files locally first, then later in S3-compatible cloud storage
- Load raw records into PostgreSQL
- Transform data using SQL and dbt
- Add data quality tests
- Orchestrate the pipeline using Apache Airflow
- Upgrade the warehouse layer to Snowflake
- Build reporting outputs using Power BI
- Document the project professionally for CV, GitHub, LinkedIn, and job applications

## Target Users

This project is framed as a client delivery project for a fictional retail banking or financial services organisation.

Example users:

- Data engineering team
- Analytics team
- Financial crime monitoring team
- Business reporting team
- Operations team

## Current Phase

Phase 1 — Local MVP

The current version focuses on:

- Python
- SQL
- PostgreSQL
- Docker Compose
- Git/GitHub
- Local CSV generation
- Local CSV ingestion
- Basic SQL analysis

## Current Features

- Docker Compose PostgreSQL setup
- Local `.env` configuration for database credentials
- Synthetic financial transaction data generator
- 1,000-row sample transaction CSV
- PostgreSQL raw table creation script
- Python loader for inserting transaction data into PostgreSQL
- Basic exploratory SQL checks

## Planned Tech Stack

Core stack:

- Python
- SQL
- PostgreSQL
- Docker Compose
- Git/GitHub

Later additions:

- dbt
- Apache Airflow
- AWS S3 or S3-compatible storage
- Snowflake
- Power BI
- GitHub Actions
- Optional Great Expectations
- Optional PySpark/Databricks after the main project is complete

## Planned Architecture

```text
Financial transaction CSV/API
        ↓
Python ingestion/generation script
        ↓
Raw file storage: data/raw locally, later AWS S3
        ↓
PostgreSQL local landing database
        ↓
dbt transformations
        ↓
Analytics-ready marts
        ↓
dbt tests / data quality checks
        ↓
Power BI dashboard/reporting
        ↓
Airflow orchestration
        ↓
GitHub Actions CI
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
  tests/
  dashboard/
    screenshots/
  .github/
    workflows/
```

## Data

The first version uses synthetic financial transaction data generated inside the project.

The generated dataset includes 1,000 sample transactions with the following fields:

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

## Transaction Types

The sample data includes:

- PAYMENT
- TRANSFER
- CASH_OUT
- CASH_IN
- DEBIT

## Channels

The sample data includes:

- mobile_app
- online_banking
- atm
- branch
- card_terminal

## Phase 1 Local Setup

### 1. Clone the repository

```powershell
git clone https://github.com/sjkali22/finflow-data-platform.git
cd finflow-data-platform
```

### 2. Create a local environment file

```powershell
Copy-Item .env.example .env
```

Update `.env` with local database credentials if needed.

### 3. Create and activate a Python virtual environment

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### 4. Install Python dependencies

```powershell
pip install -r requirements.txt
```

### 5. Start PostgreSQL with Docker Compose

```powershell
docker compose up -d
```

Check that the container is running:

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

Database checks:
- Total rows: 1000
- Earliest transaction: 2025-01-01 00:28:02
- Latest transaction: 2025-05-01 18:47:32
```

## PostgreSQL Table

The current raw landing table is:

```text
raw_transactions
```

This table stores the generated transaction records before later transformation with dbt.

## Basic SQL Checks

Exploratory SQL queries are stored in:

```text
sql/exploratory/basic_transaction_checks.sql
```

Current checks include:

- Total transaction count
- Transaction date range
- Transaction count by type
- Transaction value by type
- Transaction count by channel
- Fraud summary
- High-value transactions

## Data Quality Checks

Planned checks include:

- Transaction IDs must not be null
- Transaction IDs must be unique
- Transaction datetime must not be null
- Transaction type must be valid
- Amount must be greater than or equal to zero
- Origin and destination accounts must not be null
- Fraud flags must be valid boolean values
- Final mart keys should be unique

## Portfolio Evidence To Collect

Planned evidence:

- Docker containers running
- PostgreSQL tables populated
- SQL query results
- dbt run success
- dbt test success
- Airflow DAG success
- Snowflake schemas and tables
- S3 raw files
- Power BI dashboard
- GitHub Actions passing
- Architecture diagram

## Status

Phase 1 local MVP is in progress.

Completed so far:

- Project structure created
- GitHub repository created
- PostgreSQL Docker Compose setup added
- Synthetic transaction data generator added
- Sample transaction CSV generated
- Raw transactions table created
- Transaction data loaded into PostgreSQL
- Basic SQL checks added

Next planned step:

- Add more structured SQL analysis and prepare for dbt transformations

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

The first version focuses on:

- Python
- SQL
- PostgreSQL
- Docker Compose
- Git/GitHub
- Local CSV ingestion
- Basic SQL analysis

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

# FinFlow Airflow Orchestration Plan

This document defines the planned Apache Airflow orchestration layer for FinFlow.

The current project already has a working local pipeline using Python, PostgreSQL, Docker, and dbt. Airflow will be added as the next orchestration layer after the pipeline has been proven to run manually.

## Why Airflow Is Being Added

Airflow is being added to show how the FinFlow pipeline would be scheduled, monitored, retried, and operated in a production-style environment.

The current manual workflow proves that each technical step works. Airflow will connect those steps into a repeatable daily data pipeline with clear task order, logs, and failure points.

This improves the project by demonstrating:

- Workflow orchestration
- Dependency management between ingestion, loading, transformation, and testing
- Operational logging and retry behaviour
- A realistic path from local development to cloud scheduling
- A stronger portfolio story for junior data engineering roles

## What Airflow Will Orchestrate

Airflow will orchestrate the existing FinFlow pipeline components rather than replacing them.

Planned Airflow responsibilities:

- Generate the synthetic transaction CSV
- Load transaction records into PostgreSQL
- Run dbt transformation models
- Run dbt data quality tests
- Optionally generate dbt documentation
- Later, coordinate cloud storage and warehouse steps
- Later, trigger reporting refreshes

Airflow will not contain business transformation logic directly. The transformation logic should remain in dbt models, and ingestion logic should remain in Python scripts.

## Planned DAG Structure

Planned DAG name:

```text
finflow_daily_transactions_pipeline
```

Planned DAG file:

```text
airflow/dags/finflow_daily_transactions_pipeline.py
```

Initial scheduling approach:

```text
Manual trigger only
```

The DAG will start as a manually triggered local workflow. A daily schedule will be added after the local Airflow setup is stable.

## Planned Task Order

```text
generate_synthetic_transactions
        ->
load_transactions_to_postgres
        ->
run_dbt_models
        ->
run_dbt_tests
        ->
generate_dbt_docs_optional
        ->
future_upload_raw_file_to_s3
        ->
future_load_to_snowflake
        ->
future_refresh_reporting_output
```

## Planned Tasks and Commands

The first Airflow version should use shell commands that call the same scripts already used locally.

| Task ID | Purpose | Planned command |
| --- | --- | --- |
| `generate_synthetic_transactions` | Generate the local raw transaction CSV | `python ingestion/generate_sample_transactions.py` |
| `load_transactions_to_postgres` | Create/load `public.raw_transactions` in PostgreSQL | `python ingestion/load_postgres.py` |
| `run_dbt_models` | Build staging, intermediate, and mart models | `dbt run --project-dir dbt/finflow_dbt` |
| `run_dbt_tests` | Run dbt data quality checks | `dbt test --project-dir dbt/finflow_dbt` |
| `generate_dbt_docs_optional` | Generate local dbt documentation artefacts | `dbt docs generate --project-dir dbt/finflow_dbt` |
| `future_upload_raw_file_to_s3` | Upload raw CSV to cloud-style object storage | Future Python or AWS CLI task |
| `future_load_to_snowflake` | Load transformed or raw data into Snowflake | Future dbt/Snowflake task |
| `future_refresh_reporting_output` | Refresh BI/reporting output | Future Power BI or export task |

For local Windows development outside Airflow, commands can continue to be run from the project root using the project virtual environment.

For Docker-based Airflow, the Airflow services should run the commands inside containers using paths mounted from the project repository.

## Retry and Logging Approach

The first DAG should use conservative retry behaviour:

- One retry for ingestion and loading tasks
- One retry for dbt run
- No automatic retry or one retry for dbt tests, depending on whether failures are caused by data quality or transient infrastructure issues
- Five-minute retry delay
- Task-level logs retained in the local Airflow logs volume

Data quality failures from `dbt test` should fail the DAG. This is intentional because failed tests indicate that the produced analytics tables should not be treated as trusted reporting outputs.

## Local Docker and Airflow Approach

The Airflow setup should remain minimal and local-first.

Planned local services:

- Existing `finflow-postgres` service for FinFlow transaction data
- Separate Airflow metadata database service
- Airflow webserver
- Airflow scheduler
- Airflow initialization service

The FinFlow PostgreSQL database and the Airflow metadata database should remain separate. This avoids mixing application data with Airflow operational metadata and reduces the risk of table or credential conflicts.

Credentials and local settings should be read from `.env` or local-only Airflow environment variables. Secrets must not be committed to Git.

The first implementation should avoid unnecessary extras such as Celery, distributed workers, Kubernetes, or cloud services. Those can be added later only if they improve the project story.

## Future Scheduling Plan

Initial schedule:

```text
Manual trigger
```

Future local schedule:

```text
Daily at 06:00 Europe/London
```

The planned daily schedule represents a typical overnight or early-morning financial reporting pipeline. It allows transaction data to be generated or received, loaded, transformed, tested, and made ready before business users review reporting outputs.

## Future Cloud Extension

After local Airflow is stable, the DAG can be extended to include:

- Uploading raw CSV files to AWS S3 or S3-compatible object storage
- Loading source data into Snowflake
- Running dbt models against Snowflake
- Publishing reporting extracts
- Adding alerting for task failures

These should be treated as later phases. The immediate goal is a reliable local orchestration layer around the existing MVP.

## Portfolio Value

Adding Airflow helps FinFlow move from a working data pipeline to an operated data platform.

It gives clear interview talking points:

- I designed an end-to-end data pipeline with orchestration.
- I separated ingestion, loading, transformation, and testing into clear tasks.
- I used dbt tests as a quality gate before reporting.
- I kept orchestration separate from business transformation logic.
- I planned the project so it can grow from local Docker to cloud storage and cloud warehousing.

The Airflow phase should be implemented carefully after this plan is committed, starting with a minimal Docker Compose setup and one working DAG.

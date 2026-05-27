# FinFlow Windows Setup Guide

This guide explains how to run FinFlow locally on Windows 11.

## Prerequisites

- Windows 11
- VS Code
- Git
- Docker Desktop
- PowerShell
- Python 3.11 or newer

## Project Location

Recommended local path:

```text
C:\Users\suraj\Documents\PortfolioProjects\finflow-data-platform
```

Clone the repository:

```powershell
git clone https://github.com/sjkali22/finflow-data-platform.git
cd finflow-data-platform
```

## Environment Variables

Create a local `.env` file from `.env.example`:

```powershell
Copy-Item .env.example .env
```

The `.env` file is ignored by Git and should not be committed.

## Python Environment

Create and activate a local virtual environment from the project root:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## Docker Services

The local PostgreSQL database and Airflow services run inside Docker using `docker-compose.yml`.

Database details for local development:

```text
Host: localhost
Port: 5432
Database: finflow
User: finflow_user
Password: stored locally in .env
Container name: finflow-postgres
```

Airflow local UI:

```text
http://localhost:8080
```

Local Airflow login:

```text
Username: admin
Password: admin
```

The Airflow username and password are local development credentials only.

## Start Local Docker Services

From the project root, run:

```powershell
docker compose up -d
```

## Check Running Containers

```powershell
docker ps
```

Expected containers:

```text
finflow-postgres
airflow-postgres
airflow-webserver
airflow-scheduler
```

The `airflow-init` container initializes the Airflow metadata database and may exit after completing successfully.

## Generate and Load Local Data

From the project root:

```powershell
python ingestion/generate_sample_transactions.py
python ingestion/load_postgres.py
```

Expected loader output includes:

```text
Created raw_transactions table
Loaded 1000 rows into raw_transactions
```

## Run dbt Models and Tests

From the project root:

```powershell
cd dbt\finflow_dbt
dbt run
dbt test
cd ..\..
```

Expected results:

```text
dbt run: PASS=8 WARN=0 ERROR=0
dbt test: PASS=68 WARN=0 ERROR=0
```

## Trigger the Local Airflow DAG

Open Airflow:

```text
http://localhost:8080
```

Log in with the local development credentials:

```text
Username: admin
Password: admin
```

Find the DAG:

```text
finflow_local_pipeline
```

Unpause the DAG if needed, then trigger it manually from the Airflow UI.

The DAG runs these tasks in order:

```text
generate_transactions
load_to_postgres
dbt_run
dbt_test
```

The run is successful when all four tasks are green and the `dbt_test` task log shows:

```text
PASS=68 WARN=0 ERROR=0
```

## Check Database Health

```powershell
docker inspect --format="{{.State.Health.Status}}" finflow-postgres
```

Expected output:

```text
healthy
```

## Connect to PostgreSQL

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

## Useful PostgreSQL Commands

Check PostgreSQL version:

```sql
SELECT version();
```

Check current database:

```sql
SELECT current_database();
```

Exit PostgreSQL:

```sql
\q
```

## Stop Local Docker Services

```powershell
docker compose down
```

This stops PostgreSQL and Airflow services.

## Stop Services and Delete Local Database Volumes

Only use this if you want to reset the local PostgreSQL and Airflow metadata databases completely:

```powershell
docker compose down -v
```

## Airflow Local Files

Airflow project files are stored under:

```text
orchestration/airflow/
```

Tracked folders:

```text
orchestration/airflow/dags/
orchestration/airflow/plugins/
```

Runtime logs are written to:

```text
orchestration/airflow/logs/
```

Airflow logs and runtime files are ignored by Git. DAG files should be committed.

## Troubleshooting

### Docker Compose cannot read `.env`

If Docker shows an error such as:

```text
failed to read .env
```

Check that `.env` does not contain markdown formatting such as:

````text
```env
````

The `.env` file should contain only environment variable lines, for example:

```env
POSTGRES_DB=finflow
POSTGRES_USER=finflow_user
POSTGRES_PASSWORD=finflow_password
```

### Accidentally created the wrong Docker Compose file

The correct file name is:

```text
docker-compose.yml
```

Not:

```text
docker-compose.ysl
```

"""
Local FinFlow orchestration DAG.

Runs the existing local transaction pipeline: generate source data, load it into
PostgreSQL, build dbt models, and run dbt data quality tests.
"""

from __future__ import annotations

from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator


PROJECT_DIR = "/opt/airflow/project"
FINFLOW_PYTHON = "/opt/airflow/finflow_venv/bin/python"
FINFLOW_DBT = "/opt/airflow/finflow_venv/bin/dbt"
DBT_PROJECT_DIR = f"{PROJECT_DIR}/dbt/finflow_dbt"


default_args = {
    "owner": "finflow",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


with DAG(
    dag_id="finflow_local_pipeline",
    description="Run the local FinFlow transaction pipeline.",
    default_args=default_args,
    start_date=datetime(2026, 5, 26),
    schedule=None,
    catchup=False,
    tags=["finflow", "local", "data-engineering"],
) as dag:
    generate_transactions = BashOperator(
        task_id="generate_transactions",
        bash_command=f"cd {PROJECT_DIR} && {FINFLOW_PYTHON} ingestion/generate_sample_transactions.py",
    )

    load_to_postgres = BashOperator(
        task_id="load_to_postgres",
        bash_command=f"cd {PROJECT_DIR} && {FINFLOW_PYTHON} ingestion/load_postgres.py",
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && {FINFLOW_DBT} run",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && {FINFLOW_DBT} test",
    )

    generate_transactions >> load_to_postgres >> dbt_run >> dbt_test

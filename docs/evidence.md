# FinFlow Evidence Log

This document tracks the evidence collected for the FinFlow data engineering portfolio project.

The evidence is intended to support the GitHub repository, CV project description, LinkedIn posts, and interview discussions.

## Evidence Storage Location

Screenshots should be stored in:

```text
dashboard/screenshots/
```

Recommended file naming format:

```text
01-docker-postgres-running.png
02-postgres-raw-table-count.png
03-postgres-suspicious-activity-count.png
04-dbt-run-success.png
05-dbt-test-success.png
06-dbt-docs-overview.png
07-dbt-lineage-graph.png
08-dbt-stg-transactions-model.png
09-dbt-mart-suspicious-activity-model.png
10-github-actions-success.png
11-github-repo-homepage.png
12-github-docs-folder.png
13-airflow-containers-running.png
14-airflow-dag-list.png
15-airflow-dag-success.png
16-airflow-task-graph.png
17-airflow-dbt-test-log-success.png
```

## Evidence Checklist

| No. | Evidence                                   | Status    | Screenshot                                                        |
| --- | ------------------------------------------ | --------- | ----------------------------------------------------------------- |
| 1   | Docker PostgreSQL container running        | Collected | `dashboard/screenshots/01-docker-postgres-running.png`            |
| 2   | PostgreSQL raw table populated             | Collected | `dashboard/screenshots/02-postgres-raw-table-count.png`           |
| 3   | Suspicious activity mart populated         | Collected | `dashboard/screenshots/03-postgres-suspicious-activity-count.png` |
| 4   | dbt run success                            | Collected | `dashboard/screenshots/04-dbt-run-success.png`                    |
| 5   | dbt test success                           | Collected | `dashboard/screenshots/05-dbt-test-success.png`                   |
| 6   | dbt docs overview page                     | Collected | `dashboard/screenshots/06-dbt-docs-overview.png`                  |
| 7   | dbt lineage graph                          | Collected | `dashboard/screenshots/07-dbt-lineage-graph.png`                  |
| 8   | dbt model page: `stg_transactions`         | Collected | `dashboard/screenshots/08-dbt-stg-transactions-model.png`         |
| 9   | dbt model page: `mart_suspicious_activity` | Collected | `dashboard/screenshots/09-dbt-mart-suspicious-activity-model.png` |
| 10  | GitHub Actions passing                     | Collected | `dashboard/screenshots/10-github-actions-success.png`             |
| 11  | GitHub repository structure                | Collected | `dashboard/screenshots/11-github-repo-homepage.png`               |
| 12  | Documentation folder                       | Collected | `dashboard/screenshots/12-github-docs-folder.png`                 |
| 13  | Airflow and PostgreSQL containers running  | Collected | `dashboard/screenshots/13-airflow-containers-running.png`         |
| 14  | Airflow DAG visible in UI                  | Collected | `dashboard/screenshots/14-airflow-dag-list.png`                   |
| 15  | Airflow DAG successful run                 | Collected | `dashboard/screenshots/15-airflow-dag-success.png`                |
| 16  | Airflow task graph                         | Collected | `dashboard/screenshots/16-airflow-task-graph.png`                 |
| 17  | Airflow `dbt_test` task log success        | Collected | `dashboard/screenshots/17-airflow-dbt-test-log-success.png`       |
| 18  | Future Power BI dashboard                  | Planned   | Add after dashboard build phase                                   |
| 19  | Future Snowflake tables                    | Planned   | Add after cloud warehouse phase                                   |
| 20  | Future S3 raw storage                      | Planned   | Add after cloud storage phase                                     |

## Current Technical Evidence

### PostgreSQL Container

Command:

```powershell
docker ps
```

Expected result:

```text
finflow-postgres
```

Health check:

```powershell
docker inspect --format="{{.State.Health.Status}}" finflow-postgres
```

Expected result:

```text
healthy
```

### Raw Table Row Count

Command:

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

SQL:

```sql
SELECT COUNT(*) FROM public.raw_transactions;
```

Expected result:

```text
1000
```

### Suspicious Activity Mart Count

Command:

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

SQL:

```sql
SELECT COUNT(*) FROM analytics.mart_suspicious_activity;
```

Expected result:

```text
227
```

Risk band breakdown:

```sql
SELECT
    suspicious_risk_band,
    COUNT(*) AS transaction_count
FROM analytics.mart_suspicious_activity
GROUP BY suspicious_risk_band
ORDER BY transaction_count DESC;
```

Expected result:

```text
medium      88
low         64
high        60
critical    15
```

### dbt Run

Command:

```powershell
cd dbt\finflow_dbt
dbt run
```

Expected result:

```text
PASS=8 WARN=0 ERROR=0
```

### dbt Test

Command:

```powershell
cd dbt\finflow_dbt
dbt test
```

Expected result:

```text
PASS=68 WARN=0 ERROR=0
```

### dbt Docs

Command:

```powershell
cd dbt\finflow_dbt
dbt docs generate
dbt docs serve
```

Expected local URL:

```text
http://localhost:8080
```

### GitHub Actions

GitHub Actions workflow:

```text
FinFlow CI
```

Expected result:

```text
Success
```

## Airflow Evidence

The Airflow evidence shows that the local FinFlow pipeline can be orchestrated end-to-end through Apache Airflow.

Collected screenshots include:

- Airflow and PostgreSQL containers running locally
- The `finflow_local_pipeline` DAG listed in the Airflow UI
- A successful manual DAG run
- The task graph showing the pipeline order
- The `dbt_test` task log showing all 68 dbt tests passed

This proves that the pipeline can be run through an orchestrator rather than only through manual terminal commands.

### Airflow Containers

Command:

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

### Airflow DAG

Airflow UI:

```text
http://localhost:8080
```

Expected DAG:

```text
finflow_local_pipeline
```

Expected task order:

```text
generate_transactions
        ↓
load_to_postgres
        ↓
dbt_run
        ↓
dbt_test
```

### Airflow dbt Test Task

Expected `dbt_test` task log result:

```text
PASS=68 WARN=0 ERROR=0 SKIP=0 NO-OP=0 TOTAL=68
```

## Collected Screenshots

### 1. Docker Container Running

Screenshot:

```text
dashboard/screenshots/01-docker-postgres-running.png
```

Shows:

```text
finflow-postgres
healthy
```

### 2. PostgreSQL Raw Count

Screenshot:

```text
dashboard/screenshots/02-postgres-raw-table-count.png
```

Shows:

```text
1000
```

### 3. Suspicious Activity Mart Count

Screenshot:

```text
dashboard/screenshots/03-postgres-suspicious-activity-count.png
```

Shows:

```text
227 suspicious activity records
risk band breakdown
```

### 4. dbt Run Success

Screenshot:

```text
dashboard/screenshots/04-dbt-run-success.png
```

Shows:

```text
Done. PASS=8 WARN=0 ERROR=0
```

### 5. dbt Test Success

Screenshot:

```text
dashboard/screenshots/05-dbt-test-success.png
```

Shows:

```text
Done. PASS=68 WARN=0 ERROR=0
```

### 6. dbt Docs Overview

Screenshot:

```text
dashboard/screenshots/06-dbt-docs-overview.png
```

Shows the generated dbt documentation site.

### 7. dbt Lineage Graph

Screenshot:

```text
dashboard/screenshots/07-dbt-lineage-graph.png
```

Shows dbt model lineage.

### 8. dbt Staging Model

Screenshot:

```text
dashboard/screenshots/08-dbt-stg-transactions-model.png
```

Shows the `stg_transactions` model documentation.

### 9. dbt Suspicious Activity Mart Model

Screenshot:

```text
dashboard/screenshots/09-dbt-mart-suspicious-activity-model.png
```

Shows the `mart_suspicious_activity` model documentation.

### 10. GitHub Actions Success

Screenshot:

```text
dashboard/screenshots/10-github-actions-success.png
```

Shows the successful GitHub Actions workflow.

### 11. GitHub Repository Homepage

Screenshot:

```text
dashboard/screenshots/11-github-repo-homepage.png
```

Shows the project repository structure.

### 12. GitHub Docs Folder

Screenshot:

```text
dashboard/screenshots/12-github-docs-folder.png
```

Shows the documentation folder in GitHub.

### 13. Airflow Containers Running

Screenshot:

```text
dashboard/screenshots/13-airflow-containers-running.png
```

Shows the local PostgreSQL and Airflow containers running.

### 14. Airflow DAG List

Screenshot:

```text
dashboard/screenshots/14-airflow-dag-list.png
```

Shows the `finflow_local_pipeline` DAG in the Airflow UI.

### 15. Airflow DAG Success

Screenshot:

```text
dashboard/screenshots/15-airflow-dag-success.png
```

Shows a successful manual DAG run.

### 16. Airflow Task Graph

Screenshot:

```text
dashboard/screenshots/16-airflow-task-graph.png
```

Shows the Airflow task graph:

```text
generate_transactions → load_to_postgres → dbt_run → dbt_test
```

### 17. Airflow dbt Test Log Success

Screenshot:

```text
dashboard/screenshots/17-airflow-dbt-test-log-success.png
```

Shows the `dbt_test` task log with all 68 dbt tests passing.

## Evidence Notes

The evidence should show that FinFlow is not just a code-only project. It should prove that:

- The local database runs successfully
- Data is loaded into PostgreSQL
- dbt transformations run successfully
- dbt tests validate the data
- dbt documentation is generated
- GitHub Actions CI passes
- Airflow can orchestrate the full local pipeline
- Reporting-ready SQL queries exist for future Power BI dashboard work
- The project is reproducible and professionally documented

## Interview Talking Points

This evidence supports the following interview points:

- I built a local-first data engineering pipeline using Python, PostgreSQL, Docker, dbt, and Apache Airflow.
- I generated realistic synthetic financial transaction data for a fictional financial services use case.
- I loaded raw CSV transaction data into PostgreSQL using a Python ingestion script.
- I modelled the data using raw, staging, intermediate, and mart layers.
- I added dbt tests for data quality checks such as uniqueness, not-null values, and accepted values.
- I generated dbt documentation and lineage to make the data models easier to understand.
- I added Apache Airflow to orchestrate the end-to-end pipeline from data generation through dbt testing.
- I added GitHub Actions CI to automatically check Python syntax and dbt project parsing.
- I created reporting-ready SQL queries to connect the engineered data models to future dashboard work.
- I documented the architecture, data sources, data dictionary, orchestration approach, governance considerations, and project readiness.

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
03-dbt-run-success.png
04-dbt-test-success.png
05-dbt-docs-overview.png
06-dbt-lineage-graph.png
07-github-actions-success.png
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
| 13  | Future Power BI dashboard                  | Planned   | Add after reporting phase                                         |
| 14  | Future Airflow DAG success                 | Planned   | Add after orchestration phase                                     |
| 15  | Future Snowflake tables                    | Planned   | Add after cloud warehouse phase                                   |
| 16  | Future S3 raw storage                      | Planned   | Add after cloud storage phase                                     |

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

## Suggested Screenshots To Capture Now

### 1. Docker Container Running

Run:

```powershell
docker ps
```

Screenshot should show:

```text
finflow-postgres
healthy
```

### 2. PostgreSQL Raw Count

Run:

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

Then:

```sql
SELECT COUNT(*) FROM public.raw_transactions;
```

Screenshot should show:

```text
1000
```

Exit PostgreSQL:

```sql
\q
```

### 3. dbt Run Success

Run:

```powershell
cd dbt\finflow_dbt
dbt run
```

Screenshot should show:

```text
Done. PASS=8 WARN=0 ERROR=0
```

### 4. dbt Test Success

Run:

```powershell
dbt test
```

Screenshot should show:

```text
Done. PASS=68 WARN=0 ERROR=0
```

### 5. dbt Docs Overview

Run:

```powershell
dbt docs generate
dbt docs serve
```

Screenshot the docs overview page.

### 6. dbt Lineage Graph

In the dbt docs site, open the lineage graph and screenshot the model flow.

### 7. GitHub Actions Success

Open GitHub Actions and screenshot the successful `FinFlow CI` run.

## Evidence Notes

The evidence should show that FinFlow is not just a code-only project. It should prove that:

- The local database runs successfully
- Data is loaded into PostgreSQL
- dbt transformations run successfully
- dbt tests validate the data
- dbt documentation is generated
- GitHub Actions CI passes
- The project is reproducible and professionally documented

## Interview Talking Points

This evidence supports the following interview points:

- I built a local-first data engineering pipeline using Python, PostgreSQL, Docker, and dbt.
- I modelled the data using raw, staging, intermediate, and mart layers.
- I added dbt tests for data quality checks such as uniqueness, not-null values, and accepted values.
- I generated dbt documentation and lineage to make the data models easier to understand.
- I added GitHub Actions CI to automatically check Python syntax and dbt project parsing.
- I documented the architecture, data sources, data dictionary, and governance considerations.

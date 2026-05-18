# FinFlow Governance Notes

## Overview

FinFlow is a portfolio data engineering project built around synthetic financial transaction data.

The project is designed to demonstrate data engineering practices without using real customer, banking, or payment data.

## Data Privacy

The current dataset is synthetic.

It does not contain:

- Real customer names
- Real account numbers
- Real bank details
- Real addresses
- Real transaction histories
- Real merchant identifiers
- Real personally identifiable information

Synthetic account IDs are generated only for pipeline demonstration.

## Data Sensitivity

Although the dataset is synthetic, the project is framed as a financial services data platform.

In a real financial services environment, similar transaction data would be treated as sensitive and would require strict access controls, monitoring, and governance.

## Secrets Management

Local secrets are stored in:

```text
.env
```

The `.env` file is ignored by Git and must not be committed.

Safe example variables are stored in:

```text
.env.example
```

## Current Secret Handling

The project currently uses `.env` for:

- PostgreSQL host
- PostgreSQL port
- PostgreSQL database name
- PostgreSQL user
- PostgreSQL password
- Future AWS/S3 variables
- Future Snowflake variables

## Git Ignore Rules

The repository is configured to ignore:

- `.env`
- `.venv/`
- dbt logs
- dbt target files
- large/generated data files
- local runtime artefacts

The small reproducible sample CSV is intentionally allowed so the project can be run easily after cloning.

## Data Quality Controls

Current data quality controls are implemented using dbt tests.

The tests check:

- Not-null transaction IDs
- Unique transaction IDs
- Valid transaction types
- Valid transaction channels
- Valid fraud flags
- Unique reporting dates where expected
- Not-null reporting metrics

## Auditability

The project supports auditability through:

- Version-controlled SQL models
- Version-controlled Python ingestion scripts
- dbt model lineage
- dbt documentation
- Repeatable Docker-based PostgreSQL setup
- Reproducible synthetic dataset generation

## Reproducibility

The project can be rebuilt from the repository using:

```text
docker-compose.yml
requirements.txt
.env.example
ingestion scripts
dbt project files
SQL DDL scripts
```

No hidden local files should be required, except for a local `.env` file created from `.env.example`.

## Future Governance Improvements

Future improvements could include:

- GitHub Actions checks for dbt build validation
- More granular data quality tests
- Data freshness checks
- Source freshness checks
- Airflow logs for scheduled runs
- S3 bucket access policy documentation
- Snowflake role and warehouse documentation
- Data retention notes
- Data classification notes
- Great Expectations validation suite

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine


PROJECT_ROOT = Path(__file__).resolve().parents[1]
ENV_FILE = PROJECT_ROOT / ".env"
RAW_DATA_FILE = PROJECT_ROOT / "data" / "raw" / "transactions_sample.csv"
DDL_FILE = PROJECT_ROOT / "sql" / "ddl" / "create_raw_transactions.sql"


def get_database_url() -> str:
    load_dotenv(ENV_FILE)

    host = os.getenv("POSTGRES_HOST", "localhost")
    port = os.getenv("POSTGRES_PORT", "5432")
    database = os.getenv("POSTGRES_DB", "finflow")
    user = os.getenv("POSTGRES_USER", "finflow_user")
    password = os.getenv("POSTGRES_PASSWORD")

    if not password:
        raise ValueError("POSTGRES_PASSWORD is missing. Check your .env file.")

    return f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"


def create_database_engine() -> Engine:
    database_url = get_database_url()
    return create_engine(database_url)


def run_ddl(engine: Engine) -> None:
    ddl_sql = DDL_FILE.read_text(encoding="utf-8")

    with engine.begin() as connection:
        connection.execute(text(ddl_sql))

    print("Created raw_transactions table")


def load_transactions(engine: Engine) -> None:
    if not RAW_DATA_FILE.exists():
        raise FileNotFoundError(f"CSV file not found: {RAW_DATA_FILE}")

    df = pd.read_csv(RAW_DATA_FILE)
    df["transaction_datetime"] = pd.to_datetime(df["transaction_datetime"])

    df.to_sql(
        name="raw_transactions",
        con=engine,
        if_exists="append",
        index=False,
        method="multi",
        chunksize=500,
    )

    print(f"Loaded {len(df)} rows into raw_transactions")


def print_basic_checks(engine: Engine) -> None:
    checks = {
        "Total rows": "SELECT COUNT(*) FROM raw_transactions;",
        "Earliest transaction": "SELECT MIN(transaction_datetime) FROM raw_transactions;",
        "Latest transaction": "SELECT MAX(transaction_datetime) FROM raw_transactions;",
        "Fraud rows": "SELECT COUNT(*) FROM raw_transactions WHERE is_fraud = 1;",
        "Flagged fraud rows": "SELECT COUNT(*) FROM raw_transactions WHERE is_flagged_fraud = 1;",
    }

    with engine.connect() as connection:
        print()
        print("Database checks:")

        for label, sql in checks.items():
            result = connection.execute(text(sql)).scalar()
            print(f"- {label}: {result}")


def main() -> None:
    engine = create_database_engine()

    run_ddl(engine)
    load_transactions(engine)
    print_basic_checks(engine)


if __name__ == "__main__":
    main()
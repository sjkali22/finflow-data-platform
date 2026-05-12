from __future__ import annotations

import random
import uuid
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd


PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
OUTPUT_FILE = RAW_DATA_DIR / "transactions_sample.csv"

TRANSACTION_TYPES = ["PAYMENT", "TRANSFER", "CASH_OUT", "CASH_IN", "DEBIT"]

CHANNELS = [
    "mobile_app",
    "online_banking",
    "atm",
    "branch",
    "card_terminal",
]

MERCHANT_CATEGORIES = [
    "groceries",
    "transport",
    "entertainment",
    "utilities",
    "restaurants",
    "retail",
    "financial_services",
    "travel",
    "healthcare",
]

LOCATIONS = [
    "London",
    "Manchester",
    "Birmingham",
    "Leeds",
    "Liverpool",
    "Bristol",
    "Sheffield",
    "Nottingham",
    "Newcastle",
    "Cardiff",
    "Glasgow",
    "Edinburgh",
]


def generate_account_id() -> str:
    return f"ACC{random.randint(10000000, 99999999)}"


def generate_transaction_datetime(start_date: datetime, days: int) -> datetime:
    random_days = random.randint(0, days)
    random_seconds = random.randint(0, 86_399)
    return start_date + timedelta(days=random_days, seconds=random_seconds)


def calculate_new_balance(
    transaction_type: str,
    old_balance_origin: float,
    old_balance_destination: float,
    amount: float,
) -> tuple[float, float]:
    if transaction_type in {"PAYMENT", "TRANSFER", "CASH_OUT", "DEBIT"}:
        new_balance_origin = max(old_balance_origin - amount, 0)
        new_balance_destination = old_balance_destination + amount
    elif transaction_type == "CASH_IN":
        new_balance_origin = old_balance_origin + amount
        new_balance_destination = old_balance_destination
    else:
        new_balance_origin = old_balance_origin
        new_balance_destination = old_balance_destination

    return round(new_balance_origin, 2), round(new_balance_destination, 2)


def assign_fraud_flags(transaction_type: str, amount: float, channel: str) -> tuple[int, int]:
    high_risk_type = transaction_type in {"TRANSFER", "CASH_OUT"}
    high_risk_channel = channel in {"online_banking", "mobile_app"}
    high_value = amount >= 5_000

    fraud_probability = 0.01

    if high_value:
        fraud_probability += 0.03

    if high_risk_type:
        fraud_probability += 0.02

    if high_risk_channel:
        fraud_probability += 0.01

    is_fraud = 1 if random.random() < fraud_probability else 0
    is_flagged_fraud = 1 if is_fraud and amount >= 7_500 else 0

    return is_fraud, is_flagged_fraud


def generate_transactions(row_count: int = 1_000) -> pd.DataFrame:
    random.seed(42)

    start_date = datetime(2025, 1, 1)
    rows = []

    for _ in range(row_count):
        transaction_type = random.choice(TRANSACTION_TYPES)
        channel = random.choice(CHANNELS)

        if transaction_type in {"TRANSFER", "CASH_OUT"}:
            amount = round(random.uniform(50, 10_000), 2)
        elif transaction_type == "CASH_IN":
            amount = round(random.uniform(20, 5_000), 2)
        else:
            amount = round(random.uniform(5, 2_500), 2)

        old_balance_origin = round(random.uniform(100, 20_000), 2)
        old_balance_destination = round(random.uniform(0, 30_000), 2)

        new_balance_origin, new_balance_destination = calculate_new_balance(
            transaction_type=transaction_type,
            old_balance_origin=old_balance_origin,
            old_balance_destination=old_balance_destination,
            amount=amount,
        )

        is_fraud, is_flagged_fraud = assign_fraud_flags(
            transaction_type=transaction_type,
            amount=amount,
            channel=channel,
        )

        rows.append(
            {
                "transaction_id": f"TXN-{uuid.uuid4()}",
                "transaction_datetime": generate_transaction_datetime(start_date, 120),
                "transaction_type": transaction_type,
                "amount": amount,
                "origin_account": generate_account_id(),
                "destination_account": generate_account_id(),
                "old_balance_origin": old_balance_origin,
                "new_balance_origin": new_balance_origin,
                "old_balance_destination": old_balance_destination,
                "new_balance_destination": new_balance_destination,
                "is_fraud": is_fraud,
                "is_flagged_fraud": is_flagged_fraud,
                "merchant_category": random.choice(MERCHANT_CATEGORIES),
                "location": random.choice(LOCATIONS),
                "channel": channel,
            }
        )

    df = pd.DataFrame(rows)
    df = df.sort_values("transaction_datetime").reset_index(drop=True)
    return df


def main() -> None:
    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    df = generate_transactions(row_count=1_000)
    df.to_csv(OUTPUT_FILE, index=False)

    print(f"Generated {len(df)} transactions")
    print(f"Output file: {OUTPUT_FILE}")
    print()
    print("Preview:")
    print(df.head(10).to_string(index=False))


if __name__ == "__main__":
    main()
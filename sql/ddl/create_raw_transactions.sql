DROP TABLE IF EXISTS raw_transactions CASCADE;

CREATE TABLE raw_transactions (
    transaction_id VARCHAR(100) PRIMARY KEY,
    transaction_datetime TIMESTAMP NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    amount NUMERIC(14, 2) NOT NULL,
    origin_account VARCHAR(50) NOT NULL,
    destination_account VARCHAR(50) NOT NULL,
    old_balance_origin NUMERIC(14, 2) NOT NULL,
    new_balance_origin NUMERIC(14, 2) NOT NULL,
    old_balance_destination NUMERIC(14, 2) NOT NULL,
    new_balance_destination NUMERIC(14, 2) NOT NULL,
    is_fraud INTEGER NOT NULL,
    is_flagged_fraud INTEGER NOT NULL,
    merchant_category VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

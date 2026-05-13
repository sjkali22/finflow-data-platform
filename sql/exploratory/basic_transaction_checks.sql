-- Basic row count
SELECT COUNT(*) AS total_transactions
FROM raw_transactions;

-- Transaction date range
SELECT
    MIN(transaction_datetime) AS earliest_transaction,
    MAX(transaction_datetime) AS latest_transaction
FROM raw_transactions;

-- Transaction count by type
SELECT
    transaction_type,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value
FROM raw_transactions
GROUP BY transaction_type
ORDER BY total_transaction_value DESC;

-- Transaction count by channel
SELECT
    channel,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_transaction_value
FROM raw_transactions
GROUP BY channel
ORDER BY transaction_count DESC;

-- Fraud summary
SELECT
    is_fraud,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_transaction_value
FROM raw_transactions
GROUP BY is_fraud
ORDER BY is_fraud DESC;

-- High-value transactions
SELECT
    transaction_id,
    transaction_datetime,
    transaction_type,
    amount,
    origin_account,
    destination_account,
    channel,
    location,
    is_fraud,
    is_flagged_fraud
FROM raw_transactions
WHERE amount >= 7500
ORDER BY amount DESC
LIMIT 20;
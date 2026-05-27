-- Daily transaction volume and fraud monitoring output.
-- Intended for dashboard trend charts and headline daily reporting metrics.

SELECT
    transaction_date,
    total_transactions,
    total_transaction_value,
    average_transaction_value,
    fraud_transaction_count,
    flagged_fraud_transaction_count,
    fraud_rate_percentage,
    flagged_fraud_rate_percentage
FROM analytics.mart_daily_transaction_volume
ORDER BY transaction_date;

-- Transaction type summary output.
-- Intended for dashboard visuals comparing volume, value, and fraud by transaction type.

SELECT
    transaction_type,
    total_transactions,
    total_transaction_value,
    average_transaction_value,
    fraud_transaction_count,
    flagged_fraud_transaction_count,
    fraud_rate_percentage,
    flagged_fraud_rate_percentage
FROM analytics.mart_transaction_type_summary
ORDER BY total_transaction_value DESC;

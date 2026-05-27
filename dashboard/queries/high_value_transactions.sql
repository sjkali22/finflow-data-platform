-- High-value transaction detail output.
-- Intended for dashboard detail tables and transaction investigation views.

SELECT
    transaction_id,
    transaction_datetime,
    transaction_date,
    transaction_type,
    amount,
    origin_account,
    destination_account,
    merchant_category,
    location,
    channel,
    is_fraud,
    is_flagged_fraud,
    suspicious_score
FROM analytics.mart_high_value_transactions
ORDER BY amount DESC, transaction_datetime DESC;

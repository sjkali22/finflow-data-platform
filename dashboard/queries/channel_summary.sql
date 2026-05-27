-- Channel summary output.
-- Intended for dashboard visuals comparing transaction activity by customer channel.

SELECT
    channel,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value,
    SUM(is_fraud) AS fraud_transaction_count,
    CASE
        WHEN COUNT(*) > 0
            THEN ROUND((SUM(is_fraud)::numeric / COUNT(*)::numeric) * 100, 2)
        ELSE 0
    END AS fraud_rate_percentage
FROM analytics.stg_transactions
GROUP BY channel
ORDER BY total_transactions DESC;

-- Suspicious activity summary by risk band.
-- Intended for risk band cards, bar charts, and suspicious activity monitoring views.

SELECT
    suspicious_risk_band,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value,
    SUM(is_fraud) AS fraud_transaction_count,
    SUM(is_flagged_fraud) AS flagged_fraud_transaction_count
FROM analytics.mart_suspicious_activity
GROUP BY suspicious_risk_band
ORDER BY
    CASE suspicious_risk_band
        WHEN 'critical' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
        ELSE 5
    END;

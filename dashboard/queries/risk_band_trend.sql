-- Suspicious risk band trend output.
-- Intended for dashboard trend charts showing suspicious activity over time by risk band.

SELECT
    transaction_date,
    suspicious_risk_band,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_transaction_value
FROM analytics.mart_suspicious_activity
GROUP BY
    transaction_date,
    suspicious_risk_band
ORDER BY
    transaction_date,
    CASE suspicious_risk_band
        WHEN 'critical' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
        ELSE 5
    END;

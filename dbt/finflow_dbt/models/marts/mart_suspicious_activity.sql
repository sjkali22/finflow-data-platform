WITH suspicious_transactions AS (
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
        is_high_value_transaction,
        is_high_risk_transaction_type,
        is_high_risk_channel_transaction,
        is_account_draining_transaction,
        suspicious_score
    FROM {{ ref('int_suspicious_transaction_flags') }}
),

final AS (
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
        is_high_value_transaction,
        is_high_risk_transaction_type,
        is_high_risk_channel_transaction,
        is_account_draining_transaction,
        suspicious_score,

        CASE
            WHEN suspicious_score >= 4 THEN 'critical'
            WHEN suspicious_score = 3 THEN 'high'
            WHEN suspicious_score = 2 THEN 'medium'
            WHEN suspicious_score = 1 THEN 'low'
            ELSE 'normal'
        END AS suspicious_risk_band
    FROM suspicious_transactions
)

SELECT *
FROM final
WHERE suspicious_score >= 1
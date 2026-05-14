WITH transactions AS (
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
        suspicious_score
    FROM transactions
    WHERE amount >= 7500
)

SELECT *
FROM final
WITH daily_summary AS (
    SELECT
        transaction_date,
        total_transactions,
        total_transaction_value,
        average_transaction_value,
        minimum_transaction_value,
        maximum_transaction_value,
        fraud_transaction_count,
        flagged_fraud_transaction_count
    FROM {{ ref('int_daily_transaction_summary') }}
),

final AS (
    SELECT
        transaction_date,
        total_transactions,
        total_transaction_value,
        average_transaction_value,
        minimum_transaction_value,
        maximum_transaction_value,
        fraud_transaction_count,
        flagged_fraud_transaction_count,

        CASE
            WHEN total_transactions > 0
                THEN ROUND((fraud_transaction_count::numeric / total_transactions::numeric) * 100, 2)
            ELSE 0
        END AS fraud_rate_percentage,

        CASE
            WHEN total_transactions > 0
                THEN ROUND((flagged_fraud_transaction_count::numeric / total_transactions::numeric) * 100, 2)
            ELSE 0
        END AS flagged_fraud_rate_percentage
    FROM daily_summary
)

SELECT *
FROM final
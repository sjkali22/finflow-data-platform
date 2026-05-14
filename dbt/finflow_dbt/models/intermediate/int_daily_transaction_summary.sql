WITH transactions AS (
    SELECT
        transaction_date,
        transaction_type,
        channel,
        amount,
        is_fraud,
        is_flagged_fraud
    FROM {{ ref('stg_transactions') }}
),

daily_summary AS (
    SELECT
        transaction_date,
        COUNT(*) AS total_transactions,
        ROUND(SUM(amount), 2) AS total_transaction_value,
        ROUND(AVG(amount), 2) AS average_transaction_value,
        MIN(amount) AS minimum_transaction_value,
        MAX(amount) AS maximum_transaction_value,
        SUM(is_fraud) AS fraud_transaction_count,
        SUM(is_flagged_fraud) AS flagged_fraud_transaction_count
    FROM transactions
    GROUP BY transaction_date
)

SELECT *
FROM daily_summary
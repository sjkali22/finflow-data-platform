WITH transactions AS (
    SELECT
        transaction_type,
        amount,
        is_fraud,
        is_flagged_fraud
    FROM {{ ref('stg_transactions') }}
),

transaction_type_summary AS (
    SELECT
        transaction_type,
        COUNT(*) AS total_transactions,
        ROUND(SUM(amount), 2) AS total_transaction_value,
        ROUND(AVG(amount), 2) AS average_transaction_value,
        MIN(amount) AS minimum_transaction_value,
        MAX(amount) AS maximum_transaction_value,
        SUM(is_fraud) AS fraud_transaction_count,
        SUM(is_flagged_fraud) AS flagged_fraud_transaction_count
    FROM transactions
    GROUP BY transaction_type
)

SELECT *
FROM transaction_type_summary
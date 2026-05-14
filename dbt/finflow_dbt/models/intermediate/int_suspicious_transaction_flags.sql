WITH transactions AS (
    SELECT
        transaction_id,
        transaction_datetime,
        transaction_date,
        transaction_type,
        amount,
        origin_account,
        destination_account,
        old_balance_origin,
        new_balance_origin,
        old_balance_destination,
        new_balance_destination,
        merchant_category,
        location,
        channel,
        is_fraud,
        is_flagged_fraud
    FROM {{ ref('stg_transactions') }}
),

flagged_transactions AS (
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

        CASE
            WHEN amount >= 7500 THEN 1
            ELSE 0
        END AS is_high_value_transaction,

        CASE
            WHEN transaction_type IN ('TRANSFER', 'CASH_OUT')
                 AND amount >= 5000 THEN 1
            ELSE 0
        END AS is_high_risk_transaction_type,

        CASE
            WHEN channel IN ('mobile_app', 'online_banking')
                 AND amount >= 5000 THEN 1
            ELSE 0
        END AS is_high_risk_channel_transaction,

        CASE
            WHEN new_balance_origin = 0
                 AND old_balance_origin > 0
                 AND amount >= 1000 THEN 1
            ELSE 0
        END AS is_account_draining_transaction
    FROM transactions
),

scored_transactions AS (
    SELECT
        *,
        (
            is_high_value_transaction
            + is_high_risk_transaction_type
            + is_high_risk_channel_transaction
            + is_account_draining_transaction
            + is_flagged_fraud
        ) AS suspicious_score
    FROM flagged_transactions
)

SELECT *
FROM scored_transactions

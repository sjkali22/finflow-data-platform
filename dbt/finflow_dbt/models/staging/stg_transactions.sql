WITH source_transactions AS (
    SELECT
        transaction_id,
        transaction_datetime,
        transaction_type,
        amount,
        origin_account,
        destination_account,
        old_balance_origin,
        new_balance_origin,
        old_balance_destination,
        new_balance_destination,
        is_fraud,
        is_flagged_fraud,
        merchant_category,
        location,
        channel,
        loaded_at
    FROM {{ source('raw', 'raw_transactions') }}
),

cleaned_transactions AS (
    SELECT
        transaction_id,
        transaction_datetime,
        CAST(transaction_datetime AS DATE) AS transaction_date,
        UPPER(TRIM(transaction_type)) AS transaction_type,
        CAST(amount AS NUMERIC(14, 2)) AS amount,
        TRIM(origin_account) AS origin_account,
        TRIM(destination_account) AS destination_account,
        CAST(old_balance_origin AS NUMERIC(14, 2)) AS old_balance_origin,
        CAST(new_balance_origin AS NUMERIC(14, 2)) AS new_balance_origin,
        CAST(old_balance_destination AS NUMERIC(14, 2)) AS old_balance_destination,
        CAST(new_balance_destination AS NUMERIC(14, 2)) AS new_balance_destination,
        CAST(is_fraud AS INTEGER) AS is_fraud,
        CAST(is_flagged_fraud AS INTEGER) AS is_flagged_fraud,
        LOWER(TRIM(merchant_category)) AS merchant_category,
        TRIM(location) AS location,
        LOWER(TRIM(channel)) AS channel,
        loaded_at
    FROM source_transactions
)

SELECT *
FROM cleaned_transactions
# FinFlow Data Dictionary

## Overview

This data dictionary documents the current FinFlow transaction dataset and dbt models.

The current project uses synthetic financial transaction data loaded into PostgreSQL and transformed with dbt.

## Raw Table: `public.raw_transactions`

| Column                  | Type      | Description                                                           |
| ----------------------- | --------- | --------------------------------------------------------------------- |
| transaction_id          | VARCHAR   | Unique transaction identifier                                         |
| transaction_datetime    | TIMESTAMP | Date and time when the transaction occurred                           |
| transaction_type        | VARCHAR   | Type of financial transaction                                         |
| amount                  | NUMERIC   | Transaction amount                                                    |
| origin_account          | VARCHAR   | Account where the transaction originated                              |
| destination_account     | VARCHAR   | Account where the transaction was sent or recorded                    |
| old_balance_origin      | NUMERIC   | Origin account balance before the transaction                         |
| new_balance_origin      | NUMERIC   | Origin account balance after the transaction                          |
| old_balance_destination | NUMERIC   | Destination account balance before the transaction                    |
| new_balance_destination | NUMERIC   | Destination account balance after the transaction                     |
| is_fraud                | INTEGER   | Synthetic fraud label. 1 means fraud, 0 means not fraud               |
| is_flagged_fraud        | INTEGER   | Synthetic rule-based fraud flag. 1 means flagged, 0 means not flagged |
| merchant_category       | VARCHAR   | Merchant or transaction category                                      |
| location                | VARCHAR   | Transaction location                                                  |
| channel                 | VARCHAR   | Channel used to perform the transaction                               |
| loaded_at               | TIMESTAMP | Timestamp when the record was loaded into PostgreSQL                  |

## Staging Model: `analytics.stg_transactions`

The staging model cleans and standardises the raw transaction table.

| Column                  | Description                                    |
| ----------------------- | ---------------------------------------------- |
| transaction_id          | Unique transaction identifier                  |
| transaction_datetime    | Transaction timestamp                          |
| transaction_date        | Date derived from transaction timestamp        |
| transaction_type        | Standardised transaction type                  |
| amount                  | Transaction amount                             |
| origin_account          | Origin account identifier                      |
| destination_account     | Destination account identifier                 |
| old_balance_origin      | Origin account balance before transaction      |
| new_balance_origin      | Origin account balance after transaction       |
| old_balance_destination | Destination account balance before transaction |
| new_balance_destination | Destination account balance after transaction  |
| is_fraud                | Synthetic fraud label                          |
| is_flagged_fraud        | Synthetic fraud flag                           |
| merchant_category       | Standardised merchant category                 |
| location                | Transaction location                           |
| channel                 | Standardised transaction channel               |
| loaded_at               | Load timestamp                                 |

## Intermediate Model: `analytics.int_daily_transaction_summary`

Daily transaction summary used for reporting and monitoring.

| Column                          | Description                              |
| ------------------------------- | ---------------------------------------- |
| transaction_date                | Reporting date                           |
| total_transactions              | Number of transactions on the date       |
| total_transaction_value         | Total value of transactions on the date  |
| average_transaction_value       | Average transaction value on the date    |
| minimum_transaction_value       | Minimum transaction value on the date    |
| maximum_transaction_value       | Maximum transaction value on the date    |
| fraud_transaction_count         | Number of transactions labelled as fraud |
| flagged_fraud_transaction_count | Number of transactions flagged as fraud  |

## Intermediate Model: `analytics.int_transaction_type_summary`

Transaction summary by transaction type.

| Column                          | Description                                                   |
| ------------------------------- | ------------------------------------------------------------- |
| transaction_type                | Type of transaction                                           |
| total_transactions              | Number of transactions for the transaction type               |
| total_transaction_value         | Total value for the transaction type                          |
| average_transaction_value       | Average value for the transaction type                        |
| minimum_transaction_value       | Minimum value for the transaction type                        |
| maximum_transaction_value       | Maximum value for the transaction type                        |
| fraud_transaction_count         | Number of fraud transactions for the transaction type         |
| flagged_fraud_transaction_count | Number of flagged fraud transactions for the transaction type |

## Intermediate Model: `analytics.int_suspicious_transaction_flags`

Transaction-level model with suspicious activity rules.

| Column                           | Description                                                           |
| -------------------------------- | --------------------------------------------------------------------- |
| transaction_id                   | Unique transaction identifier                                         |
| transaction_datetime             | Transaction timestamp                                                 |
| transaction_date                 | Transaction date                                                      |
| transaction_type                 | Type of transaction                                                   |
| amount                           | Transaction amount                                                    |
| origin_account                   | Origin account identifier                                             |
| destination_account              | Destination account identifier                                        |
| merchant_category                | Merchant category                                                     |
| location                         | Transaction location                                                  |
| channel                          | Transaction channel                                                   |
| is_fraud                         | Synthetic fraud label                                                 |
| is_flagged_fraud                 | Synthetic fraud flag                                                  |
| is_high_value_transaction        | 1 if amount is greater than or equal to 7500                          |
| is_high_risk_transaction_type    | 1 if transaction type is TRANSFER or CASH_OUT and amount is high      |
| is_high_risk_channel_transaction | 1 if transaction uses mobile_app or online_banking and amount is high |
| is_account_draining_transaction  | 1 if the transaction reduces the origin account balance to zero       |
| suspicious_score                 | Combined suspicious activity score                                    |

## Mart Model: `analytics.mart_daily_transaction_volume`

Final reporting mart for daily transaction monitoring.

| Column                          | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| transaction_date                | Reporting date                                   |
| total_transactions              | Number of transactions on the date               |
| total_transaction_value         | Total transaction value on the date              |
| average_transaction_value       | Average transaction value on the date            |
| minimum_transaction_value       | Minimum transaction value on the date            |
| maximum_transaction_value       | Maximum transaction value on the date            |
| fraud_transaction_count         | Number of fraud transactions on the date         |
| flagged_fraud_transaction_count | Number of flagged fraud transactions on the date |
| fraud_rate_percentage           | Percentage of transactions labelled as fraud     |
| flagged_fraud_rate_percentage   | Percentage of transactions flagged as fraud      |

## Mart Model: `analytics.mart_transaction_type_summary`

Final reporting mart for transaction type analysis.

| Column                          | Description                                                   |
| ------------------------------- | ------------------------------------------------------------- |
| transaction_type                | Type of transaction                                           |
| total_transactions              | Number of transactions for the transaction type               |
| total_transaction_value         | Total value for the transaction type                          |
| average_transaction_value       | Average value for the transaction type                        |
| minimum_transaction_value       | Minimum value for the transaction type                        |
| maximum_transaction_value       | Maximum value for the transaction type                        |
| fraud_transaction_count         | Number of fraud transactions for the transaction type         |
| flagged_fraud_transaction_count | Number of flagged fraud transactions for the transaction type |
| fraud_rate_percentage           | Fraud rate for the transaction type                           |
| flagged_fraud_rate_percentage   | Flagged fraud rate for the transaction type                   |

## Mart Model: `analytics.mart_suspicious_activity`

Final reporting mart for suspicious activity monitoring.

| Column                           | Description                             |
| -------------------------------- | --------------------------------------- |
| transaction_id                   | Unique transaction identifier           |
| transaction_datetime             | Transaction timestamp                   |
| transaction_date                 | Transaction date                        |
| transaction_type                 | Type of transaction                     |
| amount                           | Transaction amount                      |
| origin_account                   | Origin account identifier               |
| destination_account              | Destination account identifier          |
| merchant_category                | Merchant category                       |
| location                         | Transaction location                    |
| channel                          | Transaction channel                     |
| is_fraud                         | Synthetic fraud label                   |
| is_flagged_fraud                 | Synthetic fraud flag                    |
| is_high_value_transaction        | High-value transaction flag             |
| is_high_risk_transaction_type    | High-risk transaction type flag         |
| is_high_risk_channel_transaction | High-risk channel flag                  |
| is_account_draining_transaction  | Account-draining transaction flag       |
| suspicious_score                 | Combined suspicious activity score      |
| suspicious_risk_band             | Risk band derived from suspicious score |

## Mart Model: `analytics.mart_high_value_transactions`

Final reporting mart for high-value transaction monitoring.

| Column               | Description                        |
| -------------------- | ---------------------------------- |
| transaction_id       | Unique transaction identifier      |
| transaction_datetime | Transaction timestamp              |
| transaction_date     | Transaction date                   |
| transaction_type     | Type of transaction                |
| amount               | Transaction amount                 |
| origin_account       | Origin account identifier          |
| destination_account  | Destination account identifier     |
| merchant_category    | Merchant category                  |
| location             | Transaction location               |
| channel              | Transaction channel                |
| is_fraud             | Synthetic fraud label              |
| is_flagged_fraud     | Synthetic fraud flag               |
| suspicious_score     | Combined suspicious activity score |

## Accepted Values

### transaction_type

| Value    | Description                             |
| -------- | --------------------------------------- |
| PAYMENT  | General payment transaction             |
| TRANSFER | Transfer between accounts               |
| CASH_OUT | Cash withdrawal or cash-out transaction |
| CASH_IN  | Cash deposit or cash-in transaction     |
| DEBIT    | Debit transaction                       |

### channel

| Value          | Description               |
| -------------- | ------------------------- |
| mobile_app     | Mobile banking app        |
| online_banking | Online banking channel    |
| atm            | ATM transaction           |
| branch         | Branch transaction        |
| card_terminal  | Card terminal transaction |

### suspicious_risk_band

| Value    | Description                     |
| -------- | ------------------------------- |
| low      | Suspicious score of 1           |
| medium   | Suspicious score of 2           |
| high     | Suspicious score of 3           |
| critical | Suspicious score of 4 or higher |

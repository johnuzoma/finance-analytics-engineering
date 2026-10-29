SELECT
    period_end_date,
    period_value,
    fiscal_year,
    symbol,
    metric,
    metric_value,
    class
FROM {{ ref('transformed_bal_sheet') }}
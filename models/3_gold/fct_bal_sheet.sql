SELECT
    period_end_date,
    period_val,
    fiscal_year,
    symbol,
    metric,
    metric_val,
    class
FROM {{ ref('transformed_bal_sheet') }}
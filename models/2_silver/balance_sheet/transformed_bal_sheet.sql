WITH unpivoted AS (
    {{ dbt_utils.unpivot(
        relation=source('1_bronze', 'raw_bal_sheet'),
        cast_to='bigint',
        exclude=[
            'date', 'period', 'fiscalYear', 'symbol',
            'acceptedDate', 'filingDate', 'cik', 'reportedCurrency',
            'source_file', 'source_path', 'ingestion_timestamp'
        ],
        field_name='metric',
        value_name='value'
    ) }}
),

classified AS (
    SELECT
        CAST(u.date AS DATE) AS period_end_date,
        u.period AS period_val,
        u.fiscalYear AS fiscal_year,
        u.symbol,
        LOWER(REGEXP_REPLACE(u.metric, '([a-z0-9])([A-Z])', '$1_$2')) AS metric,
        u.value AS metric_val,
        COALESCE(c.class, 'Unclassified') AS class
    FROM unpivoted u
    LEFT JOIN {{ ref('bal_sheet_metric_classification') }} c 
        ON u.metric = c.metric
)

SELECT * FROM classified
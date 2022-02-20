{{
    config(
        materialized = 'table'
    )
}}
select * 
from {{ metrics.metric(
    metric_name='new_orders',
    grain='week',
    dimensions=['order_status_code'],
    secondary_calculations=[
        metrics.period_over_period(comparison_strategy="ratio", interval=1, alias="pop_1wk"),
        metrics.period_over_period(comparison_strategy="difference", interval=1),

        metrics.period_to_date(aggregate="average", period="month", alias="this_month_average"),
        metrics.period_to_date(aggregate="sum", period="year"),

        metrics.rolling(aggregate="average", interval=4, alias="avg_past_4wks"),
        metrics.rolling(aggregate="min", interval=4)
    ]
) }}
{{
    config(
        materialized = 'table'
    )
}}
with customers as (

    select * from {{ ref('stg_customer') }}

)

select
    customer_key,
    customer_name,
    customer_address,
    nation_key,
    customer_phone_number,
    customer_account_balance,
    customer_market_segment_name
from
    customers
order by
    customer_key
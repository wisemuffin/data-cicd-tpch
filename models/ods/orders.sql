{{
    config(
        materialized = 'table'
    )
}}
with orders as (

    select * from {{ ref_for_test('stg_orders') }}

)

select
    order_key,
    order_date,
    customer_key,
    order_status_code,
    order_priority_code,
    order_clerk_name,
    shipping_priority,
    order_amount
from orders
order by order_date
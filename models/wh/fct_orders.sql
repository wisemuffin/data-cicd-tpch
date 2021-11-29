{{
    config(
        materialized = 'table'
    )
}}
with orders as (

    select * from {{ ref('orders') }}

),

orders_items as (

    select * from {{ ref('orders_items') }}

),

order_item_summary as (

    select
        orders_items.order_key,
        sum(orders_items.gross_item_sales_amount) as gross_item_sales_amount,
        sum(orders_items.item_discount_amount) as item_discount_amount,
        sum(orders_items.item_tax_amount) as item_tax_amount,
        sum(orders_items.net_item_sales_amount) as net_item_sales_amount
    from orders_items
    group by 1
),

final as (

    select

        orders.order_key,
        orders.order_date,
        orders.customer_key,
        orders.order_status_code,
        orders.order_priority_code,
        orders.order_clerk_name,
        orders.shipping_priority,

        1 as order_count,
        order_item_summary.gross_item_sales_amount,
        order_item_summary.item_discount_amount,
        order_item_summary.item_tax_amount,
        order_item_summary.net_item_sales_amount
    from orders
    join order_item_summary
        on orders.order_key = order_item_summary.order_key
)

select
    final.*,
    {{ dbt_housekeeping() }}
from
    final
order by
    final.order_date
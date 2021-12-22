{{
    config(
        materialized = 'table'
    )
}}

/*
Per TPC-H Spec:
2.4.1 Pricing Summary Report Query (Q1)
*/

select
    fct_orders_items.return_status_code,
    fct_orders_items.order_line_status_code,
    sum(fct_orders_items.quantity) as quantity,
    sum(fct_orders_items.gross_item_sales_amount) as gross_item_sales_amount,
    sum(fct_orders_items.discounted_item_sales_amount)
    as discounted_item_sales_amount,
    sum(fct_orders_items.net_item_sales_amount) as net_item_sales_amount,

    avg(fct_orders_items.quantity) as avg_quantity,
    avg(fct_orders_items.base_price) as avg_base_price,
    avg(fct_orders_items.discount_percentage) as avg_discount_percentage,

    sum(fct_orders_items.order_item_count) as order_item_count

from
    {{ ref_for_test('fct_orders_items') }}
where fct_orders_items.ship_date
    <= {{ dbt_utils.dateadd('day', -90, var('max_ship_date')) }}
group by 1, 2
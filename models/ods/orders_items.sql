{{
    config(
        materialized = 'table'
    )
}}
with orders as (
    
    select * from {{ ref_for_test('stg_orders') }}

),

line_items as (

    select * from {{ ref_for_test('stg_line_item') }}

)

select

    orders.order_key,
    orders.order_date,
    orders.customer_key,
    orders.order_status_code,

    line_items.part_key,
    line_items.supplier_key,
    line_items.return_status_code,
    line_items.order_line_number,
    line_items.order_line_status_code,
    line_items.ship_date,
    line_items.commit_date,
    line_items.receipt_date,
    line_items.ship_mode_name,
    line_items.quantity,

    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    line_items.extended_price as gross_item_sales_amount,
    line_items.discount_percentage,
    line_items.tax_rate,

    (line_items.extended_price
        / nullif(line_items.quantity, 0)){{ money() }} as base_price,
    (base_price * (1 - line_items.discount_percentage))
        {{ money() }} as discounted_price,

    (line_items.extended_price
        * (1 - line_items.discount_percentage)){{ money() }}
    as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * line_items.extended_price
        * line_items.discount_percentage){{ money() }}
    as item_discount_amount,
    ((gross_item_sales_amount + item_discount_amount)
        * line_items.tax_rate){{ money() }} as item_tax_amount,
    (gross_item_sales_amount
        + item_discount_amount
        + item_tax_amount
    ){{ money() }} as net_item_sales_amount,

    {{ dbt_utils.surrogate_key(['orders.order_key', 'line_items.order_line_number']) }} as order_item_key

from orders
join line_items
    on orders.order_key = line_items.order_key
order by
    orders.order_date
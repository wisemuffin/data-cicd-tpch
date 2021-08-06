-- Example test
select
    order_key,
    net_item_sales_amount
from {{ ref('fct_orders' )}}
where net_item_sales_amount >= 10000000 -->= 528822
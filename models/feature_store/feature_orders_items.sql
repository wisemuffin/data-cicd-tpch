{{
    config(
        materialized = 'view'
    )
}}
with fct_orders_items as (
    select *
    from {{ ref('fct_orders_items') }}
) 
, order_status_code_encoded as (

    {# see issue when using include_columns https://github.com/omnata-labs/dbt-ml-preprocessing/issues/12 #}
    {# include_columns=['order_item_key'], #}
    {{ dbt_ml_preprocessing.one_hot_encoder( source_table=ref('fct_orders_items'),
                                            source_column='order_status_code',
                                            categories=['P','F','O'],
                                            handle_unknown='ignore') }}
)
, ship_mode_name_encoded as (

    {# see issue when using include_columns https://github.com/omnata-labs/dbt-ml-preprocessing/issues/12 #}
    {# include_columns=['order_item_key'], #}
    {{ dbt_ml_preprocessing.one_hot_encoder( source_table=ref('fct_orders_items'),
                                            source_column='ship_mode_name',
                                            handle_unknown='ignore') }}
)
, scaled_values as (
    {{dbt_ml_preprocessing.standard_scaler(source_table=ref('fct_orders_items'),
                                            source_columns=['base_price', 'supplier_cost_amount', 'discount_percentage'],
                                            include_columns=['order_item_key'])}}
)
select
{# fct_orders_items.order_item_key #}
{# cant use star on a cte see as it queries info schema (note can use except if big query) #}
{# , {{dbt_utils.star(from=ref('scaled_values'), except=["order_item_key"]))}} #}
scaled_values.*
, order_status_code_encoded.is_order_status_code_F
, order_status_code_encoded.is_order_status_code_O
, order_status_code_encoded.is_order_status_code_P
, ship_mode_name_encoded.is_ship_mode_name_AIR
, ship_mode_name_encoded.is_ship_mode_name_RAIL


from fct_orders_items
left join order_status_code_encoded on fct_orders_items.order_item_key = order_status_code_encoded.order_item_key
left join ship_mode_name_encoded on fct_orders_items.order_item_key = ship_mode_name_encoded.order_item_key
left join scaled_values on fct_orders_items.order_item_key = scaled_values.order_item_key
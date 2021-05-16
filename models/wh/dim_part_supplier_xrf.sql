{{
    config(
        materialized = 'table'
    )
}}
with suppliers as (

    select * from {{ ref('suppliers') }}

),

parts as (
    
    select * from {{ ref('parts') }}

),

parts_suppliers as (

    select * from {{ ref('parts_suppliers') }}

),

nations as (

    select * from {{ ref('nations') }}
),

regions as (

    select * from {{ ref('regions') }}

),

final as (

    select
        parts_suppliers.part_supplier_key,

        parts.part_key,
        parts.part_name,
        parts.part_manufacturer_name,
        parts.part_brand_name,
        parts.part_type_name,
        parts.part_size,
        parts.part_container_desc,
        parts.retail_price,

        suppliers.supplier_key,
        suppliers.supplier_name,
        supplier_address,
        suppliers.supplier_phone_number,
        suppliers.supplier_account_balance,
        nations.nation_key as supplier_nation_key, nationnation_name as supplier_nation_name, regionregion_key as supplier_region_key,
        regions.region_name as supplier_region_name,

        parts_suppliers.supplier_availabe_quantity,
        parts_suppliers.supplier_cost_amount
    from parts p
    join parts_suppliers
        on parts.part_key = parts_suppliers.part_key
    join suppliers
        on parts_suppliers.supplier_key = suppliers.supplier_key
    join nations
        on suppliers.nation_key = nations.nation_key
    join regions
        on nations.region_key = regions.region_key
)

select
    final.*,
    {{ dbt_housekeeping() }}
from
    final
order by
    final.part_key,
    final.supplier_key
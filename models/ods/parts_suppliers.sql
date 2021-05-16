{{
    config(
        materialized = 'table'
    )
}}
with parts as (
    
    select * from {{ ref('parts') }}

),

suppliers as (

    select * from {{ ref('suppliers') }}

),

part_suppliers as (

    select * from {{ ref('base_part_supplier') }}

)

select

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
    suppliers.nation_key,

    part_suppliers.supplier_availabe_quantity,
    part_suppliers.supplier_cost_amount,

    {{ dbt_utils.surrogate_key(['parts.part_key', 's.supplier_key']) }} as part_supplier_key

from parts
join part_suppliers
    on parts.part_key = part_suppliers.part_key
join suppliers
    on part_suppliers.supplier_key = suppliers.supplier_key
order by
    parts.part_key
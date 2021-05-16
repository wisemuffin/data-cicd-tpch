{{
    config(
        materialized = 'table'
    )
}}

/*
Per TPC-H Spec: 
2.4.2 Minimum Cost Supplier Query (Q2)
*/

with parts_suppliers as (

    select
        s.supplier_account_balance,
        s.supplier_name,
        s.supplier_nation_key,
        s.supplier_region_key,
        s.supplier_nation_name,
        s.supplier_region_name,
        s.part_key,
        s.part_manufacturer_name,
        s.part_size,
        s.part_type_name,
        s.supplier_cost_amount,
        s.supplier_address,
        s.supplier_phone_number,
        rank() over(partition by s.supplier_region_key, s.part_key order by s.supplier_cost_amount) as supplier_cost_rank,
        row_number() over(partition by s.supplier_region_key, s.part_key, s.supplier_cost_amount order by s.supplier_account_balance desc) as supplier_rank
    from
        {{ ref("dim_part_supplier_xrf") }} as s
)

select
    parts_suppliers.*
from
    parts_suppliers
where
    parts_suppliers.supplier_cost_rank = 1 and 
    parts_suppliers.supplier_rank <= 100
order by 
    parts_suppliers.supplier_name, parts_suppliers.part_key
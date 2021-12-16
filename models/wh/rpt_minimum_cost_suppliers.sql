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
        dim_part_supplier_xrf.part_supplier_key,
        dim_part_supplier_xrf.supplier_account_balance,
        dim_part_supplier_xrf.supplier_name,
        dim_part_supplier_xrf.supplier_nation_key,
        dim_part_supplier_xrf.supplier_region_key,
        dim_part_supplier_xrf.supplier_nation_name,
        dim_part_supplier_xrf.supplier_region_name,
        dim_part_supplier_xrf.part_key,
        dim_part_supplier_xrf.part_manufacturer_name,
        dim_part_supplier_xrf.part_size,
        dim_part_supplier_xrf.part_type_name,
        dim_part_supplier_xrf.supplier_cost_amount,
        dim_part_supplier_xrf.supplier_address,
        dim_part_supplier_xrf.supplier_phone_number,
        rank() over(partition by dim_part_supplier_xrf.supplier_region_key,
            dim_part_supplier_xrf.part_key
            order by dim_part_supplier_xrf.supplier_cost_amount)
        as supplier_cost_rank,
        row_number() over(
            partition by dim_part_supplier_xrf.supplier_region_key,
                dim_part_supplier_xrf.part_key,
                dim_part_supplier_xrf.supplier_cost_amount
            order by dim_part_supplier_xrf.supplier_account_balance desc)
        as supplier_rank
    from
        {{ ref("dim_part_supplier_xrf") }}
)

select
    parts_suppliers.*
from
    parts_suppliers
where parts_suppliers.supplier_cost_rank = 1
    and parts_suppliers.supplier_rank <= 100
order by
    parts_suppliers.supplier_name, parts_suppliers.part_key
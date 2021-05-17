{{
    config(
        materialized = 'table'
    )
}}
with suppliers as (

    select * from {{ ref('base_supplier') }}

)
select 
    suppliers.supplier_key,
    suppliers.supplier_name || 'davegggg' as supplier_name,
    suppliers.supplier_address,
    suppliers.nation_key,
    suppliers.supplier_phone_number,
    suppliers.supplier_account_balance
from
    suppliers
order by
    suppliers.supplier_key
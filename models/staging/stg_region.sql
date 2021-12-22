{{
    config(
        materialized = 'view'
    )
}}
select
    r_regionkey as region_key,
    r_name as region_name,
    r_comment as region_comment
from
    {{ source_for_test('tpch', 'region') }}

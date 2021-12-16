{{
    config(
        materialized = 'table'
    )
}}
with parts as (

    select * from {{ ref('base_part') }}

)

select
    1 as test_part,
    parts.part_key,
    parts.part_name,
    parts.part_manufacturer_name,
    parts.part_brand_name,
    parts.part_type_name,
    parts.part_size,
    parts.part_container_desc,
    parts.retail_price,
    null as dumby_column
from
    parts
order by
    parts.part_key
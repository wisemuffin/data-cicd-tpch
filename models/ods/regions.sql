{{
    config(
        materialized = 'table'
    )
}}
with regions as (

    select * from {{ ref('base_region') }}

)

select
    regions.region_key,
    regions.region_name
from
    regions
order by
    regions.region_key
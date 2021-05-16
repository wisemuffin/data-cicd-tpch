{{
    config(
        materialized = 'table'
    )
}}
with nations as (

    select * from {{ ref('base_nation') }}

)

select
    nation_key,
    nation_name,
    region_key
from
    nations
order by
    nation_key
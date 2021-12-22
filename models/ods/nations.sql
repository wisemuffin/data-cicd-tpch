{{
    config(
        materialized = 'table'
    )
}}
with nations as (

    select * from {{ ref_for_test('stg_nation') }}

)

select
    nation_key,
    nation_name,
    region_key
from
    nations
order by
    nation_key
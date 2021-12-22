WITH source AS (

    SELECT *
    FROM {{ ref_for_test('date_details_source')}}

)

SELECT *
FROM source

WITH source AS (

    SELECT *
    FROM {{ ref('date_details_source')}}

)

SELECT *
FROM source

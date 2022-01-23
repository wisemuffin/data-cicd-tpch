WITH dates AS (

  SELECT *
  FROM {{ ref('date_details') }}

), final AS (

  SELECT
    {{ get_date_id('date_actual') }}                                AS date_id,
    *,
    COUNT(date_id) OVER (PARTITION BY first_day_of_month)           AS days_in_month_count
  FROM dates

)

{{ dbt_audit(
    cte_ref="final",
    created_by="@davidgriffiths",
    updated_by="@wisemuffin",
    created_date="2020-06-01",
    updated_date="2022-01-23"
) }}

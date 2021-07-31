{%- macro schema_union_all(schema_part, table_name, exclude_part='scratch', database_name=none) -%}

 {% if database_name is not none %}

    {% set database = database_name %}

 {% else %}

    {% set database = target.database %}

 {% endif %}

 {% call statement('get_schemata', fetch_result=True) %}

    SELECT DISTINCT '"' || table_schema || '"."' || table_name || '"'
    FROM "{{ database }}".information_schema.tables
    WHERE table_schema ILIKE '%{{ schema_part }}%'
      AND table_schema NOT ILIKE '%{{ exclude_part }}%'
      AND table_name ILIKE '{{ table_name }}'
    ORDER BY 1

  {%- endcall -%}

    {%- set value_list = load_result('get_schemata') -%}

    {%- if value_list and value_list['data'] -%}

        {%- set values = value_list['data'] | map(attribute=0) | list %}

            {% for schematable in values %}
                SELECT *
                FROM "{{ database }}".{{ schematable }}

            {%- if not loop.last %}
                UNION ALL
            {% endif -%}

            {% endfor -%}

    {%- else -%}

        {{ return(1) }}

    {%- endif %}

{%- endmacro -%}

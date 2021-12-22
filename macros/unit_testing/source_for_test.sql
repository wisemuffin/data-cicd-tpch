{% macro source_for_test(source_schema, source_name) %}

      {%- set normal_source_relation = source(source_schema, source_name) -%}
      {%- set test_ref_relation = this -%}

      {% if target.name == 'unit-test' %}

            {%- set test_source_relation = adapter.get_relation(
                  database = test_ref_relation.database,
                  schema = 'staging',
                  identifier = 'test_' ~ source_name) 
            -%}
            
            {{ return(test_source_relation) }}

      {% else %}

            {{ return(normal_source_relation) }}

      {% endif %}

{% endmacro %}
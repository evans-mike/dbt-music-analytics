{% macro boolean_to_emoji(column) -%}
  CASE WHEN {{ column }} THEN '✅' ELSE '❌' END
{%- endmacro %}

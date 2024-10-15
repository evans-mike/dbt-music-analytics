{% macro get_quarter(date_column) -%}
    format_date('%Y-Q%Q', {{ date_column }})
{%- endmacro %}

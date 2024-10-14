{% macro get_period(date_column, interval, span, max_multiplier=5) -%}
    CASE
        WHEN {{ date_column }} > CURRENT_DATE()
        THEN '0-(future)'
        
        {% for i in range(1, max_multiplier + 1) %}
            WHEN 
                DATE_DIFF(CURRENT_DATE(), {{ date_column }}, {{ interval }}) > ({{ (i - 1) * span }})
                AND DATE_DIFF(CURRENT_DATE(), {{ date_column }}, {{ interval }}) <= ({{ i * span }})
            THEN CONCAT(
                LPAD(CAST(({{ (i - 1) * span }}) AS STRING), 2, '0'), '-', 
                LPAD(CAST(({{ i * span }}) AS STRING), 2, '0'), 
                '{{ interval }}s'
            )
        {% endfor %}

        ELSE CONCAT(
            LPAD(CAST(({{ max_multiplier * span }}) AS STRING), 2, '0'), '+', 
            '{{ interval }}s'
        )
    END
{%- endmacro %}

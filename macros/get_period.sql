{% macro get_period(date_column, interval, span, max_multiplier=5) -%}
    case
        when {{ date_column }} > current_date()
        then '0-(future)'

        {% for i in range(1, max_multiplier + 1) %}
            when
                date_diff(current_date(), {{ date_column }}, {{ interval }})
                > ({{ (i - 1) * span }})
                and date_diff(current_date(), {{ date_column }}, {{ interval }})
                <= ({{ i * span }})
            then
                concat('{{ (i - 1) * span }}', '-', '{{ i * span }}', '{{ interval }}s')
        {% endfor %}

        else concat('{{ max_multiplier * span }}', '+{{ interval }}s')
    end
{%- endmacro %}

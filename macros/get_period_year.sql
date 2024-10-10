{% macro get_period_year(date_column) -%}
    case
        when {{ date_column }} > current_date()
        then '-upcoming'
        when date_diff(current_date(), {{ date_column }}, month) <= 12
        then '0-12mos'
        when
            date_diff(current_date(), {{ date_column }}, month) > 12
            and date_diff(current_date(), {{ date_column }}, month) <= 24
        then '12-24mos'
        when
            date_diff(current_date(), {{ date_column }}, month) > 24
            and date_diff(current_date(), {{ date_column }}, month) <= 36
        then '24-36mos'
        when
            date_diff(current_date(), {{ date_column }}, month) > 36
            and date_diff(current_date(), {{ date_column }}, month) <= 48
        then '36-48mos'
        when
            date_diff(current_date(), {{ date_column }}, month) > 48
            and date_diff(current_date(), {{ date_column }}, month) <= 60
        then '48-60mos'
        else '60+mos'
    end
{%- endmacro %}

{% macro weeks_since_last_sung(last_occurred, as_of_date=None) %}
    {% if as_of_date %}
        DATE_DIFF({{ as_of_date }}, {{ last_occurred }}, DAY) / 7.0
    {% else %}
        DATE_DIFF(CURRENT_DATE(), {{ last_occurred }}, DAY) / 7.0
    {% endif %}
{% endmacro %}

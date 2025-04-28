{% macro familiarity_score(occurrences, weeks_window, freshness_score) %}
    round(
        case
            when {{ occurrences }} is null
            then 0
            when {{ weeks_window }} is null
            then 0
            when {{ freshness_score }} is null
            then 0
            else
                least({{ occurrences }} / ((8 / 52.0) * {{ weeks_window }}), 1.0)
                * ({{ freshness_score }} / 100)
                * 100
        end,
        2
    )
{% endmacro %}

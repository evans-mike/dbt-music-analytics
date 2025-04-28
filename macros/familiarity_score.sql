{% macro familiarity_score(occurrences, freshness_score) %}
    round(
        case
            when {{ occurrences }} is null
            then 0
            when {{ freshness_score }} is null
            then 0
            else
                least({{ occurrences }} / 7.0, 1.0)
                * ({{ freshness_score }} / 100)
                * least({{ occurrences }} / 4.0, 1.0)
                * 100
        end,
        2
    )
{% endmacro %}

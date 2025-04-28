{% macro freshness_score(last_occurred, half_life_weeks=26) %}
    case
        when {{ last_occurred }} is null
        then 0
        else
            round(
                100 * power(
                    0.5,
                    (
                        coalesce({{ weeks_since_last_sung(last_occurred) }}, 0)
                        / {{ half_life_weeks }}
                    )
                ),
                2
            )
    end
{% endmacro %}

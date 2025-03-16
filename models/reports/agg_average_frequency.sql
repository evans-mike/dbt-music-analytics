with
    agg_average_frequency as (
        select
            round((count(date) / count(distinct title)), 2) ave_frequency,
            {{ get_period("date", "week", 52, 5) }} as period,
        from {{ ref("fact_song_occurrences") }}
        group by period
        order by period
    )

select *
from agg_average_frequency

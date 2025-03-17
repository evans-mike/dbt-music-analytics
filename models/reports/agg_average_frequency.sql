with
    agg_average_frequency as (
        select
            period,
            round((count(date) / count(distinct title)), 2) ave_frequency,
        from {{ ref("fact_song_occurrences") }}
        group by period
        order by period
    )

select *
from agg_average_frequency

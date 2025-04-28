select
    dense_rank() over (order by grand_total desc) as rank,
    *,
    {{ familiarity_score("grand_total", 52, "freshness_score") }} as familiarity_score
from
    (
        select *, coalesce(am, 0) + coalesce(pm, 0) as grand_total
        from
            (
                select
                    title,
                    is_hymn,
                    has_refrain,
                    last_occurred,
                    freshness_score,
                    date,
                    service
                from {{ ref("fact_song_occurrences") }}
                where period = '000-052weeks'
            )
            pivot (count(date) for service in ('AM', 'PM'))
    )
order by grand_total desc, last_occurred desc

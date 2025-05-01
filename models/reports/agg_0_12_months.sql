select
    dense_rank() over (order by grand_total desc) as rank,
    *
from
    (
        select *, coalesce(am, 0) + coalesce(pm, 0) as grand_total
        from
            (
                select
                    title,
                    is_retired,
                    is_hymn,
                    has_refrain,
                    last_occurred,
                    familiarity_score,
                    date,
                    service
                from {{ ref("fact_song_occurrences") }}
                where period = '000-052weeks'
            )
            pivot (count(date) for service in ('AM', 'PM'))
    )
order by grand_total desc, last_occurred desc

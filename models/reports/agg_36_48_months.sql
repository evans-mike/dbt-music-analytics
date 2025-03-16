select *, coalesce(am, 0) + coalesce(pm, 0) as grand_total
from
    (
        select title, is_hymn, has_refrain, last_occurred, date, service
        from {{ ref("fact_song_occurrences") }}
        where period = '156-208weeks'
    )
    pivot (count(date) for service in ('AM', 'PM'))
order by grand_total desc

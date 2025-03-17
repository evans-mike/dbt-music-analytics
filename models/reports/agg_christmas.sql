select
    *,
    coalesce(`000-052weeks`, 0)
    + coalesce(`052-104weeks`, 0)
    + coalesce(`104-156weeks`, 0)
    + coalesce(`156-208weeks`, 0) as grand_total
from
    (
        select
            title,
            last_occurred,
            date,
            period
        from {{ ref("fact_song_occurrences") }}
        where is_christmas = true
    ) pivot (
        count(date) for period
        in ('000-052weeks', '052-104weeks', '104-156weeks', '156-208weeks')
    )
order by grand_total desc

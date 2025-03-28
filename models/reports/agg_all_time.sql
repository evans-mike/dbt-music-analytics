select dense_rank() over (order by grand_total desc) as rank, *
from
    (
        select
            title,
            year_published,
            author_group,
            last_occurred,
            date,
            period
        from {{ ref("fact_song_occurrences") }}
    ) pivot (
        count(date) for period
        in ('000-052weeks', '052-104weeks', '104-156weeks', '156-208weeks')
)
order by grand_total desc

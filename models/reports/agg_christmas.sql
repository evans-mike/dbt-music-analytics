select dense_rank() over (order by grand_total desc) as rank, *
from
    (
        select
            *,
            coalesce(`_2022`, 0)
            + coalesce(`_2023`, 0)
            + coalesce(`_2024`, 0) as grand_total
        from
            (
                select title, last_occurred, date, year
                from {{ ref("fact_song_occurrences") }}
                where is_christmas = '✅'
            )
            pivot (count(date) for year in (2022, 2023, 2024, 2025))
    )
order by grand_total desc

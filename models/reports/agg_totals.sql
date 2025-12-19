select period, count_occurrences, count_titles
from
    (
        select
            "all time" as period,
            count(date) count_occurrences,
            count(distinct title) count_titles
        from {{ ref("fact_song_occurrences") }}
        union all
        (
            select
                {{ get_period("date", "week", 52, 8) }} as period,
                count(date),
                count(distinct title)
            from {{ ref("fact_song_occurrences") }}
            group by period
        )
    )
group by period, count_occurrences, count_titles
order by period asc

with
    introductions_per_period as (
        select
            {{ get_period("date", "month", 3, 24) }} as period,
            count(distinct title) titles_introduced
        from {{ ref("fact_song_occurrences") }}
        where format_date('%Y-Q%Q', introduced) = format_date('%Y-Q%Q', date)
        group by period
        order by period
    ),

    occurrences_per_period as (
        select
            {{ get_period("date", "month", 3, 24) }} as period,
            count(distinct title) titles_occurred
        from {{ ref("fact_song_occurrences") }}
        group by period
        order by period
    )

select
    occurrences_per_period.period,
    round(
        (
            introductions_per_period.titles_introduced
            / occurrences_per_period.titles_occurred
        )
        * 100,
        1
    ) intro_percentage_rate,
    occurrences_per_period.titles_occurred,
    introductions_per_period.titles_introduced
from occurrences_per_period
join introductions_per_period using (period)
order by occurrences_per_period.period

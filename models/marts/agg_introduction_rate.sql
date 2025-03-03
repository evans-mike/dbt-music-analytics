with
    introductions_per_period as (
        select
            {{ get_period("date", "week", 13, 24) }} as period,
            count(distinct title) distinct_titles_introduced
        from {{ ref("fact_song_occurrences") }}
        where format_date('%Y-Q%Q', introduced) = format_date('%Y-Q%Q', date)
        group by period
        order by period
    ),

    occurrences_per_period as (
        select
            {{ get_period("date", "week", 13, 24) }} as period,
            count(distinct title) distinct_titles
        from {{ ref("fact_song_occurrences") }}
        group by period
        order by period
    ),

    agg_introduction_rate as (
        select
            occurrences_per_period.period,
            round(
                (
                    introductions_per_period.distinct_titles_introduced
                    / occurrences_per_period.distinct_titles
                )
                * 100,
                1
            ) intro_percentage_rate,
            occurrences_per_period.distinct_titles,
            introductions_per_period.distinct_titles_introduced
        from occurrences_per_period
        join introductions_per_period using (period)
        order by occurrences_per_period.period
    )

select *
from agg_introduction_rate
with
    introductions_per_quarter as (
        select
            {{ get_period_quarter("date") }} as quarter,
            count(distinct title) titles_introduced
        from {{ ref("fact_song_occurrences") }}
        where format_date('%Y-Q%Q', introduced) = format_date('%Y-Q%Q', date)
        group by quarter
        order by quarter
    ),

    occurrences_per_quarter as (
        select {{ get_period_quarter("date") }} as quarter, count(title) titles_occurred
        from {{ ref("fact_song_occurrences") }}
        group by quarter
        order by quarter
    )

select
    occurrences_per_quarter.quarter,
    round(
        (
            introductions_per_quarter.titles_introduced
            / occurrences_per_quarter.titles_occurred
        )
        * 100,
        1
    ) intro_percentage_rate,
    occurrences_per_quarter.titles_occurred distinct_titles_occurred,
    introductions_per_quarter.titles_introduced distinct_titles_introduced
from occurrences_per_quarter
join introductions_per_quarter using (quarter)
order by occurrences_per_quarter.quarter

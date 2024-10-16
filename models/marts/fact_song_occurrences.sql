with
    song_occurrences as (select * from {{ ref("stg__song_occurrences") }}),

    song_introd as (
        select title, min(date) as introduced
        from {{ ref("stg__song_occurrences") }}
        group by title
    ),

    song_last_occurred as (
        select title, max(date) as last_occurred
        from {{ ref("stg__song_occurrences") }}
        group by title
    ),

    christmas_songs as (
        select title, is_christmas
        from {{ ref("dim_songs") }}
        where is_christmas = true
    ),

    fact_song_occurrences as (
        select
            date,
            extract(year from date) as year,
            {{ get_period("date", "month", 12, 4) }} as period,
            title,
            closer_flag,
            song_introd.introduced,
            {{ get_period("song_introd.introduced", "month", 12, 4) }}
            as introduced_period,
            song_last_occurred.last_occurred,
            christmas_songs.is_christmas
        from song_occurrences
        left join christmas_songs using (title)
        left join song_introd using (title)
        left join song_last_occurred using (title)
    )

select *
from fact_song_occurrences

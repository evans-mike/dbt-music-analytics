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

    song_last_occurred_as_closer as (
        select title, max(date) as last_occurred_as_closer
        from {{ ref("stg__song_occurrences") }}
        where closer_flag = true
        group by title
    ),

    christmas_songs as (
        select title, is_christmas
        from {{ ref("dim_songs") }}
        where is_christmas = true
    ),

    hymn_songs as (
        select title, is_hymn
        from {{ ref("dim_songs") }}
        where is_hymn = true
    ),

    refrain_songs as (
        select title, has_refrain
        from {{ ref("dim_songs") }}
        where has_refrain = true
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
            song_last_occurred_as_closer.last_occurred_as_closer,
            christmas_songs.is_christmas,
            hymn_songs.is_hymn,
            refrain_songs.has_refrain
        from song_occurrences
        left join christmas_songs using (title)
        left join song_introd using (title)
        left join song_last_occurred using (title)
        left join song_last_occurred_as_closer using (title)
        left join hymn_songs using (title)
        left join refrain_songs using (title)
    )

select *
from fact_song_occurrences

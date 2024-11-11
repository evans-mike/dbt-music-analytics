with
    songs as (select * from {{ ref("stg__songs") }}),

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

    dim_songs as (
        select
            songs.*,
            song_introd.introduced,
            extract(year from song_introd.introduced) as year_introduced,
            {{ get_period("song_introd.introduced", "month", 3, 24) }}
            as period_introduced,
            song_last_occurred.last_occurred,
            song_last_occurred_as_closer.last_occurred_as_closer,
            case
                when songs.attributes like '%christmas%' then true else false
            end as is_christmas,
            case
                when songs.attributes like '%hymn%' then true else false
            end as is_hymn,
            case
                when songs.attributes like '%refrain%' then true else false
            end as has_refrain
        from songs
        left join song_introd using (title)
        left join song_last_occurred using (title)
        left join song_last_occurred_as_closer using (title)
    )

select *
from dim_songs

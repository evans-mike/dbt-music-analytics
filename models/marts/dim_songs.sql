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
    )

select
    songs.*,
    song_introd.introduced,
    extract(year from song_introd.introduced) as year_introduced,
    {{ get_period("song_introd.introduced", "month", 3, 24) }} as period_introduced,
    song_last_occurred.last_occurred
from songs
left join song_introd using (title)
left join song_last_occurred using (title)

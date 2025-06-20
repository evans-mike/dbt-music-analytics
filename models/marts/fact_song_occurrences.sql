with
    song_occurrences as (select * from {{ ref("stg__song_occurrences") }}),

    christmas_songs as (
        select title, is_christmas
        from {{ ref("stg__songs") }}
        where is_christmas = '✅'
    ),

    hymn_songs as (
        select title, is_hymn from {{ ref("stg__songs") }} where is_hymn = '✅'
    ),

    refrain_songs as (
        select title, has_refrain from {{ ref("stg__songs") }} where has_refrain = '✅'
    ),

    fact_song_occurrences as (
        select
            song_occurrences.*,
            stg__songs.author_group,
            stg__songs.introduced,
            -- stg__songs.introduced_period,
            stg__songs.last_occurred,
            stg__songs.last_occurred_as_closer,
            stg__songs.familiarity_score,
            stg__songs.year_published,
            stg__songs.century,
            christmas_songs.is_christmas,
            hymn_songs.is_hymn,
            refrain_songs.has_refrain,
            stg__songs.is_active
        from song_occurrences
        left join christmas_songs using (title)
        left join hymn_songs using (title)
        left join refrain_songs using (title)
        left join {{ ref("stg__songs") }} using (title)
    )

select *
from fact_song_occurrences

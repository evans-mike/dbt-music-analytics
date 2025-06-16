with
    song_introd as (
        select title, min(date) as introduced
        from {{ source("raw_data", "song_occurrences") }}
        group by title
    ),

    song_last_occurred as (
        select
            title,
            max(date) as last_occurred,
            {{ freshness_score("max(date)") }} as freshness_score
        from {{ source("raw_data", "song_occurrences") }}
        group by title
    ),

    song_last_occurred_as_closer as (
        select title, max(date) as last_occurred_as_closer
        from {{ source("raw_data", "song_occurrences") }}
        where closer_flag = true
        group by title
    ),

    song_total_occurrences as (
        select title, count(date) as total_occurrences
        from {{ source("raw_data", "song_occurrences") }}
        group by title
    )

select
    title,
    attributes,
    author_group,
    authors,
    cast(year as int64) year_published,
    cast(ceil(cast(year as int64) / 100) as int64) as century,
    {{boolean_to_emoji("case
        when songs.attributes like '%christmas%' then true else false
    end")}} as is_christmas,
    {{boolean_to_emoji("case
        when songs.attributes like '%we%' then true else false
    end")}} as is_corporate,
    {{boolean_to_emoji("case when songs.attributes like '%hymn%' then true else false end")}} as is_hymn,
    {{boolean_to_emoji("case when songs.attributes like '%refrain%' then true else false end")}} as has_refrain,
    song_introd.introduced,
    song_last_occurred.last_occurred,
    song_last_occurred.freshness_score,
    song_last_occurred_as_closer.last_occurred_as_closer,
    {{
        familiarity_score(
            "song_total_occurrences.total_occurrences",
            "song_last_occurred.freshness_score",
        )
    }} as familiarity_score,
    {{ boolean_to_emoji('is_active') }} as is_active
from {{ source("raw_data", "songs") }}
left join song_introd using (title)
left join song_last_occurred using (title)
left join song_last_occurred_as_closer using (title)
left join song_total_occurrences using (title)

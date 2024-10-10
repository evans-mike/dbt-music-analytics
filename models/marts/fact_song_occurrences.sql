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

    final as (
        select
            date,
            extract(year from date) as year,
            {{ get_period_year("date") }} as period,
            title,
            closer_flag,
            song_introd.introduced,
            song_last_occurred.last_occurred
        from song_occurrences
        left join song_introd using (title)
        left join song_last_occurred using (title)
    )

select *
from final

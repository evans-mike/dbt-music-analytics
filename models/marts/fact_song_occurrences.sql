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
            case
                when
                    date
                    between date_sub(current_date(), interval 12 month) and date_add(
                        current_date(), interval 1 month
                    )
                then "0-12mos"
                when
                    date
                    between date_sub(current_date(), interval 24 month) and date_sub(
                        current_date(), interval 12 month
                    )
                then "12-24mos"
                when
                    date
                    between date_sub(current_date(), interval 36 month) and date_sub(
                        current_date(), interval 24 month
                    )
                then "24-36mos"
                when
                    date
                    between date_sub(current_date(), interval 48 month) and date_sub(
                        current_date(), interval 36 month
                    )
                then "36-48mos"
                when
                    date
                    between date_sub(current_date(), interval 60 month) and date_sub(
                        current_date(), interval 48 month
                    )
                then "48-60mos"
                else "unknown"
            end as period,

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

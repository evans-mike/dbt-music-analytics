with
    song_occurrences as (select * from {{ ref("stg__song_occurrences") }}),

    final as (
        select
            date,
            extract(year from date) as year,
            case
                when
                    date between date_sub(
                        current_date(), interval 12 month
                    ) and current_date()
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
                else null
            end as period,

            title,
            coalesce(closer_flag,false) as closer_flag
        from song_occurrences
    )

select *
from final

select dense_rank() over (order by grand_total desc) as rank, * except (period)
from
    (
        select *, coalesce(am, 0) + coalesce(pm, 0) as grand_total
        from
            (
                select *
                from
                    (
                        select
                            title,
                            is_active as keep,
                            is_hymn,
                            has_refrain,
                            last_occurred,
                            familiarity_score,
                            date,
                            service,
                            {{ get_period("date", "week", 26, 16) }} as period
                        from {{ ref("fact_song_occurrences") }}
                    )
                where period = '000-026weeks'
            )
            pivot (count(date) for service in ('AM', 'PM'))
    )
order by grand_total desc, familiarity_score desc

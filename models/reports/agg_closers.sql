select dense_rank() over (order by `000-052weeks` desc) as rank, *
from
    (
        select
            *,
            coalesce(`000-052weeks`, 0)
            + coalesce(`052-104weeks`, 0)
            + coalesce(`104-156weeks`, 0)
            + coalesce(`156-208weeks`, 0) as grand_total
        from
            (
                select
                    title,
                    last_occurred_as_closer,
                    date,
                    {{ get_period("date", "week", 52, 8) }} as period
                from {{ ref("fact_song_occurrences") }}
                where closer_flag = '✅'
            ) pivot (
                count(date) for period
                in ('000-052weeks', '052-104weeks', '104-156weeks', '156-208weeks')
            )
    )
order by `000-052weeks` desc, last_occurred_as_closer desc

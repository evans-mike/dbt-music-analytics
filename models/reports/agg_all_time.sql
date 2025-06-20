select dense_rank() over (order by grand_total desc) as rank, *
from
    (
        select
            *,
            coalesce(`Within 1 Year`, 0)
            + coalesce(`1-2 Years Ago`, 0)
            + coalesce(`2-3 Years Ago`, 0)
            + coalesce(`3-4 Years Ago`, 0) as grand_total
        from
            (
                select
                    * except (period),
                    case
                        when period = '000-052weeks'
                        then 'Within 1 Year'
                        when period = '052-104weeks'
                        then '1-2 Years Ago'
                        when period = '104-156weeks'
                        then '2-3 Years Ago'
                        when period = '156-208weeks'
                        then '3-4 Years Ago'
                    end as period
                from
                    (
                        select
                            title,
                            last_occurred,
                            date,
                            {{ get_period("date", "week", 52, 8) }} as period
                        from {{ ref("fact_song_occurrences") }}
                    )
            ) pivot (
                count(date) for period
                in ('Within 1 Year', '1-2 Years Ago', '2-3 Years Ago', '3-4 Years Ago')
            )
    )
order by grand_total desc, last_occurred desc

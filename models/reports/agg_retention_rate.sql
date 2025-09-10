/* Compare individual song retention, period over period. e.g. What was retention rate from 4 periods ago to 3 years ago? Then to 2 years ago, and then to current year? */
with
    songs_by_period as (
        select {{ get_period("date", "week", 52, 8) }} as period, title
        from {{ ref("fact_song_occurrences") }}
        group by title, period
    ),
    period_map as (
        select dense_rank() over (order by period asc) as period_int, period
        from (select distinct period from songs_by_period)
    ),
    period_chain as (
        select period, lead(period) over (order by period_int) as next_period
        from period_map
    ),
    songs_retained as (
        select
            e1.period,
            e1.title,
            case when e2.title is not null then 1 else 0 end as retained_next_period
        from songs_by_period e1
        left join period_chain pc on pc.period = e1.period
        left join
            songs_by_period e2 on e2.title = e1.title and e2.period = pc.next_period
    )

-- select * from songs_by_period;
-- select * from period_map;
-- select * from period_chain;
-- select * from songs_retained;
select
    f.period,
    count(*) as songs_considered,
    sum(retained_next_period) as retained_count,
    round(100.0 * avg(retained_next_period), 2) as retention_rate_pct
from songs_retained f
join period_map pm on pm.period = f.period
group by period
order by
    period
    -- ;
    

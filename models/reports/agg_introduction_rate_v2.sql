with
    songs_by_period as (
        -- one row per (title, period)
        select distinct {{ get_period("date", "week", 52, 8) }} as period, title
        from {{ ref("fact_song_occurrences") }}
    ),
    period_map as (
        -- map each period label to an integer for ordering
        select period, dense_rank() over (order by period asc) as period_int
        from (select distinct period from songs_by_period)
    ),
    songs_with_int as (
        select sbp.title, sbp.period, pm.period_int
        from songs_by_period sbp
        join period_map pm on pm.period = sbp.period
    ),
    flags as (
        -- NEW this period if the previous row for this title is NOT the immediately
        -- prior period
        select
            period,
            title,
            case
                when
                    lead(period_int) over (partition by title order by period_int)
                    = period_int + 1
                then 0  -- continued from last period → not new
                else 1  -- first-ever or returning after a gap → new this period
            end as is_new_from_last_period
        from songs_with_int
    )
select
    f.period,
    count(*) as current_title_count,
    sum(f.is_new_from_last_period) as new_title_count,
    round(100.0 * avg(f.is_new_from_last_period), 2) as new_title_rate_pct  -- % of titles that are new vs last period
from flags f
group by f.period
order by f.period desc

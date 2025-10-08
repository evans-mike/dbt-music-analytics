with
    freq as (
        select
            {{ get_period("date", "week", 52, 8) }} as period,
            title,
            count(date) as count_per_title
        from {{ ref("fact_song_occurrences") }}  -- where is_christmas is null
        group by period, title
    ),
    mode_table as (
        -- mode of count_per_title per period
        select period, count_per_title as mode_frequency
        from
            (
                select
                    period,
                    count_per_title,
                    row_number() over (
                        partition by period order by count(*) desc, count_per_title desc
                    ) as rn
                from freq
                group by period, count_per_title
            )
        where rn = 1
    ),
    stats as (
        select
            period,
            avg(count_per_title) over (partition by period) as mean_frequency,
            percentile_cont(count_per_title, 0.5) over (
                partition by period
            ) as median_frequency
        from freq
    )
select
    s.period,
    round(any_value(s.mean_frequency), 2) as mean_frequency,  /* Mean (Average) */
    any_value(s.median_frequency) as median_frequency,  /* Median (50th Percentile) */
    m.mode_frequency  /* Mode (Most Frequent Value) */
from stats s
join mode_table m using (period)
group by s.period, m.mode_frequency
order by s.period

select
    (count(date)/count(distinct title)) occurrence_rate,
    {{ get_period("date", "month", 12, 24) }} as period,
from {{ ref("fact_song_occurrences") }}
group by period
order by period

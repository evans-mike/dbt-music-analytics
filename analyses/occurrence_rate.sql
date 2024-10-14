select
    (count(distinct title) / count(date)),
    {{ get_period("date", "month", 6, 24) }} as period,
from {{ ref("fact_song_occurrences") }}
group by period
order by period

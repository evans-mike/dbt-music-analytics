select
    {{ get_period("date", "week", 52, 8) }} as period,
    count(distinct title) count_unique_titles,
    count(1) count_occurrences
from {{ ref("fact_song_occurrences") }}
group by period
order by period

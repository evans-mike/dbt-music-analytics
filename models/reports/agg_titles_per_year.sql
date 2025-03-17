select period, count(distinct title) count_unique_titles
from {{ ref("fact_song_occurrences") }}
group by period
order by period

select period, count(1) count_occurrences
from {{ ref("fact_song_occurrences") }}
group by period
order by period

select familiarity_score, title, is_active as keep, count_occurrences, last_occurred
from {{ ref("dim_songs") }}
join
    (
        select title, count(date) count_occurrences
        from {{ ref("fact_song_occurrences") }}
        group by title
    ) using (title)
order by familiarity_score desc, title

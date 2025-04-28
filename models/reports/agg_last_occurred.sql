select title, last_occurred, freshness_score, from {{ ref("dim_songs") }} order by last_occurred, title

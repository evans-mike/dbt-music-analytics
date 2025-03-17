select title, last_occurred from {{ ref("dim_songs") }} order by last_occurred, title

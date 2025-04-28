select familiarity_score, title, last_occurred,  from {{ ref("dim_songs") }} order by familiarity_score desc, title

select title, is_corporate, familiarity_score, last_occurred,
from {{ ref("dim_songs") }}
order by is_corporate, title 

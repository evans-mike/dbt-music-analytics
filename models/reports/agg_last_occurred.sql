select title, is_active, last_occurred, familiarity_score
from {{ ref("dim_songs") }}
order by last_occurred, title

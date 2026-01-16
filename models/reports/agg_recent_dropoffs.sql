select title, is_active as keep, last_occurred, familiarity_score
from {{ ref("dim_songs") }}
where last_occurred < date_sub(current_date(), interval 1 year)

order by last_occurred desc
